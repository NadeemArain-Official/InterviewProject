//
//  MoviesVC.swift
//  InterviewProject
//
//  Created by Nadeem Arain on 4/16/19.
//  Copyright © 2019 logics limited. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesVC: UIViewController {
    
    //MARK: - Instance Variables

    @IBOutlet weak var searchBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies = [Movie]()
    var tempMovies = [Movie]()
    
    var pageNo = 1
    let operationQueue = OperationQueue()
    var isSearching = Bool()
    
    //MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loadMoviesFromNetwork(page: pageNo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            movies = tempMovies
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: - Helper Methods

    func loadMoviesFromNetwork(page: Int) {
        
        // Network Check
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            NetworkManager.shared.getMovies(page: page) { (moviesData) in
                SwiftLoader.hide()
                guard let data = moviesData else {return}
                self.movies.append(contentsOf: data.results ?? [Movie]())
                self.tempMovies = self.movies
                self.tableView.reloadData()
            }
        }else {
            AppUtility.shared.displayAlert(title: "", messageText: "No network connection", delegate: self)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.searchBarBottomConstraint.constant = keyboardHeight - 34
            isSearching = true
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        searchBarBottomConstraint.constant = 0
        isSearching = false

    }
    
    func hideKeyboard() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension MoviesVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !isSearching {
            //Load more movies
            let lastMovie = movies.count - 1
            if indexPath.row == lastMovie {
                pageNo += 1
                loadMoviesFromNetwork(page: pageNo)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        let posterPath = movie.posterPath ?? ""
        let urlStr = AppConstants.IMAGES_BASE_URL + posterPath
        let url = URL(string: urlStr)
        
        operationQueue.addOperation { () -> Void in
            cell.movieIV.sd_setImage(with: url, completed: nil)
        }
        cell.movieTitle.text = movie.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        hideKeyboard()
        let movie = movies[indexPath.row]
        let story = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = story.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        detailVC.movieId = movie.id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension MoviesVC: UISearchBarDelegate {
    
    // MARK: - Search Bar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            self.movies = self.tempMovies
            self.tableView.reloadData()
        }else {
            beginSearching(searchText: searchText)
        }
    }
    
    func beginSearching(searchText:String) {
        self.movies = self.tempMovies.filter {$0.title!.contains(searchText)}
        self.tableView.reloadData()
    }
}

