//
//  DelegationExampleView.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import SwiftUI
import Combine

// MARK: - ContentViewModel
/// ViewModel que actúa como delegado del DataManager
/// Demuestra el patrón de delegación en una arquitectura MVVM
class DelegationViewModel: ObservableObject, DataManagerDelegate {
    
    // MARK: - Published Properties
    @Published var receivedData: [String] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    private let dataManager = DataManager()
    
    // MARK: - Initialization
    init() {
        // Asignamos este ViewModel como delegado del DataManager
        dataManager.delegate = self
        print("🎯 DelegationViewModel inicializado como delegado")
    }
    
    // MARK: - Public Methods
    
    /// Inicia la descarga de datos remotos
    func fetchRemoteData() {
        isLoading = true
        errorMessage = nil
        dataManager.fetchData()
    }
    
    /// Limpia los datos recibidos
    func clearData() {
        receivedData.removeAll()
        errorMessage = nil
    }
    
    // MARK: - DataManagerDelegate
    
    /// Se ejecuta cuando el DataManager recibe datos exitosamente
    func dataManager(_ manager: DataManager, didReceiveData data: [String]) {
        // Actualizamos en el hilo principal (siempre para @Published)
        DispatchQueue.main.async {
            self.receivedData = data
            self.isLoading = false
            self.errorMessage = nil
            print("✅ Delegado recibió \(data.count) elementos")
        }
    }
    
    /// Se ejecuta cuando el DataManager encuentra un error
    func dataManager(_ manager: DataManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            print("❌ Delegado recibió error: \(error.localizedDescription)")
        }
    }
}

// MARK: - DelegationExampleView
/// Vista que demuestra el patrón de delegación
struct DelegationExampleView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = DelegationViewModel()
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Text("📡 Delegación Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Patrón de delegación con DataManager")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Botón para iniciar la petición
            Button(action: {
                viewModel.fetchRemoteData()
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(viewModel.isLoading ? "Cargando..." : "Obtener Datos Remotos")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isLoading ? Color.gray : Color.blue)
                .cornerRadius(10)
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal)
            
            // Mostrar error si existe
            if let error = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            // Lista de datos recibidos
            if !viewModel.receivedData.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Datos Recibidos:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    List {
                        ForEach(viewModel.receivedData, id: \.self) { item in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(item)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                    Button("Limpiar Datos") {
                        viewModel.clearData()
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal)
                }
            } else if !viewModel.isLoading && viewModel.errorMessage == nil {
                VStack(spacing: 15) {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("Presiona el botón para obtener datos")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            
            // Explicación del patrón
            VStack(alignment: .leading, spacing: 10) {
                Text("💡 Conceptos demostrados:")
                    .font(.headline)
                
                Text("• DataManager usa delegate: DataManagerDelegate?")
                Text("• El delegado es weak para evitar retain cycles")
                Text("• ViewModel conforma DataManagerDelegate")
                Text("• Se notifican eventos (éxito/error) al delegado")
            }
            .font(.caption)
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
}

// MARK: - Preview
#Preview {
    DelegationExampleView()
}
