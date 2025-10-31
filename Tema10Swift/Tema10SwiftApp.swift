//
//  Tema10SwiftApp.swift
//  Tema10Swift
//
//  Punto de entrada principal de la aplicación
//  Demuestra: ScenePhase y el ciclo de vida de la app
//

import SwiftUI

@main
struct Tema10SwiftApp: App {
    
    // MARK: - ScenePhase
    /// Monitorea el estado actual de la escena (app)
    /// ScenePhase tiene 3 estados principales:
    /// - .active: La app está en primer plano y recibiendo eventos
    /// - .inactive: La app está visible pero no recibiendo eventos (ej: durante una transición)
    /// - .background: La app está en segundo plano
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // MARK: - onChange de ScenePhase
        /// Detecta cambios en el estado del ciclo de vida
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(from: oldPhase, to: newPhase)
        }
    }
    
    // MARK: - Handle ScenePhase Changes
    /// Maneja las transiciones entre diferentes estados del ciclo de vida
    private func handleScenePhaseChange(from oldPhase: ScenePhase, to newPhase: ScenePhase) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        
        switch newPhase {
        case .active:
            print("🟢 [\(timestamp)] App ACTIVA - La app está en primer plano y recibiendo eventos")
            // Aquí puedes: reanudar animaciones, refrescar datos, reconectar sockets, etc.
            
        case .inactive:
            print("🟡 [\(timestamp)] App INACTIVA - La app está visible pero no recibe eventos")
            // Esto ocurre durante transiciones o cuando aparece el centro de control
            // Aquí puedes: pausar tareas críticas temporalmente
            
        case .background:
            print("🔴 [\(timestamp)] App en BACKGROUND - La app no está visible")
            // Aquí puedes: guardar datos, pausar animaciones, liberar recursos, etc.
            saveAppState()
            
        @unknown default:
            print("⚪️ [\(timestamp)] Estado desconocido de ScenePhase")
        }
    }
    
    // MARK: - Save App State
    /// Guarda el estado de la app cuando pasa a segundo plano
    private func saveAppState() {
        print("💾 Guardando estado de la aplicación...")
        // Aquí implementarías la lógica real de guardado
        // Ejemplo: UserDefaults, CoreData, FileManager, etc.
    }
}
