//
//  DataManager.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import Foundation

// MARK: - DataManager
/// Clase que simula la descarga de datos desde un servidor remoto
/// Demuestra el patrón de delegación para comunicar eventos de forma débil (weak delegate)
class DataManager {
    
    // MARK: - Properties
    /// Delegado débil para evitar retain cycles
    /// IMPORTANTE: weak previene memory leaks cuando el delegado retiene al DataManager
    weak var delegate: DataManagerDelegate?
    
    private var isFetching = false
    
    // MARK: - Public Methods
    /// Simula una petición de red asíncrona que tarda 2 segundos
    /// Puede resultar en éxito (datos recibidos) o error
    func fetchData() {
        guard !isFetching else {
            print("⚠️ Ya hay una petición en curso...")
            return
        }
        
        isFetching = true
        print("📡 Iniciando petición de datos remotos...")
        
        // Simulamos una petición de red asíncrona con un delay de 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            self.isFetching = false
            
            // Simulamos un resultado aleatorio: 80% éxito, 20% error
            let randomValue = Int.random(in: 1...10)
            
            if randomValue <= 8 {
                // Caso de éxito: devolvemos datos simulados
                let mockData = [
                    "Protocolo Vehicle implementado ✅",
                    "Delegación funcionando correctamente ✅",
                    "Equatable y Comparable demostrados ✅",
                    "CustomStringConvertible en uso ✅",
                    "ScenePhase gestionado ✅"
                ]
                
                print("✅ Datos recibidos exitosamente")
                // Notificamos al delegado con los datos
                self.delegate?.dataManager(self, didReceiveData: mockData)
                
            } else {
                // Caso de error: simulamos un error de red
                let error = NSError(
                    domain: "com.tema10swift.datamanager",
                    code: 500,
                    userInfo: [NSLocalizedDescriptionKey: "Error de conexión al servidor"]
                )
                
                print("❌ Error al obtener datos: \(error.localizedDescription)")
                // Notificamos al delegado con el error
                self.delegate?.dataManager(self, didFailWithError: error)
            }
        }
    }
    
    /// Cancela cualquier petición en curso (simulado)
    func cancelFetch() {
        if isFetching {
            print("🚫 Petición cancelada")
            isFetching = false
        }
    }
}

// MARK: - Notas sobre Delegación
/*
 ¿Por qué usar weak var delegate?
 
 El patrón de delegación puede crear retain cycles:
 1. El ViewController retiene al DataManager
 2. El DataManager retiene al delegate (ViewController)
 3. ¡Retain cycle! Ninguno se libera de memoria
 
 Solución: Declarar delegate como weak para romper el ciclo.
 
 ¿Por qué DataManagerDelegate: AnyObject?
 Solo las clases pueden ser weak, por eso el protocolo debe heredar de AnyObject.
 Esto previene que structs o enums conformen el protocolo.
 
 TODO: En una app real, reemplazar DispatchQueue.main.asyncAfter con:
 - URLSession.shared.dataTask para peticiones HTTP reales
 - Async/await con URLSession.data(from:)
 - Combine con URLSession.dataTaskPublisher
 */
