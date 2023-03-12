//
//  SuggestionHeaderUIView.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 12.03.2023.
//

import UIKit

class SuggestionHeaderUIView: UIView {
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let suggestionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "suggestionImage")
        return imageView
    }()
    
   /* private let seperatorView: UIView = {
        let seperator = UIView()
        seperator.backgroundColor = .systemBackground
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
        return seperator
    }()*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(suggestionImageView)
        //addGradient()
        addSubview(playButton)
        //addSubview(seperatorView)
        setContsraints()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        suggestionImageView.frame = bounds
    }
    
    
    private func setContsraints(){
        let playButtonContsraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 160),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(playButtonContsraints)
        
        
        
       /* let seperatorConstraints = [
            seperatorView.topAnchor.constraint(equalTo: suggestionImageView.bottomAnchor, constant: 0),
            seperatorView.widthAnchor.constraint(equalToConstant: bounds.width),
            seperatorView.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(seperatorConstraints)*/
        
    }
    
    @objc private func playButtonPressed(){
        print("basıldı")
    }
}


