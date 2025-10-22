//
//  TimerView.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import SwiftUI

// MARK: - TimerView
/// Vista que demuestra la gestión del ciclo de vida con ScenePhase
/// Guarda automáticamente el estado cuando la app pasa a background
struct TimerView: View {
    
    // MARK: - Properties
    @StateObject private var timer = TimerModel()
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 30) {
            Text("⏱️ Timer Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(timer.formattedTime)
                .font(.system(size: 72, weight: .bold, design: .monospaced))
                .foregroundColor(timer.isRunning ? .green : .primary)
            
            HStack(spacing: 20) {
                Button(action: {
                    if timer.isRunning {
                        timer.pause()
                    } else {
                        timer.start()
                    }
                }) {
                    Label(timer.isRunning ? "Pausar" : "Iniciar",
                          systemImage: timer.isRunning ? "pause.fill" : "play.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 50)
                        .background(timer.isRunning ? Color.orange : Color.green)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    timer.reset()
                }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("📱 Gestión de ScenePhase:")
                    .font(.headline)
                
                Text("• El timer se pausa automáticamente cuando la app pasa a segundo plano")
                Text("• El estado se guarda para restaurarlo después")
                Text("• Revisa la consola para ver los mensajes del ciclo de vida")
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(from: oldPhase, to: newPhase)
        }
    }
    
    // MARK: - Scene Phase Handling
    /// Maneja los cambios en el ciclo de vida de la app
    private func handleScenePhaseChange(from oldPhase: ScenePhase, to newPhase: ScenePhase) {
        print("🔄 ScenePhase cambió de \(String(describing: oldPhase)) a \(String(describing: newPhase))")
        
        switch newPhase {
        case .active:
            print("✅ App ACTIVA - Usuario interactuando")
            // La app está en primer plano y activa
            // Podríamos reanudar el timer aquí si lo deseamos
            
        case .inactive:
            print("⚠️ App INACTIVA - Transitando o interrumpida")
            // La app está visible pero no recibe eventos (ej: centro de notificaciones)
            timer.pause()
            timer.saveState()
            
        case .background:
            print("🌙 App en BACKGROUND - Guardando estado")
            // La app no está visible, puede ser terminada en cualquier momento
            timer.pause()
            timer.saveState()
            
        @unknown default:
            print("❓ Estado desconocido de ScenePhase")
        }
    }
}

// MARK: - Preview
#Preview {
    TimerView()
}
