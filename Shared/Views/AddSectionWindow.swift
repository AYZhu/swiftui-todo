//
//  AddTodoWindow.swift
//  todo
//
//  Created by Alan Zhu on 8/21/22.
//

import SwiftUI

struct AddSectionWindow: View {
    @Binding var todoList: [ToDoSection];
    var nextID: Int;
    @FocusState private var textfocused: Bool
    @Binding var item: String;
    @Binding var show: Bool;
    
    func done() -> Void {
        show = false
        if (item == "") {
            return
        }
        todoList.append(ToDoSection(id: nextID, name: item, todos: []))
    }
    
    var body: some View {
        if show {
            ZStack {
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Add a new section:").font(.title).padding()
                    TextField("New Item", text: $item, prompt: Text("Enter your new section name")).padding().textFieldStyle(.roundedBorder)
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

struct AddSectionWindow_Previews: PreviewProvider {
    @State static var tds: ToDoSection = ToDoSection(id: 1, name: "hello", todos: [])
    @State static var str: String = "attempt"
    @State static var show: Bool = true
    static var previews: some View {
        AddTodoWindow(section: $tds, nextID: 0, item: $str, show: $show)
    }
}
