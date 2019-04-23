//
//  NetworkManager.swift
//  InterviewProject
//
//  Created by Nadeem Arain on 4/17/19.
//  Copyright © 2019 logics limited. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static var shared = NetworkManager()
    
    func getMovies(page: Int, completion:@escaping(_ moviesData: MovieModel?)->Void){
        
        let completeURL = AppConstants.MOVIES_URL + String(page)
        
        makeRequest(baseURL: AppConstants.BASE_URL, url: completeURL, method: .get, parameters: nil) { (status, response) in
            
            if status {
                guard let data = response.data else {
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(MovieModel.self, from: data)
                    completion(movies)
                    
                } catch {
                    print(error)
                    completion(nil)
                }
                
            }else {
                completion(nil)
            }
        }
    }

    func getMovieDetail(movieId: Int, completion:@escaping(_ movieData: MovieDetailModel?)->Void){
        
        let completeURL = String(format: AppConstants.MOVIE_DETAIL_URL, movieId)
        
        makeRequest(baseURL: AppConstants.BASE_URL, url: completeURL, method: .get, parameters: nil) { (status, response) in
            
            if status {
                guard let data = response.data else {
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(MovieDetailModel.self, from: data)
                    completion(movie)
                    
                } catch {
                    print(error)
                    completion(nil)
                }
                
            }else {
                completion(nil)
            }
        }
    }
    
    func getVideos(movieId: Int, completion:@escaping(_ moviesData: VideoModel?)->Void){
        
        let completeURL = String(format: AppConstants.VIDEOS_URL, movieId)

        makeRequest(baseURL: AppConstants.BASE_URL, url: completeURL, method: .get, parameters: nil) { (status, response) in
            
            if status {
                guard let data = response.data else {
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let videos = try decoder.decode(VideoModel.self, from: data)
                    completion(videos)
                    
                } catch {
                    print(error)
                    completion(nil)
                }
                
            }else {
                completion(nil)
            }
        }
    }
    
    func makeRequest(baseURL: String, url: String, method: HTTPMethod, parameters: [String: Any]?, completion:@escaping(_ status: Bool, _ response: DataResponse<Data>) -> Void) {

        guard let url = URL(string: baseURL + url) else {
            return
        }

        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in

            if response.error != nil {
                print("error=\(String(describing: response.error))")
                completion(false, response)
                return
            }

            let statusCode = response.response?.statusCode

            if statusCode != 200 && statusCode != 201 {
                completion(false, response)
                return
            }
            
            // success no errors
            completion(true, response)
        }
    }
}
