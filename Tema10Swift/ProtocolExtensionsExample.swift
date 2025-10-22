//
//  ProtocolExtensionsExample.swift
//  Tema10Swift
//
//  Created by JESUS GARZA on 21/10/25.
//

import SwiftUI

// MARK: - ProtocolExtensionsExampleView
/// Vista que demuestra el uso de extensiones de protocolo
/// Muestra cómo Identifiable puede extenderse con funcionalidad por defecto
struct ProtocolExtensionsExampleView: View {
    
    // MARK: - Sample Data
    private let users = [
        User(id: UUID(), name: "Ana García", email: "ana@example.com"),
        User(id: UUID(), name: "Carlos Ruiz", email: "carlos@example.com"),
        User(id: UUID(), name: "María López", email: "maria@example.com")
    ]
    
    private let people = [
        Person(id: "PER001", fullName: "Juan Pérez", age: 30),
        Person(id: "PER002", fullName: "Laura Martínez", age: 25),
        Person(id: "PER003", fullName: "Pedro Sánchez", age: 40)
    ]
    
    // Para demostrar Vehicle protocol
    @State private var myCar = Car(color: "Rojo", brand: "Toyota")
    @State private var myMotorcycle = Motorcycle(color: "Negro")
    @State private var consoleOutput: [String] = []
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // Header
                VStack(alignment: .leading, spacing: 5) {
                    Text("🔧 Extensiones de Protocolo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Demostrando funcionalidad por defecto")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Sección 1: Identifiable con UUID
                VStack(alignment: .leading, spacing: 10) {
                    Text("👤 Users (Identifiable con UUID)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Cada User tiene métodos displayID() e isValidID() gracias a la extensión del protocolo")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(users) { user in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Text(user.displayID())
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Text("• Valid: \(user.isValidID() ? "✅" : "❌")")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Sección 2: Identifiable con String
                VStack(alignment: .leading, spacing: 10) {
                    Text("👥 People (Identifiable con String)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Mismos métodos, diferente tipo de ID")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(people) { person in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(person.fullName)
                                .font(.headline)
                            Text("Edad: \(person.age) años")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Text(person.displayID())
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Text("• Valid: \(person.isValidID() ? "✅" : "❌")")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Sección 3: Vehicle Protocol Demo
                VStack(alignment: .leading, spacing: 10) {
                    Text("🚗 Vehicle Protocol Demo")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Car
                        VStack(alignment: .leading) {
                            Text("\(myCar.brand) \(myCar.color)")
                                .font(.headline)
                            Text("Ruedas: \(myCar.numberOfWheels)")
                                .font(.subheadline)
                            
                            HStack {
                                Button("Arrancar Motor") {
                                    addConsoleMessage("\(myCar.brand) arrancando...")
                                    myCar.startEngine()
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button("Cambiar a Azul") {
                                    myCar.changeColor(to: "Azul")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                        
                        // Motorcycle
                        VStack(alignment: .leading) {
                            Text("Motocicleta \(myMotorcycle.color)")
                                .font(.headline)
                            Text("Ruedas: \(myMotorcycle.numberOfWheels)")
                                .font(.subheadline)
                            
                            HStack {
                                Button("Arrancar Motor") {
                                    addConsoleMessage("Motocicleta arrancando...")
                                    myMotorcycle.startEngine()
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button("Cambiar a Blanco") {
                                    myMotorcycle.changeColor(to: "Blanco")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                        
                        // Console output
                        if !consoleOutput.isEmpty {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Console Output:")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                
                                ForEach(consoleOutput.suffix(5), id: \.self) { output in
                                    Text("> \(output)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Explicación
                VStack(alignment: .leading, spacing: 10) {
                    Text("💡 Conceptos clave:")
                        .font(.headline)
                    
                    Text("• Extension Identifiable where ID == UUID proporciona displayID() e isValidID()")
                    Text("• Extension Identifiable where ID == String tiene su propia implementación")
                    Text("• Vehicle protocol define propiedades y métodos mutating")
                    Text("• Car y Motorcycle conforman Vehicle de formas diferentes")
                }
                .font(.caption)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Helper Methods
    private func addConsoleMessage(_ message: String) {
        consoleOutput.append(message)
    }
}

// MARK: - Preview
#Preview {
    ProtocolExtensionsExampleView()
}
