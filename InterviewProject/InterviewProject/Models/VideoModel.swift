//
//  VideoModel.swift
//  InterviewProject
//
//  Created by Nadeem Arain on 4/17/19.
//  Copyright © 2019 logics limited. All rights reserved.
//

import Foundation

struct VideoModel: Codable {
    let results: [Result]
}

struct Result: Codable {
    let key: String
}
