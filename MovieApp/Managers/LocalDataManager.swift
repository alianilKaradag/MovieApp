//
//  LocalDataManager.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 25.03.2023.
//

import Foundation
import CoreData
import UIKit

enum DataBaseError: Error{
    case savingFailed
    case fetchingFailed
    case deletingFailed
}

class LocalDataManager{
    
    static let shared = LocalDataManager()
    
    func likeMedia(_ trailerViewModel: TrailerViewModel, completion: @escaping (Result<Void, Error>) -> Void){
        
        hasLikedBefore(trailerViewModel.id) { response in
            switch response{
            case .success(let bool):
                if bool == true{
                    return
                }
            case .failure(let error):
                print( error.localizedDescription)
            }
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let mediaDataItem = MediaDataItem(context: context)
        mediaDataItem.id = Int32(trailerViewModel.id)
        mediaDataItem.title = trailerViewModel.title
        mediaDataItem.poster_path = trailerViewModel.poster_path
        mediaDataItem.title_overview = trailerViewModel.titlerOverView
        
        do{
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.savingFailed))
            print(error.localizedDescription)
        }
    }
    
    func hasLikedBefore(_ id: Int, completion: (Result<Bool, Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<MediaDataItem> = MediaDataItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let result = try context.fetch(fetchRequest)
            completion(.success(result.count > 0))
            
        } catch {
            completion(.failure(error))
            print("has liked error")
        }
    }
    
    func fetchMedias(completion: @escaping (Result<[MediaDataItem], Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MediaDataItem> = MediaDataItem.fetchRequest()
        
        do {
            
            let medias = try context.fetch(request)
            completion(.success(medias))
            
        } catch {
            completion(.failure(DataBaseError.fetchingFailed))
            print("fetch from core data error")
        }
    }
    
    func deleteMedia(_ id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
       
        let fetchRequest: NSFetchRequest<MediaDataItem> = MediaDataItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.deletingFailed))
            print("deleting media from core data error")
        }
    }
}
