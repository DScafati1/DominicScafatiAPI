//
//  MoviesViewController.swift
//  DominicScafatiAPI
//
//  Created by Dom Scafati on 8/13/21.
//

import UIKit

protocol MoviesViewControllerProttocol: class {
    func refreshUI()
    func showError(message:String)
}

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var moviesViewModel:MoviesViewModel<Service<MovieResult>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesViewModel = MoviesViewModel(delegate:self, service: Service())
        
    }
}

extension MoviesViewController: MoviesViewControllerProttocol {
    func showError(message: String) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title:"Error", message:message, preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title:"Ok", style: UIAlertAction.Style.cancel, handler: { (alert) in
                alertViewController.dismiss(animated:true, completion:nil)
            })
            alertViewController.addAction(alertAction)
            self.present(alertViewController, animated:true, completion:nil)
        }
    }
    
    func refreshUI() {
        tableView.reloadData()
    }
}

extension MoviesViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        moviesViewModel.searchMovies(searchText: searchBar.text)
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesViewModel.numberofMovies
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"movieTableViewCell", for:indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = moviesViewModel.getMovie(for: indexPath.row)
        cell.setMovieData(movie: movie)
        return cell
    }
}


