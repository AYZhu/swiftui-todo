//
//  AddTodoWindow.swift
//  todo
//
//  Created by Alan Zhu on 8/21/22.
//

import SwiftUI

struct AddTodoWindow: View {
    @Binding var section: ToDoSection;
    var nextID: Int;
    @FocusState private var textfocused: Bool
    @Binding var item: String;
    @Binding var show: Bool;
    
    func done() -> Void {
        show = false
        if (item == "") {
            return
        }
        section.todos.insert(ToDo(id: nextID, name: item, done: ToDoState.ar), at: 0)
    }
    
    var body: some View {
        if show {
            ZStack {
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Add a new item to " + section.name + ":").font(.title).padding()
                    TextField("New Item", text: $item, prompt: Text("Enter your new to-do item")).padding().textFieldStyle(.roundedBorder)
                        .onSubmit(done)
                        .focused($textfocused)
                        .onAppear(perform: {() -> Void in
                            textfocused = true
                        })
                    Button("Done!", action: done).padding()
                }.frame(maxWidth: 600)
                    .background(Color(UIColor.systemBackground).clipShape(RoundedRectangle(cornerRadius: 20)))
            }
        }
    }
}

struct AddTodoWindow_Previews: PreviewProvider {
    @State static var tds: ToDoSection = ToDoSection(id: 1, name: "hello", todos: [])
    @State static var str: String = "attempt"
    @State static var show: Bool = true
    static var previews: some View {
        AddTodoWindow(section: $tds, nextID: 0, item: $str, show: $show)
    }
}
