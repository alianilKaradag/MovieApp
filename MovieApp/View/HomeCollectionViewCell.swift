//
//  MediaCollectionViewCell.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 16.03.2023.
//


import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "mediaCollectionViewCell"
    
    private let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mediaImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mediaImageView.frame = contentView.bounds
    }
    
    func setImage(_ posterPath: String){
        guard let url = URL(string: "\(Constants.tmdbPosterBaseUrl)\(posterPath)") else {
            print("image url creation error")
            return
        }
      
        mediaImageView.kf.setImage(with: url)
    }
}
