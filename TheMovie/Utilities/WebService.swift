//
//  WebService.swift
//  TheMovie
//
//  Created by dodets on 10/10/19.
//  Copyright © 2019 dodets. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON

class WebService: NSObject {
    enum HttpMethod {
        case get
        case post
    }
    
    public static let isDev = true
    
    public static let baseUrlDevelopment = "https://api.themoviedb.org/3/"
    public static let baseUrlProduction = "https://api.themoviedb.org/3/"
    public static let baseUrl = isDev ? baseUrlDevelopment : baseUrlProduction
    public static let baseImageUrl = "https://image.tmdb.org/t/p/w440_and_h660_face"
    
    public static let movieDBKey = "a6c3dfe81e72e6d38d64cd54eb6d51a4"
    public static let movieDBAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNmMzZGZlODFlNzJlNmQzOGQ2NGNkNTRlYjZkNTFhNCIsInN1YiI6IjVkOWVhYzBhZjA2NDdjMDAyOWNkYmYxNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.kY306zgL8Tew9gmaNT2fp28y9KiYHFuom55oRbCWEOA"
    
    static let GENRE_MOVIE_LIST = baseUrl + "genre/movie/list"
    static let DISCOVER_MOVIE = baseUrl + "discover/movie"
    
    static var manager: SessionManager!
    static var managerUpload: SessionManager!
    
    static let sharedInstance = WebService()
    
    class func Request(url: String, method: HttpMethod, parameters: [String: Any], headers: [String:String], loading: Bool, loadingString: String?, success: @escaping (JSON) -> Void, failure: @escaping (JSON) -> Void) {
        
        if manager == nil {
            let urlConfig = URLSessionConfiguration.default
            manager = SessionManager(configuration: urlConfig)
        }
        let request = manager.request(url, method: method == .post ? HTTPMethod.post : HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        if loading {
            SVProgressHUD.show()
        }
        print("-url: \n\(url)")
        print("-params: \n\(parameters)")
        print("-headers: \n\(headers)")
        request.responseJSON { (response) in
            if loading {
                SVProgressHUD.dismiss()
            }
            switch response.result {
            case .success(let values):
                let data = JSON(values)
                success(data)
            case .failure(let values):
                let data = JSON(values)
                print("-response: \n\(data)")
            }
        }
    }
}
