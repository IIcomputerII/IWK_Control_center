import 'package:flutter/material.dart';
import 'package:iwk_control_center/model/data_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:convert';
import '../app/app.locator.dart';
import '../app/app.router.dart';

class UniqueCredentialViewModel extends BaseViewModel {
  final _nav = locator<NavigationService>();

  final guidController = TextEditingController();
  final keywordController = TextEditingController();

  // Controllers untuk Home Automation
  final queueTopic1 = TextEditingController();
  final queueTopic2 = TextEditingController();
  final saklarGuid = TextEditingController();
  final saklarName = TextEditingController(); // Changed from saklarTopic
  final stekerGuid = TextEditingController();
  final stekerName = TextEditingController(); // Changed from stekerTopic
  final meterGuid = TextEditingController();
  final meterName = TextEditingController(); // Changed from meterTopic

  IWKConfig? _currentConfig;

  bool get needsGuid => _currentConfig?.requiresGuid ?? true;
  String get moduleName => _currentConfig?.name ?? 'Unknown';

  void init(IWKConfig config) {
    _currentConfig = config;
    notifyListeners();
  }

  // Parse QR code result - support JSON atau plain text
  void handleQrScan(String scanResult) {
    if (scanResult.isEmpty) return;

    try {
      // Coba parse sebagai JSON dulu
      final data = jsonDecode(scanResult) as Map<String, dynamic>;
      _fillFromJson(data);
    } catch (_) {
      // Kalau bukan JSON, treat sebagai plain GUID
      guidController.text = scanResult;
    }

    notifyListeners();
  }

  // Fill controllers dari JSON data
  void _fillFromJson(Map<String, dynamic> data) {
    if (moduleName == 'Home Automation') {
      // Home automation: semua device pakai GUID yang sama
      final sharedGuid = data['guid'] ?? '';
      final deviceName = data['name'] ?? ''; // Ambil name dari JSON

      // Fill GUID untuk semua device
      saklarGuid.text = sharedGuid;
      stekerGuid.text = sharedGuid;
      meterGuid.text = sharedGuid;

      // Fill Name untuk semua device
      saklarName.text = deviceName;
      stekerName.text = deviceName;
      meterName.text = deviceName;

      // Queue topics (kalau ada di JSON)
      queueTopic1.text = data['queue_topic_1'] ?? '';
      queueTopic2.text = data['queue_topic_2'] ?? '';

      // Set keyword controller untuk compatibility
      keywordController.text = deviceName;
    } else {
      // Module lain cuma butuh GUID dan topic/keyword
      guidController.text = data['guid'] ?? data['id'] ?? '';
      keywordController.text = data['topic'] ?? data['keyword'] ?? '';
    }
  }

  // Navigate ke halaman module setelah submit
  void submitAndNavigate() {
    if (_currentConfig == null) return;

    String guid = '';
    String topic = '';

    // Untuk Home Automation, ambil dari saklarGuid (semua device share GUID yang sama)
    if (moduleName == 'Home Automation') {
      guid = saklarGuid.text.trim();
      topic = saklarName.text.trim();
    } else {
      guid = guidController.text.trim();
      topic = keywordController.text.trim();
    }

    // Validasi - kalau butuh GUID tapi kosong, jangan navigate
    if (needsGuid && guid.isEmpty) {
      debugPrint('❌ Navigation blocked: GUID is empty');
      return;
    }

    debugPrint('✅ Navigating to $moduleName with GUID: $guid, Topic: $topic');

    // Navigate berdasarkan module type
    switch (moduleName) {
      case 'Smart Watering':
        _nav.navigateToWaterPageView(guid: guid, topic: topic);
        break;
      case 'Smart Saga':
        _nav.navigateToSagaPageView(guid: guid, topic: topic);
        break;
      case 'Environmental Sensor':
        _nav.navigateToEnvPageView(guid: guid, topic: topic);
        break;
      case 'Center of Gravity':
        _nav.navigateToGravityView(guid: guid, topic: topic);
        break;
      case 'Home Automation':
        _nav.navigateToHomePageView(guid: guid, topic: topic);
        break;
      default:
        // Fallback untuk module yang belum ada routing khusus
        if (_currentConfig!.route.isNotEmpty) {
          _nav.navigateTo(
            _currentConfig!.route,
            arguments: {'guid': guid, 'topic': topic},
          );
        }
    }
  }

  @override
  void dispose() {
    // Cleanup semua controllers biar ga memory leak
    guidController.dispose();
    keywordController.dispose();
    queueTopic1.dispose();
    queueTopic2.dispose();
    saklarGuid.dispose();
    saklarName.dispose();
    stekerGuid.dispose();
    stekerName.dispose();
    meterGuid.dispose();
    meterName.dispose();
    super.dispose();
  }
}
