//
//  NewsData.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 27/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation

struct NewsData: Codable {
    
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: String?
   // let publishedAt: Date
}

struct Source: Codable {
    let id: String?
    let name: String?
}
