//
//  Protocols.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import Foundation

// MARK: - Protocol Vehicle
/// Protocolo que define las características básicas de un vehículo
/// Demuestra propiedades computed (get) y stored (get/set), y métodos mutating
protocol Vehicle {
    /// Número de ruedas (solo lectura)
    var numberOfWheels: Int { get }
    
    /// Color del vehículo (lectura y escritura)
    var color: String { get set }
    
    /// Método para arrancar el motor
    func startEngine()
    
    /// Método mutating para cambiar el color (necesario para structs)
    mutating func changeColor(to newColor: String)
}

// MARK: - Car (implementación de Vehicle)
/// Estructura que representa un coche y conforma el protocolo Vehicle
struct Car: Vehicle {
    let numberOfWheels: Int = 4
    var color: String
    let brand: String
    var isEngineRunning: Bool = false
    
    func startEngine() {
        print("🚗 El \(brand) de color \(color) está arrancando... ¡Vroom!")
    }
    
    mutating func changeColor(to newColor: String) {
        print("🎨 Cambiando color de \(color) a \(newColor)")
        self.color = newColor
    }
}

// MARK: - Motorcycle (otra implementación de Vehicle)
struct Motorcycle: Vehicle {
    let numberOfWheels: Int = 2
    var color: String
    
    func startEngine() {
        print("🏍️ La motocicleta \(color) está arrancando... ¡Brrr!")
    }
    
    mutating func changeColor(to newColor: String) {
        self.color = newColor
    }
}

// MARK: - DataManagerDelegate Protocol
/// Protocolo de delegación para manejar respuestas del DataManager
/// Demuestra el patrón de delegación común en iOS
protocol DataManagerDelegate: AnyObject {
    /// Se llama cuando el DataManager recibe datos exitosamente
    func dataManager(_ manager: DataManager, didReceiveData data: [String])
    
    /// Se llama cuando el DataManager encuentra un error
    func dataManager(_ manager: DataManager, didFailWithError error: Error)
}

// MARK: - Protocol Extensions (Identifiable)
/// Extensión del protocolo Identifiable con implementaciones por defecto
/// Demuestra cómo proporcionar funcionalidad común a todos los tipos que conforman el protocolo
extension Identifiable where ID == UUID {
    /// Devuelve una representación legible del ID
    func displayID() -> String {
        return "ID: \(id.uuidString.prefix(8))..."
    }
    
    /// Verifica si el ID es válido (no vacío)
    func isValidID() -> Bool {
        return id.uuidString.isEmpty == false
    }
}

// También podemos extender otros protocolos con funcionalidad por defecto
extension Identifiable where ID == String {
    func displayID() -> String {
        return "ID: \(id)"
    }
    
    func isValidID() -> Bool {
        return !id.isEmpty
    }
}

// MARK: - Ejemplo de uso de extensión de protocolo
/// Tipo de ejemplo que usa la extensión de Identifiable
struct User: Identifiable {
    let id: UUID
    var name: String
    var email: String
    
    // Gracias a la extensión, User tiene automáticamente displayID() e isValidID()
}

struct Person: Identifiable {
    let id: String
    var fullName: String
    var age: Int
}

// Ejemplo de uso:
// let user = User(id: UUID(), name: "Ana", email: "ana@example.com")
// print(user.displayID()) // "ID: 12345678..."
// print(user.isValidID()) // true

// let person = Person(id: "PER001", fullName: "Carlos Ruiz", age: 30)
// print(person.displayID()) // "ID: PER001"
