.# Tema 10 Swift - Proyecto Demostración

## 📚 Descripción

Este proyecto demuestra todos los conceptos fundamentales del **Tema 10: Protocolos, Delegación y Gestión del Ciclo de Vida** en Swift y SwiftUI.

### Conceptos Implementados

- ✅ **Protocolos** (Vehicle, DataManagerDelegate)
- ✅ **Delegación** (patrón Delegate con weak reference)
- ✅ **Equatable** (comparación de igualdad en Coordinate, Student)
- ✅ **Comparable** (ordenamiento de Student por calificación)
- ✅ **CustomStringConvertible** (descripción personalizada de Task)
- ✅ **Extensiones de Protocolo** (Identifiable con funcionalidad por defecto)
- ✅ **Gestión del Ciclo de Vida** (ScenePhase para persistencia automática)
- ✅ **Persistencia** (JSON en UserDefaults)
- ✅ **MVVM Architecture** (ViewModels con @ObservableObject)

---

## 🗂️ Estructura de Archivos

### Archivos Principales

1. **Tema10SwiftApp.swift** - Punto de entrada de la app
   - Gestión de ScenePhase (.active, .inactive, .background)
   - Persistencia automática cuando la app pasa a segundo plano
   - DataStore compartido vía @EnvironmentObject

2. **Models.swift** - Modelos de datos
   - `Coordinate`: Demuestra **Equatable**
   - `Student`: Demuestra **Comparable** y **Equatable**
   - `Task`: Demuestra **CustomStringConvertible**
   - Ejemplos de uso de `contains()` y `sorted()`

3. **Protocols.swift** - Definiciones de protocolos
   - `Vehicle`: Protocolo con propiedades y métodos mutating
   - `Car` y `Motorcycle`: Implementaciones de Vehicle
   - `DataManagerDelegate`: Protocolo de delegación
   - Extensiones de `Identifiable` con funcionalidad por defecto

4. **DataManager.swift** - Gestor de datos remotos
   - Simula peticiones de red asíncronas
   - Usa delegación para notificar resultados
   - **weak var delegate** para evitar retain cycles

5. **DataStore.swift** - Almacenamiento de tareas
   - @Published para notificar cambios a las vistas
   - Persistencia con JSON en UserDefaults
   - `saveData()` y `loadData()` automáticos

6. **ContentView.swift** - Vista principal
   - Lista de tareas con CRUD completo
   - Integración con DataManager vía delegación
   - Tabs para diferentes demos
   - ContentViewModel como DataManagerDelegate

7. **TimerView.swift** y **TimerModel.swift** - Demo de Timer
   - Gestión del ciclo de vida con ScenePhase
   - Pausa automática en background
   - Persistencia del estado del timer

8. **DelegationExampleView.swift** - Demo de delegación
   - Muestra el patrón de delegación completo
   - ViewModel actúa como delegado
   - Manejo de éxito y error

9. **ProtocolExtensionsExample.swift** - Demo de extensiones
   - Uso de extensiones de Identifiable
   - Demostración de Vehicle protocol
   - Interacción con Car y Motorcycle

---

## 🚀 Cómo Ejecutar

### Requisitos
- Xcode 15+ 
- iOS 17+ (simulador o dispositivo)
- Swift 5.9+

### Pasos
1. Abre `Tema10Swift.xcodeproj` en Xcode
2. Selecciona un simulador (ej: iPhone 15)
3. Presiona `Cmd + R` para ejecutar
4. ¡Explora los 5 tabs de la aplicación!

---

## 🧪 Cómo Probar Manualmente

### 1. Protocolos y Equatable/Comparable
- Ve al tab **"Estudiantes"** 👨‍🎓
- Observa cómo los estudiantes están ordenados por calificación (Comparable)
- El array usa `.sorted()` gracias a la implementación del operador `<`

### 2. CustomStringConvertible
- Ve al tab **"Tareas"** 📝
- Observa la descripción de cada tarea (emoji + prioridad + título)
- Esto viene del método `description` del protocolo CustomStringConvertible

### 3. Delegación (DataManagerDelegate)
- En el tab **"Tareas"**, presiona el botón **"📡 Obtener Datos Remotos"**
- Espera 2 segundos (simulación de red)
- Verás una alerta con los datos recibidos (80% éxito) o error (20%)
- Revisa la consola de Xcode para ver los logs de delegación
- **También** ve al tab **"Delegación"** para ver una demo dedicada

### 4. ScenePhase y Persistencia
**Prueba más importante del proyecto:**

a) **En el Simulador:**
   1. Agrega varias tareas en el tab "Tareas"
   2. Presiona `Cmd + Shift + H` (botón Home)
   3. Revisa la consola de Xcode → verás los mensajes de ScenePhase
   4. Termina la app desde el selector de apps (swipe up)
   5. Reabre la app → ¡Las tareas siguen ahí! ✅

b) **En el tab Timer:**
   1. Ve al tab **"Timer"** ⏱️
   2. Inicia el timer
   3. Presiona Home (`Cmd + Shift + H`)
   4. Observa en consola: "App en BACKGROUND - Guardando estado"
   5. Reabre la app → El timer mantiene el contador

### 5. Extensiones de Protocolo
- Ve al tab **"Protocolos"** 🔧
- Observa cómo `User` y `Person` usan `displayID()` e `isValidID()`
- Estos métodos vienen de la extensión de Identifiable
- Interactúa con los botones de Car y Motorcycle

---

## 📖 Mapeo Concepto → Archivo

| Concepto | Archivo(s) | Ubicación |
|----------|-----------|-----------|
| **Equatable** | Models.swift | Coordinate, Student |
| **Comparable** | Models.swift | Student (operador <) |
| **CustomStringConvertible** | Models.swift | Task.description |
| **Protocolos** | Protocols.swift | Vehicle, DataManagerDelegate |
| **Delegación** | DataManager.swift + ContentView.swift | weak var delegate |
| **Extensiones de Protocolo** | Protocols.swift | extension Identifiable |
| **ScenePhase** | Tema10SwiftApp.swift + TimerView.swift | .onChange(of: scenePhase) |
| **Persistencia** | DataStore.swift + TimerModel.swift | saveData() / loadData() |

---

## 🎯 Puntos Clave para la Presentación

### 1. Equatable
```swift
// Permite comparar instancias por igualdad
let coord1 = Coordinate(latitude: 40.7, longitude: -74.0)
let coord2 = Coordinate(latitude: 40.7, longitude: -74.0)
coord1 == coord2 // true

// También permite usar contains()
coordinates.contains(searchCoordinate)
```

### 2. Comparable
```swift
// Permite ordenar automáticamente con sorted()
let sortedStudents = students.sorted() // Ordenados por calificación
let topStudent = sortedStudents.first  // Mejor estudiante
```

### 3. CustomStringConvertible
```swift
let task = Task(title: "Estudiar", priority: 1)
print(task) // ⬜️ [🔴 Alta] Estudiar
// En lugar de: Task(id: UUID(...), title: "Estudiar", ...)
```

### 4. Delegación
```swift
// ❌ Problema: Retain cycle
class ViewController {
    let manager = DataManager()
    init() { manager.delegate = self } // ViewController retiene manager
}

// ✅ Solución: weak delegate
protocol DataManagerDelegate: AnyObject { ... }
class DataManager {
    weak var delegate: DataManagerDelegate? // No retiene al delegate
}
```

### 5. ScenePhase
```swift
.onChange(of: scenePhase) { old, new in
    switch new {
    case .active:    // App en primer plano
    case .inactive:  // Transitorio
    case .background: // ¡GUARDAR DATOS AHORA!
        dataStore.saveData()
    }
}
```

---

## 🐛 Debugging Tips

### Ver logs de ScenePhase
1. Ejecuta la app en Xcode
2. Abre la consola (View → Debug Area → Show Debug Area)
3. Presiona Home → Verás logs detallados del ciclo de vida

### Verificar persistencia
```bash
# Ver UserDefaults en simulador
defaults read com.yourname.Tema10Swift
```

### Simular memory warning
En el simulador: **Debug → Simulate Memory Warning**

---

## 📝 TODOs para Mejoras Futuras

- [ ] Reemplazar simulación de red con URLSession real
- [ ] Agregar Core Data para persistencia más robusta
- [ ] Implementar Combine para reactive programming
- [ ] Agregar tests unitarios para ViewModels
- [ ] Implementar pull-to-refresh en la lista de tareas
- [ ] Agregar animaciones en las transiciones
- [ ] Soporte para modo oscuro personalizado

---

## 🎓 Recursos Adicionales

- [Apple Documentation - Protocols](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)
- [Apple Documentation - ScenePhase](https://developer.apple.com/documentation/swiftui/scenephase)
- [WWDC - Managing App Life Cycle](https://developer.apple.com/videos/play/wwdc2020/10037/)

---

## 👨‍💻 Autor

**JESUS GARZA**  
Fecha: 21/10/25

---

## 📄 Licencia

Este proyecto es material educativo para el Tema 10 de Swift.
