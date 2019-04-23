//
//  AppConstants.swift
//  InterviewProject
//
//  Created by Nadeem Arain on 4/17/19.
//  Copyright © 2019 logics limited. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    
    
    static let BASE_URL        = "https://api.themoviedb.org/3"
    static let IMAGES_BASE_URL = "http://image.tmdb.org/t/p/w342"
    static let MOVIES_API_KEY  = "79543df0996a32087caf4cb08bb794cf"
    
    static let MOVIES_URL = "/movie/popular?api_key=\(MOVIES_API_KEY)&page="
    static let MOVIE_DETAIL_URL = "/movie/%i?api_key=" + MOVIES_API_KEY
    static let VIDEOS_URL = "/movie/%i/videos?api_key=" + MOVIES_API_KEY
    
    struct Colors {
        static let primary = UIColor(hex: "08486F")
    }
    
}
