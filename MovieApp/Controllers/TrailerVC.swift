//
//  TrailerVC.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 21.03.2023.
//

import UIKit
import WebKit

class TrailerVC: UIViewController {
    
    private let webView: WKWebView = {
       let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .black
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.text = "Place Holder"
        return label
    }()

    private let overViewLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Learn how to use Swift 5, UIKit, and Xcode to develop iOS apps by building a Netflix clone. You will learn how to implement the MVVM design pattern."
        return label
    }()
    
    private let likeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
        let buttonImage = UIImage(systemName: "hand.thumbsup", withConfiguration: buttonConfig)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .label
        button.layer.masksToBounds = true
        return button
    }()
    
    private let dislikeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
        let buttonImage = UIImage(systemName: "hand.thumbsdown", withConfiguration: buttonConfig)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(likeButton)
        view.addSubview(dislikeButton)
        
        setConstraints()
        print(view.bounds.height)
    }
    
    func setConstraints(){
        let webViewConstraints = [
            webView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.4),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let likeButtonConstraints = [
            likeButton.centerYAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 50),
            likeButton.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ]
        
        let dislikeButtonConstraints = [
            dislikeButton.centerYAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 50),
            dislikeButton.centerXAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 60)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(dislikeButtonConstraints)
    }

    
    func setContent(_ trailerViewModel: TrailerViewModel){
        titleLabel.text = trailerViewModel.title
        overViewLabel.text = trailerViewModel.titlerOverView
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(trailerViewModel.youtubeView.id.videoId)") else {return}
        
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
 
    }
    
}

