# Tema 10: Protocolos en Swift

Bienvenidos al proyecto de ejemplo del Tema 10. Este proyecto demuestra los conceptos fundamentales de protocolos en Swift a través de ejemplos prácticos y sencillos.

## 📚 Conceptos Cubiertos

Este proyecto cubre los siguientes temas:

1. **Protocolos básicos** - Definición e implementación
2. **Equatable** - Comparación de igualdad entre objetos
3. **Comparable** - Ordenamiento de objetos
4. **CustomStringConvertible** - Descripciones personalizadas
5. **Delegación** - Patrón de diseño para comunicación entre objetos

## 🗂️ Estructura del Proyecto

```
Tema10Swift/
├── Tema10SwiftApp.swift      # Punto de entrada de la app
├── ContentView.swift          # Vista principal con todos los ejemplos
├── Models.swift               # Coordinate, Student y Task
├── Protocols.swift            # Vehicle y DataManagerDelegate
└── DataManager.swift          # Ejemplo de delegación
```

## 🎯 Cómo Usar Este Proyecto

### 1. Ejecutar la App

1. Abre `Tema10Swift.xcodeproj` en Xcode
2. Selecciona un simulador de iPhone
3. Presiona `Cmd + R` para ejecutar

### 2. Explorar los Ejemplos

La app muestra cuatro secciones principales:

#### ⚖️ Equatable & Comparable
- Muestra una lista de tareas ordenadas automáticamente por prioridad
- **Concepto**: `Comparable` permite usar `sorted()` y operadores `<`, `>`
- **Archivo**: `Models.swift` - revisa la implementación de `Task`

#### 🔄 Delegación
- Presiona "Obtener Datos Remotos" para ver el patrón de delegación en acción
- **Concepto**: `DataManager` notifica eventos al `ViewModel` a través del protocolo `DataManagerDelegate`
- **Archivos**: `DataManager.swift` y `Protocols.swift`

#### 🚗 Protocolo Vehicle
- Muestra un ejemplo interactivo de cómo implementar un protocolo
- Presiona el botón para cambiar el color del coche
- **Concepto**: Protocolos definen "contratos" que las estructuras/clases deben cumplir
- **Archivo**: `Protocols.swift` - revisa `Vehicle` y `Car`

#### 📚 Conceptos Demostrados
- Resumen visual de todos los conceptos implementados en el proyecto

## 📖 Guía de Estudio

### Paso 1: Entender los Protocolos Básicos

Abre `Protocols.swift` y estudia:

```swift
protocol Vehicle {
    var numberOfWheels: Int { get }      // Solo lectura
    var color: String { get set }        // Lectura y escritura
    
    func startEngine()
    mutating func changeColor(to newColor: String)
}
```

**Pregunta clave**: ¿Por qué `changeColor` necesita ser `mutating`?

### Paso 2: Equatable y Comparable

Abre `Models.swift` y estudia la estructura `Task`:

- **Equatable**: Permite comparar con `==`
- **Comparable**: Permite ordenar con `<`, `>`, `sorted()`
- **CustomStringConvertible**: Proporciona `description` personalizada

**Ejercicio**: Intenta agregar un nuevo tipo de prioridad a las tareas.

### Paso 3: Delegación

Sigue el flujo de delegación:

1. `ContentView.swift` → El `ContentViewModel` se registra como delegado
2. `ContentViewModel` → Implementa `DataManagerDelegate`
3. Usuario presiona botón → Llama a `dataManager.fetchData()`
4. `DataManager.swift` → Simula red y notifica al delegado
5. `ContentViewModel` → Recibe notificación y actualiza UI

**Pregunta clave**: ¿Por qué el delegate se declara como `weak`?

## 🔍 Detalles de Implementación

### Equatable

```swift
struct Coordinate: Equatable {
    let latitude: Double
    let longitude: Double
}

// Ahora puedes comparar:
let coord1 = Coordinate(latitude: 40.7, longitude: -74.0)
let coord2 = Coordinate(latitude: 40.7, longitude: -74.0)
let areEqual = coord1 == coord2  // true
```

### Comparable

```swift
struct Student: Comparable {
    let name: String
    let grade: Double
    
    static func < (lhs: Student, rhs: Student) -> Bool {
        return lhs.grade > rhs.grade  // Mejor calificación primero
    }
}

// Ahora puedes ordenar:
let sorted = students.sorted()  // Ordenados por calificación
```

### Delegación

```swift
// 1. Definir el protocolo
protocol DataManagerDelegate: AnyObject {
    func dataManager(_ manager: DataManager, didReceiveData data: [String])
}

// 2. En el delegador (DataManager)
class DataManager {
    weak var delegate: DataManagerDelegate?
    
    func fetchData() {
        // ... obtener datos ...
        delegate?.dataManager(self, didReceiveData: data)
    }
}

// 3. En el delegado (ViewModel)
class ContentViewModel: DataManagerDelegate {
    func dataManager(_ manager: DataManager, didReceiveData data: [String]) {
        // Procesar datos recibidos
    }
}
```

## 💡 Conceptos Importantes

### ¿Por qué usar `weak` en el delegate?

```swift
weak var delegate: DataManagerDelegate?
```

- Evita **retain cycles** (ciclos de retención)
- Si el delegado se destruye, la referencia automáticamente se vuelve `nil`
- Es una buena práctica en el patrón de delegación

### ¿Cuándo usar cada protocolo?

- **Equatable**: Cuando necesitas comparar si dos objetos son iguales
- **Comparable**: Cuando necesitas ordenar objetos
- **CustomStringConvertible**: Cuando quieres una representación textual personalizada
- **Protocolo personalizado**: Para definir contratos específicos de tu app

## 🎓 Ejercicios Propuestos

1. **Fácil**: Agrega una nueva propiedad `dueDate` al struct `Task` y ordena por fecha
2. **Medio**: Crea un nuevo protocolo `Printable` con un método `printDetails()`
3. **Avanzado**: Implementa un segundo delegado para `DataManager` que maneje eventos de progreso

## ⚠️ Errores Comunes

1. **Olvidar `mutating`**: Los métodos que modifican structs necesitan `mutating`
2. **No usar `weak`**: El delegate debe ser `weak` para evitar retain cycles
3. **Confundir `==` con `===`**: `==` compara valores (Equatable), `===` compara referencias
4. **No implementar todos los métodos**: Un protocolo es un contrato completo

## 📝 Notas Adicionales

- Todos los comentarios en el código están en español para facilitar el aprendizaje
- Los print statements ayudan a seguir el flujo de delegación
- Cada struct/class tiene comentarios explicando qué protocolo demuestra

## 🤝 Preguntas Frecuentes

**P: ¿Por qué Task es tanto Comparable como CustomStringConvertible?**  
R: Para demostrar que un tipo puede conformar múltiples protocolos simultáneamente.

**P: ¿Cuál es la diferencia entre `{ get }` y `{ get set }`?**  
R: `{ get }` es solo lectura, `{ get set }` permite lectura y escritura.

**P: ¿Por qué DataManagerDelegate hereda de AnyObject?**  
R: Para que solo las clases (no structs) puedan ser delegados, permitiendo usar `weak`.

## 📚 Recursos Adicionales

- [Documentación oficial de Swift - Protocols](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)
- [Apple Developer - Delegation](https://developer.apple.com/documentation/swift/cocoa_design_patterns)

---

**Desarrollado para el curso de Desarrollo de Aplicaciones iOS**  
*Universidad Tecmilenio*

Si encuentras algún error o tienes sugerencias, no dudes en comentarlo en clase.
