//
//  Tema10SwiftApp.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import SwiftUI

// MARK: - Tema10SwiftApp
/// Punto de entrada principal de la aplicación
/// Demuestra la gestión del ciclo de vida con ScenePhase y persistencia automática
@main
struct Tema10SwiftApp: App {
    
    // MARK: - Properties
    /// DataStore compartido para toda la aplicación
    @StateObject private var dataStore = DataStore()
    
    /// Monitoriza el estado del ciclo de vida de la aplicación
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(from: oldPhase, to: newPhase)
        }
    }
    
    // MARK: - Scene Phase Handling
    /// Maneja los cambios en el ciclo de vida de la aplicación
    /// IMPORTANTE: Guarda datos automáticamente cuando la app pasa a segundo plano
    private func handleScenePhaseChange(from oldPhase: ScenePhase, to newPhase: ScenePhase) {
        print("\n🔄 === CAMBIO DE SCENEPHONE ===")
        print("De: \(String(describing: oldPhase)) → A: \(String(describing: newPhase))")
        
        switch newPhase {
        case .active:
            print("✅ App ACTIVA")
            print("   • Usuario está interactuando con la app")
            print("   • La app está en primer plano")
            print("   • Se pueden reanudar animaciones y timers")
            
        case .inactive:
            print("⚠️ App INACTIVA")
            print("   • App visible pero no recibe eventos")
            print("   • Ejemplo: Centro de control, notificaciones")
            print("   • Estado transitorio entre active y background")
            dataStore.saveData()
            
        case .background:
            print("🌙 App en BACKGROUND")
            print("   • App no visible para el usuario")
            print("   • Puede ser terminada por el sistema en cualquier momento")
            print("   • ⚠️ CRÍTICO: Guardar datos AHORA")
            
            // GUARDAR DATOS - Esto previene pérdida de información
            dataStore.saveData()
            
            // CERRAR CONEXIONES - Liberar recursos
            dataStore.closeConnections()
            
            print("   ✅ Datos guardados y recursos liberados")
            
        @unknown default:
            print("❓ Estado desconocido de ScenePhase")
        }
        
        print("=================================\n")
    }
}

// MARK: - Notas sobre ScenePhase
/*
 GESTIÓN DEL CICLO DE VIDA CON SCENEPHASE
 
 ScenePhase es un enum que representa el estado de la escena de la app:
 
 1. .active
    - La app está en primer plano
    - El usuario está interactuando con ella
    - Es el momento de reanudar animaciones, timers, etc.
 
 2. .inactive
    - Estado transitorio (normalmente breve)
    - La app está visible pero no recibe eventos
    - Ocurre cuando: aparece centro de control, notificación emergente, etc.
 
 3. .background
    - La app no está visible
    - El usuario cambió a otra app o presionó Home
    - ⚠️ CRÍTICO: El sistema puede terminar la app en cualquier momento
    - Es IMPERATIVO guardar datos aquí
 
 ¿Por qué es importante?
 - iOS puede matar apps en background sin previo aviso
 - Si no guardas datos en .background, se pierden
 - Es responsabilidad del desarrollador preservar el estado
 
 Ejemplo de uso:
 1. Usuario edita tareas → Cambios en memoria
 2. Usuario presiona Home → onChange detecta .background
 3. App llama a dataStore.saveData() → Datos en UserDefaults
 4. Sistema mata la app → ✅ Datos seguros
 5. Usuario reabre app → init() carga datos desde UserDefaults
 
 TODO para testing manual:
 1. Ejecuta la app en simulador/dispositivo
 2. Agrega algunas tareas
 3. Presiona Cmd+Shift+H (simulador) o Home (dispositivo)
 4. Observa los print() en la consola de Xcode
 5. Termina la app desde el selector de apps
 6. Reabre la app → ¡Las tareas siguen ahí! ✅
 */
