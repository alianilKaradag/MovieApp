//
//  SuggestionHeaderUIView.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 12.03.2023.
//

import UIKit

protocol SuggestionViewPlayButtonDelegate: AnyObject {
    func suggestionViewPlayButtonPressed(viewModel: TrailerViewModel)
}

class SuggestionHeaderUIView: UIView {
    
    private var suggestionMovie: TmdbMedia?
    
    weak var delegate: SuggestionViewPlayButtonDelegate?
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let suggestionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.image = UIImage(named: "suggestionImage")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(suggestionImageView)
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
       
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
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            playButton.widthAnchor.constraint(equalToConstant: 150),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(playButtonContsraints)
     
    }
    
    func setContent(_ tmdbMedia: TmdbMedia){
        guard let url = URL(string: "\(Constants.tmdbPosterBaseUrl)\(tmdbMedia.poster_path ?? " ")") else { return }
        suggestionImageView.kf.setImage(with: url)
        suggestionMovie = tmdbMedia
    }
    
    
    @objc func playButtonPressed(){
        
        buttonClickAnim(playButton)
        guard let suggestionMovie = self.suggestionMovie else {return}
        guard let poster_path = suggestionMovie.poster_path else { return }
        
        APIManager.shared.searchForYoutube("\(Constants.suggestionMovieName) official trailer") { response in
            switch response{
            case .success(let result):
                let trailerViewModel = TrailerViewModel(title: Constants.suggestionMovieName, youtubeView: result, titlerOverView: suggestionMovie.overview ?? "", id: suggestionMovie.id, poster_path: poster_path)
                self.delegate?.suggestionViewPlayButtonPressed(viewModel: trailerViewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func buttonClickAnim(_ button: UIButton){
        UIView.animate(withDuration: 0.05,
            animations: {
                button.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.05) {
                    button.transform = CGAffineTransform.identity
                }
            })
    }
}


