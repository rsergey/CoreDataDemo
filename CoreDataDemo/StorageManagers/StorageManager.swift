//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Sergey on 17.08.2021.
//

import CoreData

class StorageManager {
    // MARK: - Static Properties
    static let shared = StorageManager()
    
    // MARK: - Private Properties
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Initialization
    private init() {}

    // MARK: - Public Methods
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let context = persistentContainer.viewContext
        var taskList: [Task] = []
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            taskList = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return taskList
    }
    
    func saveData(_ taskName: String) -> Task {
        let context = persistentContainer.viewContext
        guard let entiyDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return Task()}
        guard let task = NSManagedObject(entity: entiyDescription, insertInto: context) as? Task else { return Task()}
        task.name = taskName
        if context.hasChanges {
            save(context)
        }
        return task
    }
    
    func deleteData(task: Task) {
        let context = persistentContainer.viewContext
        context.delete(task)
        save(context)
    }
    
    func editData(task: Task, newTask: String) {
        let context = persistentContainer.viewContext
        task.name = newTask
        save(context)
    }
    
    //MARK: - Private Methods
    private func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
