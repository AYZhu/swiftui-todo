//
//  TodoSection.swift
//  todo
//
//  Created by Alan Zhu on 8/21/22.
//

import Foundation

struct ToDoSection: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var todos: [ToDo]
}
