//
//  NewsManager.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 26/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation

protocol NewsManagerDelegate {
    func didUpdateNews(_ newsManager: NewsManager, news: [NewsModel])
    func didFailWithError(error: Error)
}

struct NewsManager {
    let newsURL = "https://newsapi.org/v2/top-headlines?apikey="
    var delegate: NewsManagerDelegate?
    
    func fetchNews(countryCode: String) {
        let newsKey = valueForAPIKey(named: "Key_News")
        let urlString = newsURL + newsKey + "&country=\(countryCode)"
        performRequest(with: urlString)
    }
    
    func valueForAPIKey(named keyname:String) -> String {
      let filePath = Bundle.main.path(forResource: "API_Keys", ofType: "plist")
      let plist = NSDictionary(contentsOfFile:filePath!)
      let value = plist?.object(forKey: keyname) as! String
      return value
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error is \(error)")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let newsArr = self.parseJSON(safeData) {
                        self.delegate?.didUpdateNews(self, news: newsArr)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ newsData: Data) -> [NewsModel]? {
        let decoder = JSONDecoder()
        do {
            print("inside parsejson")
            let decodedData = try decoder.decode(NewsData.self, from: newsData)
            var allNews = [NewsModel]()
            
            let status = decodedData.status
            if status != "ok" {
                let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: status])
                delegate?.didFailWithError(error: error)
                return nil
            }
            guard let totalResult = decodedData.totalResults else {
                return nil
            }
            
            var count = 0
            if totalResult > 10 {
                count = 11
            } else {
                count = totalResult
            }
            
            for index in 0...count {
                let title = decodedData.articles[index].title
                let description = decodedData.articles[index].description
                let url = decodedData.articles[index].url
                let imageURL = decodedData.articles[index].urlToImage
                
                let news = NewsModel(title: title, description: description, url: url, urlToImage: imageURL, count: count)
                allNews.append(news)
            }
            return allNews
        } catch {
            print("in catch error is \(error)")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}




