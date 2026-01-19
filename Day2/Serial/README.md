# 🚠 Serial Connection 

**`Serial Manager`** is a Swift class that you can add to your app to allow for serial connections in your SwiftUI app. It uses @observable to bind data to your swiftUI views


## ✨ Adding to your App:
For a 'single point of truth', it’s best to create the SerialManager in the app’s entry point so it’s initialized once and accessible to all views. If you create it in the ContentView it might get remade as the app is running which causes issues.

```swift
import SwiftUI

@main
struct YourApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var serial = SerialManager()
    //@State private var serial = MockSerialManager()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(serial: serial)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                print("🛑 App moving to background — closing serial.")
                serial.disconnect()
            }
        }
    }
}
```

Then in your ContentView (or wherever you want to use it) just add this:
```swift
var serial: SerialManager
```
---

#You can send multiple values from your serial device

Send your values formatted like this, you can send as many or as few as you like:
```swift
V:123>V:1234>V:123>
```
### 🔧 `mapRange(index:inMin:inMax:outMin:outMax:)`

Maps a value from the `latestValuesFromArduino` array at the specified index from one numerical range to another.  
This is useful for converting raw Arduino sensor values (e.g., 0–1023) into display values, animation parameters, or normalized outputs.

#### **Parameters**
| Name | Type | Description |
|------|------|-------------|
| `index` | `Int` | The position of the value in `latestValuesFromArduino` to map. |
| `inMin` | `Float` | The minimum expected input value (e.g. the lowest sensor reading). |
| `inMax` | `Float` | The maximum expected input value (e.g. the highest sensor reading). |
| `outMin` | `Float` | The minimum output range value (e.g. screen coordinate minimum). |
| `outMax` | `Float` | The maximum output range value (e.g. normalized or screen coordinate maximum). |

#### **Throws**
- `SerialManagerError.noValueAtIndex` — if the specified `index` is out of range or `latestValuesFromArduino` has no value at that position.

#### **Returns**
A `Float` that represents the mapped value from the input range `[inMin, inMax]` to the output range `[outMin, outMax]`.

#### **Example**
```swift
// Example: Map a sensor reading (0–1023) to normalized brightness (0–1)
let brightness = try serial.mapRange(
    index: 0,
    inMin: 0,
    inMax: 1023,
    outMin: 0,
    outMax: 1
)
```


