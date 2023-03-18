//
//  SearchTableViewCell.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 17.03.2023.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {

   static let identifier = "generalTableViewCell"
    
    private let cellImageView: UIImageView = {
        let cellImage = UIImageView()
        cellImage.contentMode = .scaleAspectFill
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        return cellImage
    }()
    
    private let cellLabel: UILabel = {
        let cellLabel = UILabel()
        cellLabel.numberOfLines = 0
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        return cellLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellImageView)
        contentView.addSubview(cellLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints(){
        let cellImageViewConstraints = [
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cellImageView.widthAnchor.constraint(equalToConstant: 90)
            
        ]
        
        let cellLabelConstraints = [
            cellLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 10),
            cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        ]
        
        NSLayoutConstraint.activate(cellImageViewConstraints)
        NSLayoutConstraint.activate(cellLabelConstraints)
    }
    
    public func setContents(_ mediaModel: MediaViewModel){
        guard let url = URL(string: "\(Constants.posterBaseUrl)\(mediaModel.posterPath)") else {
        
            return
        }
            
        cellImageView.kf.setImage(with: url)
        cellLabel.text = mediaModel.name
    }
    
}
