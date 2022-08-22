//
//  ContentView.swift
//  Shared
//
//  Created by Alan Zhu on 8/21/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ToDoViewModel()
    @State var showingPopup = false
    @State var showingSectionPopup = false
    @State var item = ""
    @State var selectedSection: Binding<ToDoSection> = Binding.constant(ToDoSection(id: -1, name: "", todos: []))
    @State var nextID: Int = -1
    @State var nextSectionID: Int = -1
    @State var showAll: Bool = false
    
    var body: some View {
        ZStack{
            List {
                ForEach($viewModel.todos) { $section in
                    Section (header: HStack {
                        Text(section.name)
                        Spacer()
                        Button(action: {() -> Void in
                            showingPopup = true
                            item = ""
                            selectedSection = $section
                            nextID = viewModel.nextTodoId()
                        }) {
                            Label("add to section", systemImage: "plus")
                                .labelStyle(.iconOnly)
                        }
                        Button(action: {() -> Void in
                            viewModel.todos.removeAll(where: {
                                (theSection) -> Bool in
                                theSection.id == section.id
                            })}) {
                                Label("remove section", systemImage: "trash")
                                    .labelStyle(.iconOnly)
                            }
                    }) {
                        ForEach($section.todos) { $todo in
                            if (todo.done != ToDoState.dn || showAll) {
                                TodoRow(todo: $todo, todoSection: $section)
                            }
                        }.onMove(perform: {(from, to) -> Void in
                            move(todos: &section.todos, from:from, to:to)
                        }).buttonStyle(PlainButtonStyle())
                    }
                }
                Button(action: {() -> Void in
                    showingSectionPopup = true
                    item = ""
                    nextSectionID = viewModel.nextSectionId()
                }) {
                    Label("New Section", systemImage: "plus")
                }
                Button(action: {() -> Void in
                    viewModel.saveData()
                }) {
                    Label("Save to Remote", systemImage: "tray.and.arrow.up.fill")
                }
                Button(action: viewModel.sort) {
                    Label("Sort To-Dos", systemImage: "arrow.up.arrow.down.circle.fill")
                }
                Button(action: {() -> Void in
                    showAll = !showAll
                }) {
                    Label(showAll ? "Hide Done" : "Show Done", systemImage: showAll ? "eye.slash" : "eye")
                }
                Button(action: {() -> Void in
                    print(viewModel.todos)
                    print(selectedSection)
                }) {
                    Label("Print Debug Info", systemImage: "ladybug.fill")
                }
            }.refreshable {
                await viewModel.fetchData()
            }
            .overlay {
                if viewModel.fetching {
                    ProgressView("Fetching data, please wait...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                }
            }
            .animation(.default, value: viewModel.todos)
            .task {
                await viewModel.fetchData()
            }
            AddTodoWindow(section: selectedSection, nextID: nextID, item: $item, show: $showingPopup)
            AddSectionWindow(todoList: $viewModel.todos, nextID: nextSectionID, item: $item, show: $showingSectionPopup)
        }
    }
    func move(todos: inout [ToDo], from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
