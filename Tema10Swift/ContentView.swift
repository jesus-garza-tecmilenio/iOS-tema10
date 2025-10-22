//
//  ContentView.swift
//  Tema10Swift
//
//  Demostración de protocolos, delegación y gestión de tareas
//

import SwiftUI
import Combine

// MARK: - ContentViewModel
/// ViewModel que gestiona las tareas y actúa como delegado del DataManager
/// Demuestra: ObservableObject, Combine, patrón de delegación
class ContentViewModel: ObservableObject, DataManagerDelegate {
    
    // MARK: - Published Properties
    @Published var tasks: [Task] = []
    @Published var newTaskTitle: String = ""
    @Published var newTaskPriority: Int = 1
    @Published var receivedData: [String] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // MARK: - Private Properties
    private let dataManager = DataManager()
    
    // MARK: - Initialization
    init() {
        dataManager.delegate = self
        print("🎯 ContentViewModel inicializado como delegado")
    }
    
    // MARK: - Task Management
    
    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        
        let task = Task(
            title: newTaskTitle,
            priority: newTaskPriority,
            completed: false
        )
        tasks.append(task)
        
        newTaskTitle = ""
        newTaskPriority = 1
        
        print("✅ Tarea agregada: \(task)")
    }
    
    func toggleTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks[index].completed.toggle()
    }
    
    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    var sortedTasks: [Task] {
        tasks.sorted { $0.priority > $1.priority }
    }
    
    func containsTask(withTitle title: String) -> Bool {
        let searchTask = Task(title: title, priority: 0, completed: false)
        return tasks.contains { $0.title == searchTask.title }
    }
    
    // MARK: - Remote Data
    
    func fetchRemoteData() {
        isLoading = true
        errorMessage = nil
        dataManager.fetchData()
    }
    
    // MARK: - DataManagerDelegate
    
    func dataManager(_ manager: DataManager, didReceiveData data: [String]) {
        DispatchQueue.main.async {
            self.receivedData = data
            self.isLoading = false
            self.errorMessage = nil
            self.alertMessage = "✅ Se recibieron \(data.count) elementos del servidor"
            self.showAlert = true
            print("✅ Delegado recibió \(data.count) elementos")
        }
    }
    
    func dataManager(_ manager: DataManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            self.alertMessage = "❌ Error: \(error.localizedDescription)"
            self.showAlert = true
            print("❌ Delegado recibió error: \(error.localizedDescription)")
        }
    }
}

// MARK: - ContentView
struct ContentView: View {
    
    @EnvironmentObject var dataStore: DataStore
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("📚 Ejemplos de Protocolos")) {
                    NavigationLink("🔄 Delegación Demo", destination: DelegationExampleView())
                    NavigationLink("🧩 Extensiones de Protocolos", destination: ProtocolExtensionsExampleView())
                    NavigationLink("⏱️ Timer & ScenePhase", destination: TimerView())
                }
                
                Section(header: Text("✅ Gestión de Tareas")) {
                    HStack {
                        TextField("Título de tarea", text: $viewModel.newTaskTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Stepper("\(viewModel.newTaskPriority)", value: $viewModel.newTaskPriority, in: 1...5)
                            .frame(width: 80)
                        
                        Button(action: {
                            viewModel.addTask()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                        .disabled(viewModel.newTaskTitle.isEmpty)
                    }
                    
                    ForEach(Array(viewModel.sortedTasks.enumerated()), id: \.element.id) { index, task in
                        HStack {
                            Button(action: {
                                if let originalIndex = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                    viewModel.toggleTask(at: originalIndex)
                                }
                            }) {
                                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.completed ? .green : .gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.completed)
                                
                                Text(task.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { offsets in
                        let tasksToDelete = offsets.map { viewModel.sortedTasks[$0] }
                        let originalIndices = IndexSet(tasksToDelete.compactMap { task in
                            viewModel.tasks.firstIndex(where: { $0.id == task.id })
                        })
                        viewModel.deleteTasks(at: originalIndices)
                    }
                }
                
                Section(header: Text("📡 Delegación - DataManager")) {
                    Button(action: {
                        viewModel.fetchRemoteData()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                            Text(viewModel.isLoading ? "Cargando..." : "Obtener Datos Remotos")
                        }
                    }
                    .disabled(viewModel.isLoading)
                    
                    if !viewModel.receivedData.isEmpty {
                        ForEach(viewModel.receivedData, id: \.self) { item in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(item)
                            }
                        }
                    }
                }
                
                Section(header: Text("ℹ️ Conceptos Demostrados")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Protocols (Vehicle, DataManagerDelegate)", systemImage: "text.book.closed")
                        Label("Equatable & Comparable (Task sorting)", systemImage: "arrow.up.arrow.down")
                        Label("CustomStringConvertible (Task.description)", systemImage: "text.quote")
                        Label("Protocol Extensions (Identifiable)", systemImage: "puzzlepiece.extension")
                        Label("Delegation (DataManager → ViewModel)", systemImage: "arrow.triangle.branch")
                        Label("ScenePhase (App lifecycle monitoring)", systemImage: "clock.arrow.circlepath")
                        Label("ObservableObject & @Published (MVVM)", systemImage: "arrow.clockwise")
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Tema 10: Protocolos")
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataStore())
}
