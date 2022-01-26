//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Артем Черненко on 25.01.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    static var shared = StorageManager()
    private init() {}
    
    private var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Error \(error), \(error.userInfo)")
            }
        }
        return container
    }
    
    func fetchData(completion: @escaping([Task]) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest()
        
        do {
            let task = try context.fetch(fetchRequest)
            completion(task)
        } catch {
            print("Faild to fetch data", error)
        }
    }

    func save(name taskName: String) {
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        
        task.name = taskName
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func delete(in index: Int, completion: @escaping([Task]) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest()
        
        do {
            var task = try context.fetch(fetchRequest)
            context.delete(task[index])
            task.remove(at: index)
            completion(task)
        } catch {
            print("Faild to fetch data", error)
        }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func edit(in index: Int, new value: String, completion: @escaping(Task) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest()
        
        do {
            let task = try context.fetch(fetchRequest)
            completion(task[index])
            task[index].name = value
        } catch {
            print("Faild to fetch data", error)
        }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
}
