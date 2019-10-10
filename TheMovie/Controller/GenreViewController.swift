//
//  GenreViewController.swift
//  TheMovie
//
//  Created by dodets on 10/10/19.
//  Copyright © 2019 dodets. All rights reserved.
//

import Foundation
import UIKit

struct Genre {
    
    var id : Int
    var name : String
}

class GenreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var listGenre = [Genre]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Genre"
        getDataGenre()
    }
    
    func getDataGenre() {
        
        let params = [
            "api_key":WebService.movieDBKey
        ]
        WebService.Request(url: WebService.GENRE_MOVIE_LIST, method: .get, parameters: params, headers: [:], loading: false, loadingString: nil, success: { (response) in
            let datas = response["genres"].arrayValue
            for data in datas {
                let data = Genre.init(id: data["id"].intValue,
                                       name: data["name"].stringValue)
                self.listGenre.append(data)
            }
            self.tableView.reloadData()
        }) { (response) in
            
        }
    }
    
    @IBAction func showGenre(_ sender: UIBarButtonItem) {
        let detailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "genre") as! GenreViewController
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

extension GenreViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGenre.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! dataCell
        
        let data = listGenre[indexPath.row]
        cell.titleLabel.text = data.name
        
        return cell
    }
    
    
}

extension GenreViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = listGenre[indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name("changeGenre"), object: data)
        self.navigationController?.popViewController(animated: true)
    }
}
