//
//  CollectionTableViewCell.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 7.03.2023.
//

import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func homeTableViewCellDidTapCell(_ cell: HomeTableViewCell, viewModel: TrailerViewModel)
}

class HomeTableViewCell: UITableViewCell {
    
    weak var delegate: HomeTableViewCellDelegate?
    
    static let identifier = "tableViewCell"
    
    private var tmdbMedias = [TmdbMedia]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 125, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setMedias(medias: [TmdbMedia]){
        self.tmdbMedias = medias
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmdbMedias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let posterPath = tmdbMedias[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        
        cell.setImage(posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let tmdbMedia = tmdbMedias[indexPath.row]
        guard let tmdbMediaName = tmdbMedia.original_title ?? tmdbMedia.original_name ?? tmdbMedia.original_title else {return}
        guard let tmdbMediaOverview = tmdbMedia.overview else {return}
        
        APIManager.shared.searchForYoutube(tmdbMediaName + " official trailer") { [weak self] result in
            
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    let trailerViewModel = TrailerViewModel(title: tmdbMediaName, youtubeView: result, titlerOverView: tmdbMediaOverview)
                    guard let strongSelf = self else {return}
                    self?.delegate?.homeTableViewCellDidTapCell(strongSelf, viewModel: trailerViewModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
