//
//  Task.swift
//  ToDoListApp
//
//  Created by Pavel Popov on 24.11.2024.
//

import Foundation

struct Task: Codable {
    let id: Int
    let title: String
    let completed: Bool
}
