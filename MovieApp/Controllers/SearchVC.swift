//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 5.03.2023.
//

import UIKit

class SearchVC: UIViewController {
    
    private var tmdbMedias = [TmdbMedia]()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsVC())
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .prominent
        
        return searchController
    }()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.topItem?.title = "Search"
        navigationController?.navigationBar.tintColor = .label
        
        view.addSubview(searchTable)
        setDelegates()
        discoverMedias()
        navigationItem.searchController = searchController
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    private func setDelegates(){
        searchTable.delegate = self
        searchTable.dataSource = self
        searchController.searchResultsUpdater = self
    }
    
    private func discoverMedias(){
        APIManager.shared.fillSearchVCTrends { [weak self] response in
            switch response{
            case .success(let resultMedia):
                DispatchQueue.main.async {
                    self?.tmdbMedias = resultMedia
                    self?.searchTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsVC else {return}
        
        resultController.delegate = self
        
        APIManager.shared.searchForTmdb(query) { response in
            DispatchQueue.main.async {
                switch response{
                case .success(let medias):
                    resultController.setMedias(medias)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmdbMedias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.identifier, for: indexPath) as? GeneralTableViewCell else{
            return UITableViewCell()
        }
        
        let media = tmdbMedias[indexPath.row]
        let content = TmdbMediaViewModel(name: media.original_name ?? media.original_title ?? "?", posterPath: media.poster_path ?? "?")
        cell.setContents(content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTable.deselectRow(at: indexPath, animated: true)
        
        let tmdbMedia = tmdbMedias[indexPath.row]
        guard let tmdbMediaName = tmdbMedia.original_title ?? tmdbMedia.original_name ?? tmdbMedia.original_title else {return}
        guard let tmdbMediaOverview = tmdbMedia.overview else {return}
        guard let poster_path = tmdbMedia.poster_path else {return}
        
        APIManager.shared.searchForYoutube(tmdbMediaName + " official trailer") { [weak self] response in
            
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    let trailerViewModel = TrailerViewModel(title: tmdbMediaName, youtubeView: result, titlerOverView: tmdbMediaOverview, id: tmdbMedia.id, poster_path: poster_path)
                    guard let strongSelf = self else {return}
                    let trailerVC = TrailerVC()
                    trailerVC.setContent(trailerViewModel)
                    strongSelf.navigationController?.pushViewController(trailerVC, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}

extension SearchVC: SearchResultPressedDelegate{
    func searchResultPressed(_ trailerViewModel: TrailerViewModel) {
        let trailerVC = TrailerVC()
        trailerVC.setContent(trailerViewModel)
        self.navigationController?.pushViewController(trailerVC, animated: true)
        
    }
    
    
}
