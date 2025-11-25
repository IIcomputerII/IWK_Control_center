# Project Structure & Documentation

Based on the provided whiteboard, notebook images, and existing file structure.

## 1. Application Flow (Flowchart)

### A. Initial Process (Login/Credential)

1.  **Input Credential**: User enters login details.
2.  **Storage**: Save credentials to `flutter_secure_storage` (Encrypted local storage).
3.  **Navigate**: Proceed to **Menu Utama (Dashboard)**.

### B. Main Menu Scenarios (Menu Utama)

The dashboard has two main interaction flows:

#### Scenario 1: Direct Navigation (Left Side)

1.  **Display Options**: Show 5 IWK options (e.g., Water, Saga, Env, Gravity, Home).
2.  **Select IWK**: User taps an option -> Route to specific **IWK Page** (e.g., `waterpage_view.dart`).
3.  **Display Data**: Show all data from MQTT.
4.  **Unique Credential**: Button to route to **Unique Credential Input**.
5.  **Input Details**: User inputs **Topic** and **GUID**.
6.  **View Data**: Button to route back to **IWK Page**.
7.  **Output**: Display data filtered by `topic=...` and `guid=...`.

#### Scenario 2: Device History (Right Side)

1.  **Display History**: Show list of devices previously connected.
2.  **Add Device**: Button to add a new device -> Route to **Choose IWK Page**.
3.  **Select IWK**: Show 5 IWK options.
4.  **Input Details**: Route to **Unique Credential Input** -> Input **Topic** and **GUID**.
5.  **View Data**: Route to **IWK Page**.
6.  **Output**: Display data filtered by `topic=...` and `guid=...`.

---

## 2. Architecture & Directory Structure (MVVM)

The project follows the **MVVM (Model-View-ViewModel)** pattern.

### Components

- **Model (Data)**: Responsible for fetching data (e.g., from MQTT).
- **View (UI)**: The user interface (Screens/Pages).
- **ViewModel (Function)**: The logic layer that connects Model and View.
- **Widget**: Reusable UI components.

### Directory Structure (`/lib`)

#### `/lib/ui/views` (Views)

- `login_view.dart`
- `dashboard_view.dart`
- `chooseiwk_view.dart`
- `uniquecredential_view.dart`
- `/iwkpage`:
  - `envpage_view.dart`
  - `gravity_view.dart`
  - `homepage._view.dart`
  - `sagapage_view.dart`
  - `waterpage_view.dart`

#### `/lib/viewmodels` (Logic)

- `login_view_modal.dart`
- `dashboard_view_modal.dart`
- `chooseiwk_view_modal.dart`
- `uniquecredential_view_modal.dart`
- `/iwkpage`:
  - `envpage_view_modal.dart`
  - `gravity_view_modal.dart`
  - `homepage._view_modal.dart`
  - `sagapage_view_modal.dart`
  - `waterpage_view_modal.dart`

#### `/lib/model` (Data Layer)

- Handles data fetching logic (MQTT connection, etc.).

---

## 3. Data Flow

1.  **Device (Alat)**: Sends data to MQTT Broker.
2.  **MQTT**: Broker receives and holds data.
3.  **Model**: Subscribes/Fetches data from MQTT.
4.  **ViewModel**: Requests data from Model.
5.  **View**: Requests data from ViewModel and displays it to the User.
