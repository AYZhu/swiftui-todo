//
//  TodoRow.swift
//  todo
//
//  Created by Alan Zhu on 8/21/22.
//

import SwiftUI

struct TodoRow: View {
    @Binding var todo: ToDo
    @Binding var todoSection: ToDoSection
    
    var body: some View {
        HStack() {
            Text(String(format: "[%@] %@", todo.done.rawValue, todo.name))
                .strikethrough(todo.done == ToDoState.dn)
                .font(todo.done == ToDoState.wt ? .body.italic() : (todo.done == ToDoState.ar ? .body.bold() : .none))
            Spacer()
            Button(action: { () -> Void in toState(toChange: &todo, toState: ToDoState.ar) } ) {
                Label("action required", systemImage: "play.fill")
                    .labelStyle(.iconOnly)
            }
            Button(action: { () -> Void in toState(toChange: &todo, toState: ToDoState.wt) } ) {
                Label("waiting", systemImage: "clock")
                    .labelStyle(.iconOnly)
            }
            Button(action: { () -> Void in toState(toChange: &todo, toState: ToDoState.dn) } ) {
                Label("done", systemImage: "checkmark")
                    .labelStyle(.iconOnly)
            }
            Button(action: { () -> Void in
                todoSection.todos.removeAll(where: {(theTodo) -> Bool in
                    theTodo.id == todo.id
                })
            } ) {
                Label("trash", systemImage: "trash")
                    .labelStyle(.iconOnly)
            }
        }
    }
}

struct TodoRow_Previews: PreviewProvider {
    @State static var todo: ToDo = ToDo(id: 1, name: "hello", done: ToDoState.dn)
    @State static var todos: ToDoSection = ToDoSection(id: -1, name: "", todos: [todo])
    static var previews: some View {
        TodoRow(todo: $todo, todoSection: $todos)
    }
}
