//
//  Models.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import Foundation

// MARK: - Coordinate (Equatable)
/// Estructura que representa una coordenada geográfica
/// Demuestra el protocolo Equatable para comparar igualdad
struct Coordinate: Equatable {
    let latitude: Double
    let longitude: Double
    
    // Swift genera automáticamente == cuando conformamos Equatable
    // pero podríamos implementarlo manualmente:
    // static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    //     return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    // }
}

// Ejemplo de uso de Equatable con contains()
let coordinates = [
    Coordinate(latitude: 40.7128, longitude: -74.0060),
    Coordinate(latitude: 34.0522, longitude: -118.2437),
    Coordinate(latitude: 41.8781, longitude: -87.6298)
]

let searchCoordinate = Coordinate(latitude: 40.7128, longitude: -74.0060)
// Gracias a Equatable, podemos usar contains():
// let found = coordinates.contains(searchCoordinate) // true

// MARK: - Student (Comparable & Equatable)
/// Estructura que representa un estudiante
/// Demuestra los protocolos Comparable y Equatable para ordenar y comparar
struct Student: Comparable, Equatable {
    let name: String
    let grade: Double
    let studentID: String
    
    // MARK: Comparable
    /// Implementación de < para ordenar estudiantes por calificación (mayor a menor)
    static func < (lhs: Student, rhs: Student) -> Bool {
        // Ordenamos de mayor a menor (invertido), así el mejor está primero
        return lhs.grade > rhs.grade
    }
    
    // MARK: Equatable
    /// Dos estudiantes son iguales si tienen el mismo ID
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.studentID == rhs.studentID
    }
}

// Ejemplos de estudiantes para demostrar Comparable
let students = [
    Student(name: "Ana García", grade: 8.5, studentID: "S001"),
    Student(name: "Carlos Ruiz", grade: 9.2, studentID: "S002"),
    Student(name: "María López", grade: 7.8, studentID: "S003"),
    Student(name: "Juan Pérez", grade: 9.5, studentID: "S004"),
    Student(name: "Laura Martínez", grade: 8.9, studentID: "S005")
]

// Gracias a Comparable, podemos usar sorted():
// let sortedStudents = students.sorted() // Ordena por calificación (mejor primero)
// let topStudent = sortedStudents.first // Juan Pérez con 9.5

// MARK: - Task (CustomStringConvertible)
/// Estructura que representa una tarea
/// Demuestra el protocolo CustomStringConvertible para descripción personalizada
struct Task: CustomStringConvertible, Codable, Identifiable {
    let id: UUID
    var title: String
    var priority: Int // 1 = alta, 2 = media, 3 = baja
    var completed: Bool
    
    init(id: UUID = UUID(), title: String, priority: Int, completed: Bool = false) {
        self.id = id
        self.title = title
        self.priority = priority
        self.completed = completed
    }
    
    // MARK: CustomStringConvertible
    /// Descripción legible de la tarea
    var description: String {
        let priorityText: String
        switch priority {
        case 1:
            priorityText = "🔴 Alta"
        case 2:
            priorityText = "🟡 Media"
        case 3:
            priorityText = "🟢 Baja"
        default:
            priorityText = "⚪️ Sin prioridad"
        }
        
        let statusIcon = completed ? "✅" : "⬜️"
        return "\(statusIcon) [\(priorityText)] \(title)"
    }
    
    /// Descripción de prioridad como texto
    var priorityText: String {
        switch priority {
        case 1: return "Alta"
        case 2: return "Media"
        case 3: return "Baja"
        default: return "Sin prioridad"
        }
    }
}

// Ejemplo de uso de CustomStringConvertible:
let exampleTask = Task(title: "Estudiar Swift", priority: 1, completed: false)
// print(exampleTask) // Imprime: ⬜️ [🔴 Alta] Estudiar Swift

// Ejemplo de tareas para el DataStore
let defaultTasks = [
    Task(title: "Aprender Protocolos", priority: 1, completed: false),
    Task(title: "Implementar Delegación", priority: 1, completed: false),
    Task(title: "Usar Equatable y Comparable", priority: 2, completed: true),
    Task(title: "Crear extensiones de protocolo", priority: 2, completed: false),
    Task(title: "Gestionar ScenePhase", priority: 3, completed: false)
]
