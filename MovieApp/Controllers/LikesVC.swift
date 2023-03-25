//
//  LikesVC.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 25.03.2023.
//

import UIKit

class LikesVC: UIViewController {
    
    private var medias = [MediaDataItem]()
    
    private let likesTable: UITableView = {
       let tableView = UITableView()
        tableView.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.topItem?.title = "Likes"
        navigationController?.navigationBar.tintColor = .label
        
        view.addSubview(likesTable)
        setDelegates()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        likesTable.frame = view.bounds
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMedias()
    }
    
    private func setDelegates(){
        likesTable.delegate = self
        likesTable.dataSource = self
    }
    
    private func fetchMedias(){
        LocalDataManager.shared.fetchMedias { [weak self] response in
            switch response{
            case .success(let medias):
                DispatchQueue.main.async {
                    self?.medias = medias
                    self?.likesTable.reloadData()
                    print("succesfully fetched")
                }
              
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

extension LikesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.identifier, for: indexPath) as? GeneralTableViewCell else { return UITableViewCell()
        }
        
        let media = medias[indexPath.row]
        let content = TmdbMediaViewModel(name: media.title ?? "", posterPath: media.poster_path ?? "")
        cell.setContents(content)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        likesTable.deselectRow(at: indexPath, animated: true)
        
        let media = medias[indexPath.row]
        guard let mediaName = media.title else {
            print("name")
            return}
        guard let mediaOverview = media.title_overview else {
            print("mediaOverview")
            return}
        guard let poster_path = media.poster_path else {
            print("poster_path")
            return}
       
        
        APIManager.shared.searchForYoutube(mediaName + " official trailer") { [weak self] response in
            
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    let trailerViewModel = TrailerViewModel(title: mediaName, youtubeView: result, titlerOverView: mediaOverview, id: Int(media.id), poster_path: poster_path)
                    guard let strongSelf = self else {return}
                    let trailerVC = TrailerVC()
                    trailerVC.setContent(trailerViewModel)
                    strongSelf.navigationController?.pushViewController(trailerVC, animated: true)
                    print("başarılı")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            LocalDataManager.shared.deleteMedia(Int(medias[indexPath.row].id)) { [weak self] response in
                switch response{
                case .success(()):
                    DispatchQueue.main.async {
                        self?.medias.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                   
                case .failure((_)):
                    print("failed to delete")
                }
            }
            print("deleted")
        default:
            break;
        }
       
    }
    
}
