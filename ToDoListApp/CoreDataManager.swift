//
//  CoreDataManager.swift
//  ToDoListApp
//
//  Created by Pavel Popov on 24.11.2024.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTasks(_ tasks: [Task]) {
        tasks.forEach { task in
            let taskEntity = TaskEntity(context: context)
            taskEntity.id = Int32(task.id)
            taskEntity.title = task.title
            taskEntity.completed = task.completed
        }
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error.localizedDescription)")
        }
    }
    
    func fetchTasks() -> [TaskEntity] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка загрузки: \(error.localizedDescription)")
            return []
        }
    }
}
