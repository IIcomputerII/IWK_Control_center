import 'dart:convert';
import 'package:flutter/foundation.dart';

// Water Module Data Model
class WaterData {
  final String date;
  final String clock;
  final String statusPompa;
  final String statusSoil;
  final String kelembaban;
  final String deviceId;
  final String guid;

  WaterData({
    required this.date,
    required this.clock,
    required this.statusPompa,
    required this.statusSoil,
    required this.kelembaban,
    required this.deviceId,
    required this.guid,
  });

  factory WaterData.fromJson(Map<String, dynamic> json) {
    return WaterData(
      date: json['date'] ?? json['tanggal'] ?? '',
      clock: json['clock'] ?? json['jam'] ?? '',
      statusPompa: json['status_pompa'] ?? json['pompa'] ?? 'OFF',
      statusSoil: json['status_soil'] ?? json['soil'] ?? 'Dry',
      kelembaban: (json['kelembaban'] ?? json['humidity'] ?? '0').toString(),
      deviceId: json['device_id'] ?? json['mac'] ?? '',
      guid: json['guid'] ?? '',
    );
  }

  static WaterData? tryParse(String payload, String? filterGuid) {
    try {
      // Check if payload is in GUID#Value format (e.g., "guid#752")
      // Reference: GravityData implementation
      if (payload.contains('#')) {
        final parts = payload.split('#');
        if (parts.length >= 2) {
          final guid = parts[0].trim();
          final value = parts[1].trim();

          // Filter by GUID if provided
          if (filterGuid != null && filterGuid.isNotEmpty) {
            if (guid != filterGuid) {
              return null;
            }
          }

          // Create WaterData with current timestamp
          final now = DateTime.now();

          // Logic for status based on value
          // Value > 700 means Dry (Kering) -> Pump ON
          // Value <= 700 means Wet (Basah) -> Pump OFF
          String statusSoil = 'Unknown';
          String statusPompa = 'OFF';

          try {
            final intVal = int.parse(value);
            if (intVal > 700) {
              statusSoil = 'Kering';
              statusPompa = 'ON';
            } else {
              statusSoil = 'Basah';
              statusPompa = 'OFF';
            }
          } catch (e) {
            debugPrint('[WaterData] Error parsing value to int: $e');
          }

          return WaterData(
            date: '${now.day}/${now.month}/${now.year}',
            clock:
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
            statusPompa: statusPompa,
            statusSoil: statusSoil,
            kelembaban: '$value RH',
            deviceId: guid.length >= 8 ? guid.substring(0, 8) : guid,
            guid: guid,
          );
        }
      }

      // Fallback: Try JSON parsing
      if (payload.trim().startsWith('{')) {
        final Map<String, dynamic> data = jsonDecode(payload);
        final waterData = WaterData.fromJson(data);

        // Filter by GUID if provided
        if (filterGuid != null && filterGuid.isNotEmpty) {
          if (waterData.guid != filterGuid) {
            return null; // Not matching GUID
          }
        }

        return waterData;
      }

      return null;
    } catch (e) {
      debugPrint('[WaterData] Parse error: $e');
      return null;
    }
  }
}

// Environmental Module Data Model
class EnvData {
  final String date;
  final String clock;
  final String cuaca;
  final String temperature;
  final String deviceId;
  final String guid;

  EnvData({
    required this.date,
    required this.clock,
    required this.cuaca,
    required this.temperature,
    required this.deviceId,
    required this.guid,
  });

  factory EnvData.fromJson(Map<String, dynamic> json) {
    return EnvData(
      date: json['date'] ?? json['tanggal'] ?? '',
      clock: json['clock'] ?? json['jam'] ?? '',
      cuaca: json['cuaca'] ?? json['weather'] ?? 'Cloudy',
      temperature: (json['temperature'] ?? json['temp'] ?? '0').toString(),
      deviceId: json['device_id'] ?? json['mac'] ?? '',
      guid: json['guid'] ?? '',
    );
  }

  static EnvData? tryParse(String payload, String? filterGuid) {
    try {
      // Check if payload is in GUID#Value format (e.g., "guid#26.20")
      if (payload.contains('#')) {
        final parts = payload.split('#');
        if (parts.length >= 2) {
          final guid = parts[0].trim();
          final temperature = parts[1].trim();

          // Filter by GUID if provided
          if (filterGuid != null && filterGuid.isNotEmpty) {
            if (guid != filterGuid) {
              return null;
            }
          }

          // Create EnvData with current timestamp
          final now = DateTime.now();

          // Determine weather status based on temperature
          String cuaca = 'Cloudy';
          try {
            final temp = double.parse(temperature);
            if (temp > 30) {
              cuaca = 'Hot';
            } else if (temp < 20) {
              cuaca = 'Cold';
            } else {
              cuaca = 'Normal';
            }
          } catch (e) {
            debugPrint('[EnvData] Error parsing temperature: $e');
          }

          return EnvData(
            date: '${now.day}/${now.month}/${now.year}',
            clock:
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
            cuaca: cuaca,
            temperature: '$temperature °C',
            deviceId: guid.length >= 8 ? guid.substring(0, 8) : guid,
            guid: guid,
          );
        }
      }

      // Fallback: Try JSON parsing
      if (payload.trim().startsWith('{')) {
        final Map<String, dynamic> data = jsonDecode(payload);
        final envData = EnvData.fromJson(data);

        // Filter by GUID if provided
        if (filterGuid != null && filterGuid.isNotEmpty) {
          if (envData.guid != filterGuid) {
            return null; // Not matching GUID
          }
        }

        return envData;
      }

      return null;
    } catch (e) {
      debugPrint('[EnvData] Parse error: $e');
      return null;
    }
  }
}

// Gravity Module Data Model
class GravityData {
  final String date;
  final String clock;
  final String weight;
  final String deviceId;
  final String guid;

  GravityData({
    required this.date,
    required this.clock,
    required this.weight,
    required this.deviceId,
    required this.guid,
  });

  factory GravityData.fromJson(Map<String, dynamic> json) {
    return GravityData(
      date: json['date'] ?? json['tanggal'] ?? '',
      clock: json['clock'] ?? json['jam'] ?? '',
      weight: (json['weight'] ?? json['berat'] ?? '0').toString(),
      deviceId: json['device_id'] ?? json['mac'] ?? '',
      guid: json['guid'] ?? '',
    );
  }

  static GravityData? tryParse(String payload, String? filterGuid) {
    try {
      // Check if payload is in GUID#Weight format (e.g., "ae4fc711#0.01")
      if (payload.contains('#')) {
        final parts = payload.split('#');
        if (parts.length >= 2) {
          final guid = parts[0].trim();
          final weight = parts[1].trim();

          // Filter by GUID if provided
          if (filterGuid != null && filterGuid.isNotEmpty) {
            if (guid != filterGuid) {
              return null;
            }
          }

          // Create GravityData with current timestamp
          final now = DateTime.now();
          return GravityData(
            date: '${now.day}/${now.month}/${now.year}',
            clock:
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
            weight: weight,
            deviceId: guid.length >= 8 ? guid.substring(0, 8) : guid,
            guid: guid,
          );
        }
      }

      // Fallback: Try JSON parsing
      if (payload.trim().startsWith('{')) {
        final Map<String, dynamic> data = jsonDecode(payload);
        final gravityData = GravityData.fromJson(data);

        // Filter by GUID if provided
        if (filterGuid != null && filterGuid.isNotEmpty) {
          if (gravityData.guid != filterGuid) {
            return null;
          }
        }

        return gravityData;
      }

      return null;
    } catch (e) {
      debugPrint('[GravityData] Parse error: $e');
      return null;
    }
  }
}

// Home Automation Module Data Model
// Format: GUID#Voltage#Current#Power#Energy#Frequency#PF
class HomeData {
  final String date;
  final String clock;
  final String voltage;
  final String current;
  final String power;
  final String energy;
  final String frequency;
  final String powerFactor;
  final String statusSaklar;
  final String statusSteker;
  final String deviceId;
  final String guid;

  HomeData({
    required this.date,
    required this.clock,
    required this.voltage,
    required this.current,
    required this.power,
    required this.energy,
    required this.frequency,
    required this.powerFactor,
    required this.statusSaklar,
    required this.statusSteker,
    required this.deviceId,
    required this.guid,
  });

  factory HomeData.fromHashString(String hashString) {
    final parts = hashString.split('#');
    if (parts.length < 7) {
      throw FormatException(
        'Invalid format. Expected: GUID#V#C#P#E#F#PF, got: $hashString',
      );
    }

    String cleanValue(String val) {
      final trimmed = val.trim();
      if (trimmed.toLowerCase() == 'nan') return '0.00';
      return trimmed;
    }

    final now = DateTime.now();
    return HomeData(
      date: '${now.day}/${now.month}/${now.year}',
      clock: '${now.hour}:${now.minute}:${now.second}',
      guid: parts[0].trim(),
      voltage: cleanValue(parts[1]),
      current: cleanValue(parts[2]),
      power: cleanValue(parts[3]),
      energy: cleanValue(parts[4]),
      frequency: cleanValue(parts[5]),
      powerFactor: parts.length > 6 ? cleanValue(parts[6]) : '0.00',
      statusSaklar: '0',
      statusSteker: '0',
      deviceId: parts[0].trim(),
    );
  }

  static Map<String, String> parseControlStatus(String controlString) {
    final parts = controlString.split('#');
    if (parts.length < 2) {
      return {'saklar': '1', 'steker': '1'};
    }

    final status = parts[1].trim();
    return {
      'guid': parts[0].trim(),
      'saklar': status.length > 0 ? status[0] : '1',
      'steker': status.length > 1 ? status[1] : '1',
    };
  }

  static HomeData? tryParse(String payload, String? filterGuid) {
    try {
      if (payload.contains('#') && payload.split('#').length == 2) {
        return null; // Control status handled separately
      }

      final homeData = HomeData.fromHashString(payload);

      if (filterGuid != null && filterGuid.isNotEmpty) {
        if (homeData.guid != filterGuid) {
          return null;
        }
      }

      return homeData;
    } catch (e) {
      debugPrint('[HomeData] Parse error: $e');
      return null;
    }
  }

  HomeData copyWith({String? statusSaklar, String? statusSteker}) {
    return HomeData(
      date: date,
      clock: clock,
      voltage: voltage,
      current: current,
      power: power,
      energy: energy,
      frequency: frequency,
      powerFactor: powerFactor,
      statusSaklar: statusSaklar ?? this.statusSaklar,
      statusSteker: statusSteker ?? this.statusSteker,
      deviceId: deviceId,
      guid: guid,
    );
  }
}
