//
//  TrailerVC.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 21.03.2023.
//

import UIKit
import WebKit


class TrailerVC: UIViewController {
    
    private var trailerViewModel: TrailerViewModel?
    private let likeButtonImageDefaultName = "hand.thumbsup"
    private let likeButtonImageFillName = "hand.thumbsup.fill"
    private var isLiked: Bool = false
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
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
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ullamcorper posuere turpis, et tempus leo placerat suscipit. Aenean sapien ex, semper id blandit nec, sollicitudin at mauris."
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.layer.masksToBounds = true
        return button
    }()
    
    private func setLikeButtonImage(_ imageName: String) {
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
        let buttonImage = UIImage(systemName: imageName, withConfiguration: buttonConfig)
        likeButton.setImage(buttonImage, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(likeButton)
        setLikeButtonImage("hand.thumbsup")
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        setConstraints()
        print(view.bounds.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.tintColor = .label
        //navigationController?.navigationItem.hidesBackButton = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLikeStatus()
    }
    
    func setConstraints(){
        let webViewConstraints = [
            webView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.4),
            webView.topAnchor.constraint(equalTo: navigationController?.navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 30),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            overViewLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let likeButtonConstraints = [
            likeButton.centerYAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 50),
            likeButton.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ]
        
        
        let height = overViewLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
         overViewLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        
    }
    
    func setContent(_ trailerViewModel: TrailerViewModel){
        self.trailerViewModel = trailerViewModel
        titleLabel.text = trailerViewModel.title
        overViewLabel.text = trailerViewModel.titlerOverView
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(trailerViewModel.youtubeView.id.videoId)") else {return}
        
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    private func checkLikeStatus(){
        guard let trailerVM = trailerViewModel else { return }
        LocalDataManager.shared.hasLikedBefore(trailerVM.id) { response in
            switch response{
            case .success(let liked):
                DispatchQueue.main.async {
                    self.isLiked = liked

                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    @objc func likeButtonPressed(){
        
        guard let trailerVM = trailerViewModel else { return }
        
        checkLikeStatus()
        
        if !isLiked{
            setLikeButtonImage(likeButtonImageFillName)
            LocalDataManager.shared.likeMedia(trailerVM) { response in
                switch response {
                case .success():
                    print("Succesfully saved the Media")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        else{
            setLikeButtonImage(likeButtonImageDefaultName)
            LocalDataManager.shared.deleteMedia(trailerVM.id) { response in
                switch response{
                case .success(()):
                    print("Succesfully deleted the Media")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
        
    }
    
}

