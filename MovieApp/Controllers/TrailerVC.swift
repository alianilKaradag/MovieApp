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
    
    private let overViewScroll: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isScrollEnabled = true

        return scroll
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
        view.addSubview(overViewScroll)
        overViewScroll.addSubview(overViewLabel)
        view.addSubview(likeButton)
        setLikeButtonImage("hand.thumbsup")
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.tintColor = .label
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
        
        let scrollViewConstraints = [
            overViewScroll.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            overViewScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            overViewScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overViewScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        
        //let stackViewConstraints = [
        //    ovewViewStack.topAnchor.constraint(equalTo: overViewScroll.topAnchor),
        //    ovewViewStack.bottomAnchor.constraint(equalTo: overViewScroll.bottomAnchor),
        //    ovewViewStack.leadingAnchor.constraint(equalTo: overViewScroll.leadingAnchor),
        //    ovewViewStack.trailingAnchor.constraint(equalTo: overViewScroll.trailingAnchor)
        //]
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: overViewScroll.topAnchor),
            overViewLabel.bottomAnchor.constraint(equalTo: overViewScroll.bottomAnchor),
            overViewLabel.leadingAnchor.constraint(equalTo: overViewScroll.leadingAnchor),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        
        let likeButtonConstraints = [
            likeButton.centerYAnchor.constraint(equalTo: overViewScroll.bottomAnchor, constant: 30),
            likeButton.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ]
        
        
        //let height = overViewLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
         //overViewLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(scrollViewConstraints)
        //NSLayoutConstraint.activate(stackViewConstraints)
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
                    if liked {
                        self.setLikeButtonImage(self.likeButtonImageFillName)
                    }
                    else{
                        self.setLikeButtonImage(self.likeButtonImageDefaultName)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func likeButtonPressed(){
        
        guard let trailerVM = trailerViewModel else { return }

        if !isLiked{
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
            LocalDataManager.shared.deleteMedia(trailerVM.id) { response in
                switch response{
                case .success(()):
                    print("Succesfully deleted the Media")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        checkLikeStatus()
        
    }
    
}


