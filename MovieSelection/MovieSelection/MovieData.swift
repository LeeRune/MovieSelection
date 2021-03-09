//
//  MovieData.swift
//  MovieSelection
//
//  Created by 李易潤 on 2021/3/2.
//

import Foundation

//取得電影資料
struct MoviesData: Codable {
    var title: String?
    var vote_average: Double?
    var release_date: String?
    var poster_path: String?
    var backdrop_path: String?
    var overview: String?
}

struct Film: Codable {
    var results:[MoviesData]
}

//電影相關圖片size

struct ImageInfo: Codable {
    var base_url:String?
    var poster_sizes:[ImageInfo]
}

struct ImageSize: Codable{
    var w500:String
    var original:String
}

