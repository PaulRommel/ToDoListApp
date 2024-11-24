//
//  NetworkManager.swift
//  ToDoListApp
//
//  Created by Pavel Popov on 24.11.2024.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    func fetchTasks(complection: @escaping ([Task]) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode([String: [Task]].self, from: data)
                let tasks = json["todos"] ?? []
                DispatchQueue.main.async {
                    complection(tasks)
                }
            } catch {
                print("Ошибка парсинга: \(error.localizedDescription)")
            }
        } .resume()
    }
}
