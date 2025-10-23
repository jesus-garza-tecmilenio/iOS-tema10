//
//  Protocols.swift
//  Tema10Swift
//
//  Definición de protocolos y ejemplos de implementación
//

import Foundation

// MARK: - Vehicle Protocol
/// Protocolo que define las características básicas de un vehículo
/// Demuestra: propiedades get/get-set y métodos en protocolos
protocol Vehicle {
    var numberOfWheels: Int { get }      // Solo lectura
    var color: String { get set }        // Lectura y escritura
    
    func startEngine()
    mutating func changeColor(to newColor: String)
}

// MARK: - Car (implementa Vehicle)
/// Estructura que representa un coche
/// Demuestra: Cómo implementar un protocolo
struct Car: Vehicle {
    let numberOfWheels: Int
    var color: String
    let brand: String
    
    func startEngine() {
        print("🚗 \(brand) arrancando motor... Vroom!")
    }
    
    mutating func changeColor(to newColor: String) {
        print("🎨 Cambiando color de \(color) a \(newColor)")
        color = newColor
    }
}

// MARK: - DataManagerDelegate Protocol
/// Protocolo para delegación
/// Demuestra: Patrón de delegación para comunicación entre objetos
protocol DataManagerDelegate: AnyObject {
    func dataManager(_ manager: DataManager, didReceiveData data: [String])
    func dataManager(_ manager: DataManager, didFailWithError error: Error)
}
