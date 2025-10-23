//
//  DataManager.swift
//  Tema10Swift
//
//  Clase que demuestra el patrón de delegación
//

import Foundation

// MARK: - DataManager
/// Clase que simula la obtención de datos remotos
/// Demuestra: Patrón de delegación - notifica eventos a su delegado
class DataManager {
    
    // MARK: - Delegate
    /// Delegado que será notificado cuando lleguen datos o errores
    /// IMPORTANTE: weak para evitar retain cycles (ciclos de retención de memoria)
    weak var delegate: DataManagerDelegate?
    
    // MARK: - Fetch Data
    /// Simula una llamada a servidor que tarda 2 segundos
    func fetchData() {
        print("📡 DataManager: Iniciando fetch de datos...")
        
        // Simular llamada asíncrona
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            // Simular éxito (80% del tiempo)
            if Int.random(in: 1...10) <= 8 {
                let mockData = [
                    "Dato remoto 1",
                    "Dato remoto 2",
                    "Dato remoto 3"
                ]
                print("✅ DataManager: Datos recibidos - notificando al delegado")
                
                // DELEGACIÓN: Notificar al delegado que llegaron los datos
                self.delegate?.dataManager(self, didReceiveData: mockData)
                
            } else {
                // Simular error (20% del tiempo)
                let error = NSError(
                    domain: "DataManager",
                    code: 500,
                    userInfo: [NSLocalizedDescriptionKey: "Error de conexión simulado"]
                )
                print("❌ DataManager: Error - notificando al delegado")
                
                // DELEGACIÓN: Notificar al delegado que hubo un error
                self.delegate?.dataManager(self, didFailWithError: error)
            }
        }
    }
}
