//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 5.03.2023.
//

import UIKit

class SearchVC: UIViewController {
    
    private var medias = [Media]()
    
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
        APIManager.shared.getDiscoverMedia { [weak self] results in
            switch results{
            case .success(let resultMedia):
                self?.medias = resultMedia
                DispatchQueue.main.async {
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
        
        APIManager.shared.search(query) { results in
            DispatchQueue.main.async {
                switch results{
                case .success(let medias):
                    resultController.setMedias(medias)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.identifier, for: indexPath) as? GeneralTableViewCell else{
            return UITableViewCell()
        }
        
        let media = medias[indexPath.row]
        let content = MediaViewModel(name: media.original_name ?? media.original_title ?? "?", posterPath: media.poster_path ?? "?")
        cell.setContents(content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
