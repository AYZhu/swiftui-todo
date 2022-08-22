//
//  Todo.swift
//  todo
//
//  Created by Alan Zhu on 8/21/22.
//

import Foundation

enum ToDoState: String, Codable {
    case ar = "ar"
    case wt = "wt"
    case dn = "dn"
}

struct ToDo: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var done: ToDoState
}
