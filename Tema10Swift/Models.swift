//
//  Models.swift
//  Tema10Swift
//
//  Modelos que demuestran Equatable, Comparable y CustomStringConvertible
//

import Foundation

// MARK: - Coordinate (Equatable)
/// Estructura simple que representa una coordenada
/// Demuestra: Equatable permite comparar dos coordenadas con ==
struct Coordinate: Equatable {
    let latitude: Double
    let longitude: Double
    
    // Swift genera automáticamente == cuando conformamos Equatable
}

// MARK: - Student (Comparable & Equatable)
/// Estructura que representa un estudiante
/// Demuestra: Comparable permite ordenar estudiantes, Equatable permite comparar igualdad
struct Student: Comparable, Equatable {
    let name: String
    let grade: Double
    let studentID: String
    
    // MARK: Comparable
    /// Define cómo ordenar estudiantes (por calificación, de mayor a menor)
    static func < (lhs: Student, rhs: Student) -> Bool {
        return lhs.grade > rhs.grade // Invertido para que el mejor esté primero
    }
    
    // MARK: Equatable
    /// Define cuándo dos estudiantes son iguales (mismo ID)
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.studentID == rhs.studentID
    }
}

// MARK: - Task (CustomStringConvertible + Comparable)
/// Estructura que representa una tarea
/// Demuestra: CustomStringConvertible para descripción personalizada
///           Comparable para ordenar por prioridad
struct Task: CustomStringConvertible, Comparable, Identifiable {
    let id: UUID
    var title: String
    var priority: Int // 5 = máxima, 1 = mínima
    var completed: Bool
    
    init(id: UUID = UUID(), title: String, priority: Int, completed: Bool = false) {
        self.id = id
        self.title = title
        self.priority = priority
        self.completed = completed
    }
    
    // MARK: CustomStringConvertible
    /// Proporciona una descripción legible de la tarea
    var description: String {
        let priorityText: String
        switch priority {
        case 5:
            priorityText = "🔴 Prioridad Máxima"
        case 4:
            priorityText = "🟠 Prioridad Alta"
        case 3:
            priorityText = "🟡 Prioridad Media"
        case 2:
            priorityText = "🟢 Prioridad Baja"
        default:
            priorityText = "⚪️ Sin prioridad"
        }
        
        let statusIcon = completed ? "✅" : "⬜️"
        return "\(statusIcon) \(priorityText)"
    }
    
    // MARK: Comparable
    /// Ordena tareas por prioridad (mayor prioridad primero)
    static func < (lhs: Task, rhs: Task) -> Bool {
        return lhs.priority < rhs.priority
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}
