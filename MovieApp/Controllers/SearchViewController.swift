//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 5.03.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var medias = [Media]()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        navigationController?.navigationBar.topItem?.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationItem.largeTitleDisplayMode = .always //always
        
        view.addSubview(searchTable)
        setDelegates()
        searchMedia()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }

    private func setDelegates(){
        searchTable.delegate = self
        searchTable.dataSource = self
    }
    
    private func searchMedia(){
        APIManager.shared.searchMedia { [weak self] results in
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else{
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
