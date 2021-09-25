//
//  FirstViewController.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 24/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import UIKit
import SpinningIndicator
import SlideMenuControllerSwift



class NewsViewController: UIViewController {
    
    //    @IBOutlet weak var scrollView: UIScrollView!
    //    @IBOutlet weak var sView: UIView!
    //    @IBOutlet weak var newsImageView: UIImageView!
    //    @IBOutlet weak var newsHeadlineLabel: UILabel!
    //    @IBOutlet weak var newsTableView: UITableView!
    //    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sView: UIView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsHeadlineLabel: UILabel!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var sViewHeightConstraint: NSLayoutConstraint!
    
    var newsManager = NewsManager()
    var allNewsArr = [NewsModel]()
    var indicator: SpinningIndicator?
    var aURL: URL?
    let settingsLauncher = SettingsLauncher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        self.newsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        newsManager.delegate = self
        settingsLauncher.settingDelegate = self
        
        //self.tableViewHeightConstraint.constant = 500
        newsImageView.backgroundColor = .white
        //newsImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin]
        newsImageView.contentMode = .scaleAspectFill
        self.newsTableView.isScrollEnabled = false
        self.scrollView.isScrollEnabled = true
        
        let moreIconImage = UIImage(named: "more24")
        //self.navigationController?.navigationBar.backgroundColor = UIColor.black
        let navBar = self.navigationController?.navigationBar
        if (navBar != nil) {
            navBar?.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.1568627451, blue: 0.3137254902, alpha: 1)
            navBar?.tintColor = UIColor.white
            navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: moreIconImage, style: .plain, target: self, action: #selector(settingTapped))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(newsImageTapped))
        newsImageView.addGestureRecognizer(tap)
        newsImageView.isUserInteractionEnabled = true
        
        if let cCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print("countrycode is \(cCode)")
            
            if Reachability.isInternetAvailable() {
                print("internet is available")
                
                self.indicator = SpinningIndicator(frame: UIScreen.main.bounds)
                if self.indicator != nil {
                    view.addSubview(self.indicator!)
                    self.indicator!.addCircle(lineColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), lineWidth: 2, radius: 16, angle: 0)
                    self.indicator!.beginAnimating()
                }
                newsManager.fetchNews(countryCode: cCode)
            } else {
                let noNwView = UIView()
                self.view.addSubview(noNwView)
                let label = UILabel()
                noNwView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                label.widthAnchor.constraint(equalToConstant: 300).isActive = true
                label.heightAnchor.constraint(equalToConstant: 200).isActive = true
                label.text = "No network connection, please connect to network and try again!"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 20)
                label.numberOfLines = 0
                label.textColor = UIColor.white
                
                noNwView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                noNwView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.1568627451, blue: 0.3137254902, alpha: 1)
                
                // create the alert
                let alert = UIAlertController(title: "Network Error", message: "No internet connection", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func newsImageTapped() {
        self.aURL = self.allNewsArr[0].url
        self.performSegue(withIdentifier: "goToNewsWebview", sender: self)
    }
    
    @objc func settingTapped() {
        settingsLauncher.showSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewsWebview" {
            let destinationView = segue.destination as! NewsWebViewController
            // let destinationView = navigationView.topViewController as! NewsWebViewController
            destinationView.url = self.aURL
        }
    }
}

extension NewsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNewsArr.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! NewsCell
        cell.label.text = allNewsArr[indexPath.row + 1].title
        if let urlStr = self.allNewsArr[indexPath.row + 1].urlToImage {
            if let imageURL = URL(string: urlStr) {
                cell.rightImageView.load(url: imageURL)
            }
        }
        //cell.textLabel?.text = allNewsArr[indexPath.row].title
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselect row is clicked")
        self.aURL = self.allNewsArr[indexPath.row + 1].url
        self.performSegue(withIdentifier: "goToNewsWebview", sender: self)
    }
}

extension NewsViewController: NewsManagerDelegate {
    
    func didUpdateNews(_ newsManager: NewsManager, news: [NewsModel]) {
        allNewsArr = news
        
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
            self.newsHeadlineLabel.text = self.allNewsArr[0].title
            if let urlStr = self.allNewsArr[0].urlToImage {
                if let imageURL = URL(string: urlStr) {
                    self.newsImageView.load(url: imageURL)
                }
            }
            
            if self.indicator != nil {
                self.indicator!.endAnimating()
                self.indicator!.removeFromSuperview()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            if self.indicator != nil {
                self.indicator!.endAnimating()
                self.indicator!.removeFromSuperview()
            }
            // create the alert
            let alert = UIAlertController(title: "Error!", message: "Error in getting news, please try after some time", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}


extension NewsViewController: SettingLauncherDelegate {
    
    func settingItemSelected(item: Int) {
       // let aboutUsController = AboutUsViewController()
      //  self.navigationController?.pushViewController(aboutUsController, animated: true)
        if item == 0 {
            performSegue(withIdentifier: "goToAboutUsFromNews", sender: self)
        } else if item == 1 {
             performSegue(withIdentifier: "goTocreditsFromNews", sender: self)
        } else if item == 2 {
             performSegue(withIdentifier: "goToPrivacyFromNews", sender: self)
        }
        
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
