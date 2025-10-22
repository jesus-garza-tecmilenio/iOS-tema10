//
//  DataStore.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - DataStore
/// Clase observable que gestiona las tareas de la aplicación
/// Demuestra persistencia con UserDefaults y gestión del ciclo de vida (ScenePhase)
class DataStore: ObservableObject {
    
    // MARK: - Published Properties
    /// Lista de tareas que notifica cambios a las vistas
    @Published var tasks: [Task] = []
    
    // MARK: - Constants
    private let tasksKey = "savedTasks"
    
    // MARK: - Initialization
    init() {
        loadData()
        print("🗄️ DataStore inicializado")
    }
    
    // MARK: - Public Methods
    
    /// Añade una nueva tarea a la lista
    func addTask(title: String, priority: Int) {
        let newTask = Task(title: title, priority: priority, completed: false)
        tasks.append(newTask)
        print("➕ Tarea añadida: \(newTask.title)")
    }
    
    /// Alterna el estado de completado de una tarea
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed.toggle()
            print("✏️ Tarea actualizada: \(tasks[index].title) - Completada: \(tasks[index].completed)")
        }
    }
    
    /// Elimina una tarea de la lista
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        print("🗑️ Tarea eliminada: \(task.title)")
    }
    
    /// Elimina tareas por índices (para List con onDelete)
    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        print("🗑️ Tareas eliminadas")
    }
    
    // MARK: - Persistence
    
    /// Guarda las tareas en UserDefaults usando JSON
    /// SE LLAMA AUTOMÁTICAMENTE cuando la app pasa a background (ScenePhase)
    func saveData() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: tasksKey)
            print("💾 Datos guardados exitosamente (\(tasks.count) tareas)")
        } catch {
            print("❌ Error al guardar datos: \(error.localizedDescription)")
        }
    }
    
    /// Carga las tareas desde UserDefaults
    /// SE LLAMA AUTOMÁTICAMENTE en init()
    func loadData() {
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else {
            print("📝 No hay datos guardados, cargando tareas por defecto")
            tasks = defaultTasks
            return
        }
        
        do {
            let decoder = JSONDecoder()
            tasks = try decoder.decode([Task].self, from: data)
            print("📂 Datos cargados exitosamente (\(tasks.count) tareas)")
        } catch {
            print("❌ Error al cargar datos: \(error.localizedDescription)")
            tasks = defaultTasks
        }
    }
    
    /// Simula el cierre de conexiones de red o bases de datos
    /// SE LLAMA cuando la app pasa a background
    func closeConnections() {
        print("🔌 Cerrando conexiones de red y liberando recursos...")
        // TODO: En una app real, aquí cerrarías:
        // - Sockets WebSocket
        // - Conexiones de base de datos
        // - Streams de audio/video
        // - Timers activos
    }
    
    // MARK: - Filtering & Sorting (Equatable & Comparable en uso)
    
    /// Devuelve solo las tareas incompletas
    func incompleteTasks() -> [Task] {
        return tasks.filter { !$0.completed }
    }
    
    /// Devuelve solo las tareas completadas
    func completedTasks() -> [Task] {
        return tasks.filter { $0.completed }
    }
    
    /// Devuelve tareas ordenadas por prioridad (alta primero)
    func tasksSortedByPriority() -> [Task] {
        return tasks.sorted { $0.priority < $1.priority }
    }
    
    /// Verifica si existe una tarea con un título específico (usa Equatable implícitamente)
    func containsTask(withTitle title: String) -> Bool {
        return tasks.contains { $0.title == title }
    }
}

// MARK: - Notas sobre ScenePhase y Persistencia
/*
 ¿Por qué guardar datos en background?
 
 Cuando el usuario:
 1. Presiona el botón Home → La app pasa a .background
 2. Cambia a otra app → La app pasa a .inactive y luego .background
 3. El sistema mata la app por memoria → Los datos se pierden si no se guardaron
 
 ScenePhase nos permite detectar estos cambios y guardar datos automáticamente:
 - .active: App en primer plano, interactuando con el usuario
 - .inactive: App visible pero no interactúa (ej: durante una llamada)
 - .background: App no visible, puede ser terminada en cualquier momento
 
 En Tema10SwiftApp.swift monitorizamos scenePhase y llamamos:
 - dataStore.saveData() cuando pasa a .background
 - dataStore.closeConnections() para liberar recursos
 
 Esto garantiza que los datos del usuario NO SE PIERDAN.
 */
