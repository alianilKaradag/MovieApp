//
//  SearchResultsVC.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 18.03.2023.
//

import UIKit

class SearchResultsVC: UIViewController {
    
    private var medias = [Media]()
    
    private let resultTableView: UITableView = {
       
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(resultTableView)
        setDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultTableView.frame = view.bounds
    }
    
    func setDelegates(){
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    public func setMedias(_ medias: [Media]){
        self.medias = medias
        resultTableView.reloadData()
    }
    
}

extension SearchResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.identifier, for: indexPath) as? GeneralTableViewCell else {
            return UITableViewCell()
        }
       
        let media = medias[indexPath.row]
        let content = MediaViewModel(name: media.title ?? media.original_name ?? media.original_title ?? " ", posterPath: media.poster_path ?? " ")
        cell.setContents(content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
