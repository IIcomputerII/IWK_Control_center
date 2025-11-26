# IWK Topics & Keywords Spec
Dokumen ini menjelaskan **berapa banyak topik/queue** dan **kata kunci (keywords/payload fields)** yang dibutuhkan untuk **setiap modul IWK** di IWK Control Center.

Semua modul memakai broker yang sama:

- **Host**: `iwkrmq.pptik.id`
- **VHost**: `/trainerkit`
- **User**: `trainerkit`
- **Password**: `12345678`

Istilah **topic/queue** di sini dipakai generik (bisa RabbitMQ queue, MQTT topic, atau “logical channel”).

Struktur umum per modul:
- Minimal 1 *sensor topic* (wajib)
- Optional 1 *log topic* (sangat disarankan)
- Optional 1 *control topic* (kalau modul punya aktuator/kontrol)

---

## 1. Smart Watering

### 1.1. Jumlah & Nama Topic

**Total minimal: 2 topic**  
Rekomendasi:

1. **Sensor Topic**  
   - `smart_watering.sensor`  
   - Fungsi: streaming nilai kelembapan tanah + status pompa saat ini.

2. **Log Topic**  
   - `smart_watering.log`  
   - Fungsi: mencatat event seperti:
     - pergantian mode (AUTO/MANUAL)
     - pompa ON/OFF
     - error sensor
     - threshold tercapai.

3. **Control Topic (opsional, kalau mau kontrol dari app)**  
   - `smart_watering.control`  
   - Fungsi: menerima perintah dari app, misalnya:
     - paksa pompa ON/OFF
     - ubah mode (AUTO/MANUAL)
     - ubah threshold kelembapan.

> Kalau mau pure monitoring dulu, cukup pakai `sensor` + `log`.

### 1.2. Keywords / Payload Fields

**Sensor Topic – contoh field:**
- `guid` : GUID unik kit
- `ts` : timestamp (epoch/datetime)
- `soil_moisture` : nilai mentah atau persen (%)
- `soil_status` : DRY / MOIST / WET
- `pump_status` : ON / OFF
- `mode` : AUTO / MANUAL
- `battery` (opsional) : persen baterai kalau ada
- `signal` (opsional) : kualitas wifi / rssi

**Log Topic – contoh field:**
- `guid`
- `ts`
- `event` : string singkat (PUMP_ON, PUMP_OFF, MODE_AUTO, MODE_MANUAL, SENSOR_ERROR)
- `detail` : teks lebih panjang (opsional)
- `level` : info / warning / error

**Control Topic – contoh field:**
- `guid`
- `command` : PUMP_ON / PUMP_OFF / SET_MODE / SET_THRESHOLD
- `value` : isi tergantung command (misal: AUTO / MANUAL / angka threshold)
- `ts` : optional timestamp

---

## 2. Home Automation

### 2.1. Jumlah & Nama Topic

**Total minimal: 3 topic**

1. **Sensor Topic**
   - `home_auto.sensor`
   - Fungsi: status semua channel (saklar/steker/sensor lain).

2. **Log Topic**
   - `home_auto.log`
   - Fungsi: histori perubahan status + error.

3. **Control Topic**
   - `home_auto.control`
   - Fungsi: perintah ON/OFF per channel atau skenario tertentu.

### 2.2. Keywords / Payload Fields

**Sensor Topic – contoh field:**
- `guid`
- `ts`
- `channels`: array/list objek:
  - `id` : CH1 / CH2 / dll
  - `type` : RELAY / STEKER / LAMP / SENSOR
  - `state` : ON / OFF / nilai lain (misal brightness)
- `room` (opsional) : nama ruangan
- `scene` (opsional) : skenario aktif (NIGHT_MODE, AWAY_MODE)

**Log Topic – contoh field:**
- `guid`
- `ts`
- `event` : contoh `CHANNEL_ON`, `CHANNEL_OFF`, `SCENE_CHANGED`
- `channel_id` : CH1 / CH2 (opsional kalau relevan)
- `actor` : SOURCE (USER_APP / DEVICE_LOCAL / SCHEDULE)
- `detail`
- `level` : info / warning / error

**Control Topic – contoh field:**
- `guid`
- `target` : CHANNEL / SCENE
- `channel_id` : CH1 / CH2 / ALL
- `command` : ON / OFF / TOGGLE / SET_SCENE
- `value` : optional extra (misal nama scene)
- `ts`

---

## 3. Environmental Sensor

### 3.1. Jumlah & Nama Topic

**Total minimal: 2 topic**

1. **Sensor Topic**
   - `environment.sensor`
   - Fungsi: kirim data kondisi lingkungan secara periodik.

2. **Log Topic (opsional tapi direkomendasikan)**
   - `environment.log`
   - Fungsi: catatan error sensor / restart / anomali.

### 3.2. Keywords / Payload Fields

**Sensor Topic – contoh field:**
- `guid`
- `ts`
- `temperature` : °C
- `humidity` : %
- `pressure` (opsional) : hPa
- `light` (opsional) : lux
- `air_quality` (opsional) : index / ppm
- `status` : NORMAL / WARNING / ERROR

**Log Topic – contoh field:**
- `guid`
- `ts`
- `event` : SENSOR_ERROR / SENSOR_OK / THRESHOLD_EXCEEDED
- `detail`
- `level` : info / warning / error

> Modul ini biasanya **tidak butuh control topic**, kecuali ada fitur ekstra (misal: control kipas/ventilasi). Kalau nanti ditambah, pakai pola `environment.control`.

---

## 4. Center of Gravity

### 4.1. Jumlah & Nama Topic

**Total minimal: 2 topic**

1. **Sensor Topic**
   - `cog.sensor`
   - Fungsi: mengirim data beban/berat + informasi stabilitas.

2. **Log Topic (opsional tapi bagus kalau ada)**
   - `cog.log`
   - Fungsi: mencatat event overload, reset, kalibrasi, dsb.

### 4.2. Keywords / Payload Fields

**Sensor Topic – contoh field:**
- `guid`
- `ts`
- `weight` : berat (kg / gram)
- `unit` : "kg" / "g"
- `is_overload` : true/false
- `calibrated` : true/false
- `raw_value` : nilai ADC (opsional)

**Log Topic – contoh field:**
- `guid`
- `ts`
- `event` : CALIBRATION_START / CALIBRATION_DONE / OVERLOAD / BACK_TO_NORMAL
- `detail`
- `level`

> Sama seperti Environment, modul ini **gak wajib** punya control topic kecuali mau support fitur seperti start/stop calibration dari app. Kalau iya, pakai `cog.control` dengan command `START_CALIBRATION`, `RESET_ZERO`, dll.

---

## 5. Smart Card Saga

### 5.1. Jumlah & Nama Topic

**Total minimal: 2 topic**  
Secara karakter, modul ini **event-based**, bukan streaming sensor.

1. **Event Topic (setara sensor)**
   - `smart_saga.event`
   - Fungsi: kirim event tap kartu, absensi, error kartu.

2. **Log Topic (opsional)**
   - `smart_saga.log`
   - Fungsi: catatan sistem (startup, koneksi ke server, error komunikasi).

3. **Control Topic (opsional)**  
   - `smart_saga.control`  
   - Fungsi: perintah dari app (misal update key, reset, mode demo).

### 5.2. Keywords / Payload Fields

**Event Topic – contoh field:**
- `guid`
- `ts`
- `rfid` : UID kartu
- `event` : TAP / ACCEPTED / REJECTED
- `reason` : contoh `NOT_REGISTERED`, `DOUBLE_TAP`, `OK`
- `student_id` (opsional) : NIS jika sudah di-resolve di device
- `direction` (opsional) : IN / OUT (kalau dipakai untuk gate)

**Log Topic – contoh field:**
- `guid`
- `ts`
- `event` : DEVICE_ONLINE / DEVICE_OFFLINE / SERVER_ERROR
- `detail`
- `level`

**Control Topic – contoh field (kalau dipakai):**
- `guid`
- `command` : SYNC_TIME / RESTART / UPDATE_KEY
- `payload` : object/teks tambahan
- `ts`

---

## 6. AntiGravity

### 6.1. Jumlah & Nama Topic

**Total minimal: 2 topic, ideal 3 topic**

1. **Sensor Topic**
   - `antigravity.sensor`
   - Fungsi: kirim data IMU (accelerometer, gyro, orientasi).

2. **Log Topic**
   - `antigravity.log`
   - Fungsi: event jatuh, tilt, vibrasi tinggi, error sensor.

3. **Control Topic (opsional)**
   - `antigravity.control`
   - Fungsi: kontrol alarm, mode operasi, atau kalibrasi.

### 6.2. Keywords / Payload Fields

**Sensor Topic – contoh field:**
- `guid`
- `ts`
- `accel` :
  - `x`, `y`, `z`
- `gyro` :
  - `x`, `y`, `z`
- `orientation` :
  - `pitch`, `roll`, `yaw`
- `status` : STABLE / UNSTABLE / FREE_FALL
- `battery` (opsional)
- `signal` (opsional)

**Log Topic – contoh field:**
- `guid`
- `ts`
- `event` : FREE_FALL / TILT_LEFT / TILT_RIGHT / HIGH_VIBRATION / BACK_TO_STABLE
- `detail`
- `level` : info / warning / error

**Control Topic – contoh field:**
- `guid`
- `command` : SET_MODE / ALARM_ON / ALARM_OFF / START_CALIBRATION
- `value` : isi perintah (misal: AUTO / MANUAL)
- `ts`

---

## 7. Rekap: Jumlah Topic per Modul

| Modul              | Sensor/Event Topic | Log Topic | Control Topic | Total Topic (ideal) |
|--------------------|--------------------|-----------|---------------|---------------------|
| Smart Watering     | 1                  | 1         | 1 (opsional)  | 2–3                 |
| Home Automation    | 1                  | 1         | 1             | 3                   |
| Environmental      | 1                  | 1 (ops.)  | 0–1           | 1–3                 |
| Center of Gravity  | 1                  | 1 (ops.)  | 0–1           | 1–3                 |
| Smart Card Saga    | 1 (event)          | 1 (ops.)  | 0–1 (ops.)    | 1–3                 |
| AntiGravity        | 1                  | 1         | 1 (ops.)      | 2–3                 |

> Catatan penting:  
> - Untuk **MVP praktikum**, biasanya cukup **2 topic** per modul: `sensor/event` + `log`.  
> - Kalau butuh interaksi dua arah (kontrol pompa, lampu, alarm, dsb.) baru aktifkan `control` topic.

---

## 8. Guideline Umum untuk AI Agent

Saat AI agent mengimplementasikan modul:
1. **Jangan ubah jumlah topic di luar spek ini** tanpa alasan kuat.
2. **Selalu bedakan**:
   - sensor/event = data utama
   - log = histori & debugging
   - control = perintah dari app
3. **Gunakan field `guid` di semua payload** untuk memastikan filtering per device.
4. **Tambahkan `ts` (timestamp)** supaya UI bisa sorting dan deteksi offline/timeout.
5. Kalau payload dari device tidak persis sama dengan contoh di atas,
   - jangan panik: buat lapisan mapping di sisi app (adapter) ke nama field standar.

