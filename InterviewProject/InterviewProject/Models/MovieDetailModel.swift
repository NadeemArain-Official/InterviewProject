//
//  MovieDetailModel.swift
//  InterviewProject
//
//  Created by Nadeem Arain on 4/17/19.
//  Copyright © 2019 logics limited. All rights reserved.
//

import Foundation

struct MovieDetailModel: Codable {
    let id: Int?
    let title, overview: String?
    let posterPath, releaseDate: String?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, genres, overview, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
