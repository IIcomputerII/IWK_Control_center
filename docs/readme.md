- Saat app dibuka: langsung layar login kredensial broker aja.
- Setelah broker connected baru masuk list modul.
- Subscribe/topic/queue baru jalan setelah user pilih modul.
- GUID baru diminta di dalam modul yang butuh.

Gw tulis urut dari nol sampai selesai, termasuk state internal, siapa ngapain, dan edge case.

flutter emulators --launch Medium_Phone_API_36.1

---

## Alur besar (peta jalannya dulu biar kebayang)

Urutan layar sekarang:

1. App Launch / Splash
2. Login Credential Broker
3. List Modul
4. Modul Screen

   - kalau butuh GUID: GUID step dulu
   - lalu dashboard data + log + control (opsional)

5. Balik ke List Modul (pindah modul)
6. Logout (opsional) → balik ke Login Broker

Hal penting:

- Koneksi broker cuma 1 kali di awal (global session).
- Modul cuma subscribe/unsubscribe pakai session itu.
- Tidak ada isi queue/topic manual di login awal.

---

## 0. Kondisi awal sebelum user ngapa-ngapain

Di app ada 2 kemungkinan kondisi:

A. First install / belum pernah login

- brokerSession belum ada
- credential kosong
- langsung tampil form login.

B. Pernah login sebelumnya

- app punya credential tersimpan lokal (kalau fitur ini kamu aktifin)
- saat launch, app auto-fill form (bukan auto-connect dulu, kecuali kamu mau)
- user tinggal klik Login.

State internal awal:

- brokerState = idle
- selectedModule = null
- activeGuid = null
- activeSubscriptions = kosong

---

## 1. App dibuka → tampil Login Credential Broker

Yang tampil di layar ini (sesuai foto contoh kamu):

- User
- Password
- Host
- Virtual Host
- tombol Login

Yang sengaja tidak ada di sini:

- Queue
- Topic
- GUID KIT
- Tombol control modul

Kenapa:

- Karena ini login broker global buat semua modul.
- Queue/topic beda per modul, jadi belum relevan sekarang.
- GUID itu identitas device per modul, juga belum relevan.

Flow user:

1. User isi:

   - User = trainerkit
   - Password = 12345678
   - Host = iwkrmq.pptik.id
   - Virtual Host = /trainerkit

2. Klik Login.

Flow sistem (MVVM):

1. LoginScreen kirim data ke MainAppVM/AppSessionVM:

   - setCredential(credentialModel)

2. MainAppVM ubah brokerState:

   - idle → connecting

3. MainAppVM panggil MessageBrokerService.connect(credential).

MessageBrokerService melakukan:

- buka koneksi ke broker (TCP/WebSocket tergantung implement kamu)
- autentikasi user/pass
- join vhost (/trainerkit)
- hasilnya salah satu:

  - success
  - error (auth gagal / host unreachable / timeout / vhost invalid)

---

## 2. Jika login broker sukses

Flow sistem:

1. MessageBrokerService balikin callback success.
2. MainAppVM set brokerState:

   - connecting → connected

3. MainAppVM simpan credential:

   - minimal di memory session
   - optional: local storage biar auto-fill next time

Flow UI:

- LoginScreen pindah ke ListModulScreen.

State internal setelah sukses:

- brokerState = connected
- credentialModel = terset (trainerkit stack)
- selectedModule = null
- activeSubscriptions = kosong
- activeGuid = null

Catatan:

- Sampai titik ini, app belum subscribe apa pun.
- App cuma punya “pintu ke broker”.

---

## 3. Jika login broker gagal

Flow sistem:

1. MessageBrokerService balikin error.
2. MainAppVM set brokerState:

   - connecting → error

3. Error reason dikasih ke UI.

Flow UI:

- LoginScreen tetap di tempat, tampil pesan:

  - auth failed (user/pass salah)
  - cannot reach host (internet/wifi)
  - vhost not found
  - timeout

User bisa:

- benerin field
- klik Login lagi

State internal:

- brokerState = error
- credentialModel masih ada tapi belum valid

---

## 4. Masuk List Modul (setelah broker connected)

Begitu login berhasil, layar list modul muncul.

Flow user:

1. User lihat list modul:

   - Smart Watering
   - Home Automation
   - Environmental Sensor
   - Center of Gravity
   - Smart Saga
   - AntiGravity

2. User pilih salah satu modul.

Flow sistem:

1. ListModulScreen kirim event ke MainAppVM:

   - selectModule(moduleId)

2. MainAppVM:

   - set selectedModule = moduleId
   - load config dari Module Registry:

     - requiresGuid (true/false)
     - defaultQueues/topics
     - supportsControl (true/false)

3. MainAppVM bikin/ambil instance ModulVM terkait:

   - misal AntiGravityVM / EnvSensorVM / dll

State internal sekarang:

- brokerState = connected
- selectedModule = “misal ANTIGRAVITY”
- activeSubscriptions masih kosong
- activeGuid masih null

---

## 5. Masuk modul → langkah GUID (kalau modul butuh)

Ada dua cabang:

### Cabang A: modul requiresGuid = true

Contoh: AntiGravity, Smart Watering, Home Auto, Env Sensor, COG, Saga (legacy kamu mayoritas butuh GUID).

Flow UI:

1. App munculin GuidScreen khusus modul itu.
2. Ada opsi:
   - Scan QR
   - Input manual GUID

Flow user:

1. User scan QR di device → GUID kebaca.
   atau
2. User input manual → klik confirm.

Flow sistem:

1. GuidScreen kirim GUID ke ModulVM:

   - ModulVM.setGuid(guid)

2. ModulVM / MainAppVM validasi:

   - GUID tidak kosong
   - format oke

3. Kalau valid → lanjut ke subscribe.
4. Kalau invalid → UI error dan stay di GuidScreen.

State internal setelah valid:

- activeGuid = guid
- selectedModule tetap
- brokerState connected

### Cabang B: modul requiresGuid = false

Kalau suatu saat ada modul yang gak butuh GUID:

- GuidScreen di-skip
- langsung subscribe queue modul.

---

## 6. Subscribe queue/topic baru jalan SEKARANG

Ini inti revisi kamu.

Begitu GUID siap (atau modul gak butuh GUID):

Flow sistem:

1. MainAppVM manggil ModulVM.initModule():

   - parameter GUID kalau perlu

2. ModulVM ambil queue/topic dari Module Registry:

   - sensorQueue
   - logQueue
   - controlQueue (jika supportsControl)

3. ModulVM panggil MessageBrokerService.subscribe(sensorQueue)
4. ModulVM panggil MessageBrokerService.subscribe(logQueue)

Kalau subscribe sukses semua:

- ModulVM set moduleState = listening
- UI pindah ke DashboardScreen modul.

Kalau subscribe gagal salah satu:

- ModulVM set moduleState = subscribeError
- UI tampil error:

  - “Queue tidak ditemukan”
  - “Tidak punya akses”

- UI kasih pilihan:

  - Retry subscribe
  - Back ke List Modul

State internal setelah subscribe sukses:

- activeSubscriptions = [sensorQueue, logQueue]
- moduleState = listening
- activeGuid = guid (jika ada)

---

## 7. Streaming data real-time di Dashboard modul

Loop ini jalan terus selama:

- brokerState = connected
- moduleState = listening
- device online dan publish data

Flow data:

1. Device publish payload sensor ke sensorQueue.
2. Broker forward payload ke app subscriber.
3. MessageBrokerService terima raw JSON.
4. Service lempar ke callback ModulVM.onSensorMessage(raw).
5. ModulVM:

   - cek guid cocok (kalau payload bawa guid)
   - parse ke SensorData_Modul
   - update reactive state

Flow UI:

- DashboardScreen observe state ModulVM.
- Tiap state update → angka sensor/indikator berubah realtime.

Hal yang tampil di Dashboard (umum):

- status broker connected/offline
- status device online/offline
- last update time
- card sensor realtime
- log feed realtime

---

## 8. Log/event flow di Dashboard

Mirip sensor, tapi queue berbeda:

1. Device publish log/event ke logQueue.
2. Broker forward ke app.
3. MessageBrokerService → ModulVM.onLogMessage(raw).
4. ModulVM parse ke LogData_Modul.
5. UI append ke list log (terbaru di atas).

Catatan khusus Smart Saga:

- sifat data event-based (tap RFID), jadi log feed bakal jadi komponen utama.
- sensor card bisa minimal.

---

## 9. Control flow (kalau modul supportsControl = true)

Kalau modul punya fitur kontrol:

Flow user:

1. User tekan tombol/switch control di Dashboard.

Flow sistem:

1. DashboardScreen kirim event ke ModulVM.publishControl(command).
2. ModulVM bikin payload command:

   - guid target
   - command type
   - value
   - ts

3. ModulVM panggil MessageBrokerService.publish(controlQueue, payload).
4. Broker forward ke device.
5. Device eksekusi kontrol.
6. Device optional publish ack ke logQueue.
7. App nerima ack → log muncul.

Guardrail wajib:

- kalau device offline / guid null → tombol control disabled.
- kalau publish gagal → UI toast “control gagal terkirim”.

---

## 10. Balik ke List Modul / pindah modul

Flow user:

1. User klik Back.

Flow sistem:

1. DashboardScreen notify MainAppVM “leave module”.
2. MainAppVM perintah ModulVM.cleanup():

   - unsubscribe sensorQueue
   - unsubscribe logQueue
   - stop listeners / timers modul

3. MainAppVM set:

   - activeSubscriptions = kosong
   - activeGuid = null (reset untuk modul berikutnya)

4. selectedModule bisa direset atau tetap (tergantung UI kamu).

Flow UI:

- balik ke List Modul.

Catatan:

- brokerState tetap connected
- jadi pindah modul gak perlu login ulang.

---

## 11. Reconnect & error handling (detail, biar gak ngambek)

Ada 3 jenis error utama:

### A. Broker disconnect mendadak

Contoh: internet user putus, broker down.

Flow:

1. MessageBrokerService detect socket closed.
2. Callback ke MainAppVM.
3. MainAppVM set brokerState:

   - connected → reconnecting

4. UI global (di modul mana pun) tampil “Reconnecting…”

Auto-reconnect loop:

- coba connect ulang dengan credential terakhir
- backoff delay:

  - retry 1: 2 detik
  - retry 2: 5 detik
  - retry 3: 10 detik
  - dst

- kalau sukses:

  - brokerState → connected
  - MainAppVM suruh modul aktif resubscribe otomatis
  - UI normal lagi

- kalau terus gagal:

  - brokerState → error
  - UI kasih opsi:

    - retry manual
    - logout → balik login screen

### B. Device offline tapi broker aman

Tanda:

- broker connected
- subscribe sukses
- tapi ga ada data masuk lama

Flow:

1. ModulVM simpan lastUpdate tiap message masuk.
2. kalau lastUpdate lewat threshold (misal 15-30 detik):

   - moduleState = deviceOffline

3. UI badge “Device offline / no data”.

Kalau data masuk lagi:

- moduleState kembali listening.

### C. Queue/topic salah atau tidak ada

Tanda:

- subscribe error di step 6

Flow:

1. ModulVM tandai subscribeError.
2. UI tampil error jelas.
3. User bisa:

   - retry (kalau cuma bug sementara)
   - balik list modul (kalau mapping queue salah dan perlu revisi registry)

---

## 12. Logout broker (opsional, tapi recommended)

Kalau kamu tambahin tombol Logout di List Modul (atau menu):

Flow user:

1. User klik Logout.

Flow sistem:

1. MainAppVM panggil MessageBrokerService.disconnect().
2. unsub semua activeSubscriptions (kalau masih ada).
3. clear session:

   - brokerState → disconnected
   - selectedModule → null
   - activeGuid → null

4. optional: clear credential lokal (kalau user mau fresh).

Flow UI:

- balik ke Login Credential Broker.

---

## 13. Ringkasan state machine (biar agent kamu ngerti)

Broker state:

- idle
- connecting
- connected
- reconnecting
- error
- disconnected

Module state (per modul):

- idle
- waitingGuid (kalau butuh)
- subscribing
- listening
- deviceOffline
- subscribeError

Transisi penting:

- app launch → broker idle
- login klik → connecting
- connect sukses → connected
- pilih modul → module idle
- butuh guid → waitingGuid
- guid valid → subscribing → listening
- back → cleanup → module idle
- broker putus → reconnecting → connected/error

---

## 14. Kenapa desain ini enak

- UX lebih bersih:
  - user cuma mikirin broker dulu, baru modul.
- Core gak perlu tau queue di awal.
- Modul jadi plug-and-play:
  - pindah modul tinggal unsubscribe/subscribe.
- Satu koneksi broker = hemat resource dan lebih stabil.
