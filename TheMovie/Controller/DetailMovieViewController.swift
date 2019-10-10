//
//  DetailMovieViewController.swift
//  TheMovie
//
//  Created by dodets on 10/10/19.
//  Copyright © 2019 dodets. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class DetailMovieViewController : UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var movieData : [Movie]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getDetailMovie()
    }
    
    @objc func getDetailMovie() {
        
        let params = [
            "api_key":WebService.movieDBKey
        ]
        WebService.Request(url: WebService.DISCOVER_MOVIE, method: .get, parameters: params, headers: [:], loading: false, loadingString: nil, success: { (response) in
            let datas = response["results"].arrayValue
            self.tableView.reloadData()
        }) { (response) in
            
        }
    }
}

extension DetailMovieViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! dataCell
        
//        let data = movies[indexPath.row]
//        cell.titleLabel.text = data.title
//        if  !(data.imageURL.isEmpty) {
//            cell.bgImage.af_setImage(withURL: URL(string: WebService.baseImageUrl + data.imageURL)!,
//                                     placeholderImage: UIImage(named: "placeholderImage"))
//        }
        
        return cell
    }
    
    
}

extension DetailMovieViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}
