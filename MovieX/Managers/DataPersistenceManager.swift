//
//  DataPersistenceManager.swift
//  MovieX
//
//  Created by Basem El kady on 2/16/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceMAnager {
    
    static let shared = DataPersistenceMAnager()
    
    func saveTitleToDataBaseWith(_ titleModel:Title, completion: @escaping (Result<Void, MoviexError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = StoredTitle(context: context)
        item.original_title = titleModel.original_title
        item.original_name = titleModel.original_name
        item.poster_path = titleModel.poster_path
        item.id = Int64 (titleModel.id ?? 0)
        item.media_type = titleModel.media_type
        item.overview = titleModel.overview
        item.release_date = titleModel.release_date
        item.vote_average = (titleModel.vote_average ?? 0.0)
        item.vote_count = Int64 (titleModel.vote_count ?? 0)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(MoviexError.dataSavingFailure))
        }
    }
    
    func loadStoredTitlesFromDataBase(completion: @escaping (Result<[StoredTitle], MoviexError>) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<StoredTitle>
        
        request = StoredTitle.fetchRequest()
        do {
            let storedTitles = try context.fetch(request)
            completion(.success(storedTitles))
        } catch {
            completion(.failure(.dataLoadingFailure))
        }
    }
    
    func deleteStoredTitlefromDataBase(_ title:StoredTitle, completion: @escaping(Result<Void, MoviexError>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(title)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(MoviexError.dataDeletionFailure))
        }
    }
}
