//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 5.03.2023.
//

import UIKit


class HomeVC: UIViewController {
    
    let sectionTitles :[String] = ["Movies", "Tv Series", "Top Rated Movies", "Upcoming Movies"]
    var suggestionMovie: TmdbMedia?
    
    
    let suggestionHeaderView: SuggestionHeaderUIView = {
        let headerView = SuggestionHeaderUIView(frame: .zero)
        
        return headerView
    }()
    
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
        
        movieTable.tableHeaderView = suggestionHeaderView
        setDelegates()
        setSuggestion()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.movieTable.sectionFooterHeight = 20
        movieTable.frame = view.bounds
        suggestionHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 500)
    }
    
    private func setDelegates(){
        movieTable.dataSource = self
        movieTable.delegate = self
        suggestionHeaderView.delegate = self
    }
    
    func setSuggestion(){
        
        APIManager.shared.searchForTmdb(Constants.suggestionMovieName) { response in
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    self.suggestionMovie = TmdbMedia(id: result[0].id, title: result[0].title, original_title: result[0].original_title, original_name: result[0].original_name, poster_path: result[0].poster_path, overview: result[0].overview)
                    self.suggestionHeaderView.setContent(self.suggestionMovie!)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    
    
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
        APIManager.shared.fetchTmdbMedia(mediaType: MediaType(rawValue: MediaType.RawValue(sectionIndex)) ?? MediaType.Movie) { response in
            
            switch response{
            case .success(let medias):
                DispatchQueue.main.async {
                    cell.setMedias(medias: medias)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        cell.delegate = self
        
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

extension HomeVC: HomeTableViewCellDelegate{
    
    func homeTableViewCellDidTapCell(_ cell: HomeTableViewCell, viewModel: TrailerViewModel) {
        let trailerVC = TrailerVC()
        trailerVC.setContent(viewModel)
        self.navigationController?.pushViewController(trailerVC, animated: true)
    }
    
}

extension HomeVC: SuggestionViewPlayButtonDelegate{
    func suggestionViewPlayButtonPressed(viewModel: TrailerViewModel) {
        let title = suggestionMovie!.title ?? suggestionMovie!.original_title ?? suggestionMovie!.original_name ?? "Whiplash"

        APIManager.shared.searchForYoutube("\(title) + official trailer") { [weak self] response in
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    guard let strongSelf = self else {return}
                    let trailerVC = TrailerVC()
                    let trailerVM = TrailerViewModel(title: title, youtubeView: result, titlerOverView: strongSelf.suggestionMovie!.overview ?? "")
                    trailerVC.setContent(trailerVM)
                    strongSelf.navigationController?.pushViewController(trailerVC, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
