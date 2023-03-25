//
//  SearchResultsVC.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 18.03.2023.
//

import UIKit

protocol SearchResultPressedDelegate: AnyObject{
    func searchResultPressed(_ trailerViewModel: TrailerViewModel)
}

class SearchResultsVC: UIViewController {
    
    weak var delegate: SearchResultPressedDelegate?
    
    private var tmdbMedias = [TmdbMedia]()
    
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
    
    public func setMedias(_ medias: [TmdbMedia]){
        self.tmdbMedias = medias
        resultTableView.reloadData()
    }
    
}

extension SearchResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmdbMedias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.identifier, for: indexPath) as? GeneralTableViewCell else {
            return UITableViewCell()
        }
       
        let media = tmdbMedias[indexPath.row]
        let content = TmdbMediaViewModel(name: media.title ?? media.original_name ?? media.original_title ?? " ", posterPath: media.poster_path ?? " ")
        cell.setContents(content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultTableView.deselectRow(at: indexPath, animated: true)
        let tmdbMedia = tmdbMedias[indexPath.row]
        guard let poster_path = tmdbMedia.poster_path else { return }
        let title = tmdbMedia.original_title ?? tmdbMedia.title ?? tmdbMedia.original_name ?? ""
        let overView = tmdbMedia.overview ?? ""
        
        APIManager.shared.searchForYoutube("\(title) official trailer") { [weak self] response in
            switch response{
            case .success(let result):
                let trailerVM = TrailerViewModel(title: title, youtubeView: result, titlerOverView: overView, id: tmdbMedia.id, poster_path: poster_path)
                self?.delegate?.searchResultPressed(trailerVM)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
}
