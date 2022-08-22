//
//  ModelData.swift
//  todo
//
//  Created by Alan Zhu on 8/21/22.
//

import Foundation

class ToDoViewModel: ObservableObject {
    @Published var todos: [ToDoSection] = []
    @Published var fetching = false
    
    let priorities = [
        ToDoState.ar: 3,
        ToDoState.wt: 2,
        ToDoState.dn: 1
    ]
    
    func sort() {
        todos = todos.map({(section) -> ToDoSection in
            var newSection = section
            newSection.todos.sort(by: {(todoA, todoB) -> Bool in
                return priorities[todoA.done]! > priorities[todoB.done]! || (priorities[todoA.done]! == priorities[todoB.done]! && todoA.id > todoB.id)
            })
            return newSection
        })
    }
    
    func saveData() {
        guard let url = URL(string: "https://alanyzhu.scripts.mit.edu/todo-update.php") else {
            fetching = false
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONEncoder().encode(todos)
        } catch {
            return
        }
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
        }
        task.resume()
    }
    
    @MainActor
    func fetchData() async {
        fetching = true
        guard let url = URL(string: "https://alanyzhu.scripts.mit.edu/todo.json") else {
            fetching = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            todos = try JSONDecoder().decode([ToDoSection].self, from: data).map({(section) -> ToDoSection in
                var newSection = section
                newSection.todos.sort(by: {(todoA, todoB) -> Bool in
                    return priorities[todoA.done]! > priorities[todoB.done]! || (priorities[todoA.done]! == priorities[todoB.done]! && todoA.id < todoB.id)
                })
                return newSection
            })
        } catch {
            print("well, hopefully this doesn't happen.")
        }
        fetching = false
    }
    func nextSectionId () -> Int {
        return (todos.map({(section) -> Int in section.id}).max() ?? -1) + 1
    }
    func nextTodoId() -> Int {
        return (todos.flatMap({(section) -> [ToDo] in section.todos}).map({(todo) -> Int in todo.id}).max() ?? -1) + 1
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    print("loading")
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func toState(toChange: inout ToDo, toState: ToDoState) -> Void {
    toChange.done = toState;
}

func toTrash(_: ToDo) -> Void {
    
}
