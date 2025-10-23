//
//  ContentView.swift
//  Tema10Swift
//
//  Demostración de protocolos, delegación y comparación
//

import SwiftUI
import Combine

// MARK: - ContentViewModel
/// ViewModel simple que demuestra delegación
/// Concepto: Un objeto (DataManager) notifica eventos a otro (ViewModel) a través de un protocolo
class ContentViewModel: ObservableObject, DataManagerDelegate {
    
    @Published var tasks: [Task] = []
    @Published var receivedData: [String] = []
    @Published var isLoading: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let dataManager = DataManager()
    
    init() {
        // El ViewModel se registra como delegado del DataManager
        dataManager.delegate = self
        loadSampleTasks()
    }
    
    // MARK: - Sample Data
    func loadSampleTasks() {
        tasks = [
            Task(title: "Estudiar Protocolos", priority: 5, completed: false),
            Task(title: "Practicar Delegación", priority: 4, completed: false),
            Task(title: "Revisar Equatable", priority: 3, completed: true),
            Task(title: "Implementar Comparable", priority: 2, completed: false)
        ]
    }
    
    // MARK: - DataManagerDelegate Methods
    
    // Cuando el DataManager recibe datos, notifica al delegado (este ViewModel)
    func dataManager(_ manager: DataManager, didReceiveData data: [String]) {
        DispatchQueue.main.async {
            self.receivedData = data
            self.isLoading = false
            self.alertMessage = "✅ Se recibieron \(data.count) elementos"
            self.showAlert = true
            print("✅ Delegado recibió datos: \(data)")
        }
    }
    
    func dataManager(_ manager: DataManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.alertMessage = "❌ Error: \(error.localizedDescription)"
            self.showAlert = true
            print("❌ Delegado recibió error: \(error)")
        }
    }
    
    // MARK: - Actions
    func fetchRemoteData() {
        isLoading = true
        receivedData = []
        dataManager.fetchData()
    }
}

// MARK: - ContentView
struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Equatable & Comparable Demo
                Section(header: Text("⚖️ Equatable & Comparable")) {
                    Text("Las tareas se ordenan automáticamente por prioridad (mayor a menor)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Uso de sorted() - posible gracias a Comparable
                    ForEach(viewModel.tasks.sorted(by: >)) { task in
                        HStack {
                            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.completed ? .green : .gray)
                            
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.completed)
                                
                                // CustomStringConvertible en acción
                                Text(task.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // MARK: - Protocol & Delegation Demo
                Section(header: Text("🔄 Delegación")) {
                    Text("El DataManager notifica eventos al ViewModel a través del protocolo DataManagerDelegate")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        viewModel.fetchRemoteData()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                            }
                            Text(viewModel.isLoading ? "Cargando..." : "Obtener Datos Remotos")
                        }
                    }
                    .disabled(viewModel.isLoading)
                    
                    if !viewModel.receivedData.isEmpty {
                        ForEach(viewModel.receivedData, id: \.self) { item in
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                Text(item)
                            }
                        }
                    }
                }
                
                // MARK: - Protocol Example
                Section(header: Text("🚗 Protocolo Vehicle")) {
                    Text("Ejemplo de un protocolo con propiedades y métodos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VehicleExampleView()
                }
                
                // MARK: - Concepts Summary
                Section(header: Text("📚 Conceptos Demostrados")) {
                    Label("Protocols: Contratos que definen funcionalidad", systemImage: "doc.text")
                    Label("Equatable: Comparar objetos con ==", systemImage: "equal")
                    Label("Comparable: Ordenar con <, >, sorted()", systemImage: "arrow.up.arrow.down")
                    Label("CustomStringConvertible: Descripción personalizada", systemImage: "text.quote")
                    Label("Delegación: Comunicación entre objetos", systemImage: "arrow.triangle.branch")
                }
                .font(.caption)
            }
            .navigationTitle("Tema 10: Protocolos")
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

// MARK: - Vehicle Example View
/// Vista simple que demuestra el uso del protocolo Vehicle
struct VehicleExampleView: View {
    
    @State private var car = Car(numberOfWheels: 4, color: "Rojo", brand: "Toyota")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🚗 \(car.brand)")
                .font(.headline)
            Text("Ruedas: \(car.numberOfWheels)")
            Text("Color: \(car.color)")
            
            Button("Cambiar a Azul") {
                car.changeColor(to: "Azul")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
