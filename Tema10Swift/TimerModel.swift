//
//  TimerModel.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import Foundation
import Combine

// MARK: - TimerModel
/// Modelo observable que gestiona un timer simple
/// Demuestra la gestión del ciclo de vida con ScenePhase
class TimerModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var seconds: Int = 0
    @Published var isRunning: Bool = false
    
    // MARK: - Private Properties
    private var timer: Timer?
    private let secondsKey = "savedTimerSeconds"
    private let isRunningKey = "savedTimerIsRunning"
    
    // MARK: - Initialization
    init() {
        loadState()
        print("⏱️ TimerModel inicializado con \(seconds) segundos")
    }
    
    // MARK: - Public Methods
    
    /// Inicia el timer
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        print("▶️ Timer iniciado")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.seconds += 1
        }
    }
    
    /// Pausa el timer
    func pause() {
        guard isRunning else { return }
        
        isRunning = false
        timer?.invalidate()
        timer = nil
        print("⏸️ Timer pausado en \(seconds) segundos")
    }
    
    /// Resetea el timer a cero
    func reset() {
        pause()
        seconds = 0
        print("🔄 Timer reseteado")
    }
    
    // MARK: - Persistence
    
    /// Guarda el estado actual del timer
    /// SE LLAMA cuando la app pasa a .background o .inactive
    func saveState() {
        UserDefaults.standard.set(seconds, forKey: secondsKey)
        UserDefaults.standard.set(isRunning, forKey: isRunningKey)
        print("💾 Estado del timer guardado: \(seconds)s, running: \(isRunning)")
    }
    
    /// Carga el estado guardado del timer
    func loadState() {
        seconds = UserDefaults.standard.integer(forKey: secondsKey)
        let wasRunning = UserDefaults.standard.bool(forKey: isRunningKey)
        
        if wasRunning && seconds > 0 {
            // No reiniciamos automáticamente, solo restauramos el contador
            print("📂 Estado del timer cargado: \(seconds)s")
        }
    }
    
    // MARK: - Formatted Time
    
    /// Devuelve el tiempo formateado como MM:SS
    var formattedTime: String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    // MARK: - Deinit
    deinit {
        timer?.invalidate()
        print("⏱️ TimerModel liberado de memoria")
    }
}
