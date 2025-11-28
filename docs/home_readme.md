# Home Automation Trainer - Flutter App

## 1. Project Overview
This project is a **Flutter-based Home Automation Control Center** designed to interact with IoT devices via **MQTT** (and potentially RabbitMQ). It allows users to monitor and control various smart home devices such as Power Meters, Smart Lamps (Sensors), and Smart Plugs (Stekers/Actuators).

The app is built using the **Stacked** architecture (MVVM pattern), ensuring a clean separation between UI, business logic (ViewModels), and data/services.

**Target Audience:** Developers and AI Agents looking to understand the structure of a Flutter IoT application with MQTT integration.

---

## 2. Architecture & Design Pattern
The project follows the **MVVM (Model-View-ViewModel)** pattern using the `stacked` package.

-   **View (UI):** Located in `lib/ui/views`. Contains the visual elements (Widgets). Views are reactive and rebuild based on ViewModel state changes.
-   **ViewModel:** Located in `lib/viewmodels`. Contains the business logic, state management, and interaction with services. ViewModels do *not* depend on Flutter UI widgets directly.
-   **Services:** Located in `lib/services`. Singleton classes that handle data fetching, API calls, database interactions, and hardware communication (MQTT).
-   **Locator:** Uses `get_it` (via `lib/locator.dart`) for dependency injection. Services are registered here and injected into ViewModels.

---

## 3. Folder Structure (Detailed)

```
lib/
├── constants/          # App-wide constants (e.g., route_name.dart)
├── models/             # Data models
│   └── model_data_device.dart # Core 'Device' model class
├── services/           # Business logic and data services (Singletons)
│   ├── alert_service.dart    # Handles UI alerts/dialogs
│   ├── mqtt_service.dart     # MQTT connection, subscribe, publish logic
│   ├── rmq_service.dart      # RabbitMQ service (alternative to MQTT)
│   ├── sqflite_service.dart  # Local SQLite database for device persistence
│   └── storage_service.dart  # Shared Preferences wrapper
├── ui/                 # User Interface
│   ├── shared/         # Reusable UI components (helpers, styles)
│   └── views/          # Screen definitions
│       ├── dashboard_view.dart # Main control screen
│       ├── login_view.dart     # User authentication
│       ├── qr_view.dart        # QR Scanner for device adding
│       ├── register_view.dart  # Manual device registration
│       └── startup_view.dart   # Initial splash/loading screen
├── viewmodels/         # ViewModels for each View
│   ├── base_model.dart         # Common base class for ViewModels
│   ├── dahsboard_view_model.dart # Logic for Dashboard (MQTT handling, state)
│   ├── login_view_model.dart   # Logic for Login
│   └── ...
├── locator.dart        # Dependency Injection setup (GetIt)
├── main.dart           # App Entry point
└── router.dart         # Navigation routing setup
```

---

## 4. Key Features & Modules

### 4.1. MQTT Integration (`mqtt_service.dart`)
-   **Library:** `mqtt_client`
-   **Functionality:**
    -   Connects to an MQTT broker (Host, Port 1883).
    -   Subscribes to topics to receive real-time device data.
    -   Publishes commands to control devices (e.g., turning a lamp on/off).
-   **Usage:** The `DashboardViewModel` initializes the MQTT service and listens for updates to update the UI in real-time.

### 4.2. Local Database (`sqflite_service.dart`)
-   **Library:** `sqflite`
-   **Database Name:** `devices.db`
-   **Table:** `devices`
    -   `guid` (TEXT PRIMARY KEY): Unique identifier for the device.
    -   `statusaktuator` (TEXT): State of the actuator (e.g., "1" for ON, "0" for OFF).
    -   `statussensor` (TEXT): State of the sensor.
    -   `nameaktuator` (TEXT): User-friendly name for the actuator.
    -   `namesensor` (TEXT): User-friendly name for the sensor.
    -   `namepower` (TEXT): Name for the power meter.
-   **Purpose:** Persists registered devices so they remain available after restarting the app.

### 4.3. Device Model (`model_data_device.dart`)
Represents a smart device entity with properties:
-   `guid`: Global Unique Identifier.
-   `statusAktuator` / `statusSensor`: Current operational state.
-   `nameAktuator` / `nameSensor` / `namePower`: Display names.

### 4.4. Dashboard (`dashboard_view.dart` & `dahsboard_view_model.dart`)
-   **Display:** Shows real-time data for Power Meter (Voltage, Current, Power, Energy, Frequency).
-   **Control:** Toggles for "Lampu Trainer" (Sensor/Light) and "Steker Trainer" (Plug).
-   **Logic:**
    -   Fetches devices from SQLite on load.
    -   Connects to MQTT.
    -   Parses incoming MQTT messages to update the `Device` state variables (`voltage`, `current`, `power`, etc.).
    -   Sends MQTT commands when toggle buttons are pressed.

### 4.5. Device Registration
-   **QR Scan:** Uses `qr_code_scanner` to scan device QR codes containing GUID and other info.
-   **Manual Entry:** `RegisterView` allows manual input of device details.

---

## 5. Dependencies (pubspec.yaml)
Key packages used in this project:
-   `stacked`: ^3.4.0 (Architecture)
-   `get_it`: ^7.2.0 (Dependency Injection)
-   `mqtt_client`: ^10.0.1 (IoT Communication)
-   `qr_code_scanner`: ^1.0.1 (Camera/QR)
-   `shared_preferences`: ^2.0.17 (Simple Storage)
-   `flutter_screenutil`: ^5.9.0 (Responsive UI)

---

## 6. Notes for AI Agents (Context for Future Development)
If you are using this project as a reference for the "IWK Control Center" app:
1.  **Integration Logic:** Pay close attention to how `DashboardViewModel` bridges `MqttService` and the UI. The state is updated reactively.
2.  **Data Persistence:** The `LocalDatabase` class is crucial for storing the configuration of the 5 IWK modules you mentioned. You will likely need to expand the `devices` table or create new tables to accommodate the specific data fields of the 5 IWK modules.
3.  **GUID Handling:** The app relies heavily on `guid` for identifying devices in both MQTT topics and the local database. Ensure your new app maintains a consistent GUID strategy across all 5 modules.
4.  **Service Pattern:** Replicate the `MqttService` pattern. It encapsulates the complex connection logic, making the ViewModels cleaner.

---

## 7. Setup & Installation
1.  **Flutter Setup:** Ensure Flutter SDK (>=2.19.3 <3.0.0) is installed.
2.  **Dependencies:** Run `flutter pub get` to install packages.
3.  **Run:** Use `flutter run` to launch the app on an emulator or physical device.
