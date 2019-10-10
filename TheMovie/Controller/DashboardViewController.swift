//
//  ViewController.swift
//  TheMovie
//
//  Created by dodets on 10/10/19.
//  Copyright © 2019 dodets. All rights reserved.
//

import UIKit
import AlamofireImage

struct Movie {
    
    var id : Int
    var title : String
    var text : String
    var imageURL : String
}

class DashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var movies = [Movie]()
    var genre = [Genre]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TheMovie"
        getData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: NSNotification.Name("changeGenre"), object: nil)
    }
    
    private func goToNextPage(detail: Movie) {
//        let detailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailView") as! DetailViewController
//        detailView.movieTitle = detail.title
//        detailView.movieDesc = detail.text
//        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @objc func onDidReceiveData(_ notification: Notification)
    {
        
        
    }
    
    @objc func getData() {
        
        let params = [
            "api_key":WebService.movieDBKey
        ]
        WebService.Request(url: WebService.DISCOVER_MOVIE, method: .get, parameters: params, headers: [:], loading: false, loadingString: nil, success: { (response) in
            let datas = response["results"].arrayValue
            for data in datas {
                let movie = Movie.init(id: data["id"].intValue,
                                       title: data["title"].stringValue,
                                       text: data["overview"].stringValue, imageURL: data["poster_path"].stringValue)
                self.movies.append(movie)
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

extension DashboardViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! dataCell
        
        let data = movies[indexPath.row]
        cell.titleLabel.text = data.title
        if  !(data.imageURL.isEmpty) {
            cell.bgImage.af_setImage(withURL: URL(string: WebService.baseImageUrl + data.imageURL)!,
                                     placeholderImage: UIImage(named: "placeholderImage"))
        }
        
        return cell
    }
    
    
}

extension DashboardViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = movies[indexPath.row]
        let detailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailMovie") as! DetailMovieViewController
        detailView.movieData = [data]
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

