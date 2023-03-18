//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 5.03.2023.
//

import UIKit


class HomeViewController: UIViewController {
    
    let sectionTitles :[String] = ["Movies", "Tv Series", "Top Rated Movies", "Upcoming Movies"]
    
    private let movieTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.topItem?.title = "Home"
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(movieTable)
        
        let headerView = SuggestionHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        movieTable.tableHeaderView = headerView
        
        setDelegates()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.movieTable.sectionFooterHeight = 20
        movieTable.frame = view.bounds
    }

    private func setDelegates(){
        movieTable.dataSource = self
        movieTable.delegate = self
    }
   
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let sectionIndex = indexPath.section
        APIManager.shared.getMedia(mediaType: MediaType(rawValue: MediaType.RawValue(sectionIndex)) ?? MediaType.Movie) { result in
                
            switch result{
                case .success(let medias):
                DispatchQueue.main.async {
                    cell.setMedias(medias: medias)
                }
                
                
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + safeAreaOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.localizedCapitalized
    }
    
}
