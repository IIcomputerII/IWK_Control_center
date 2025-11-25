import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../app/app.router.dart';

import 'dart:convert'; // Add this import

class UniqueCredentialViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController guidController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();

  // Module Registry Configuration
  // Map<ModuleName, Map<ConfigKey, ConfigValue>>
  final Map<String, Map<String, dynamic>> _moduleRegistry = {
    'Smart Watering': {'requiresGuid': true, 'route': Routes.waterPageView},
    'Smart Saga': {'requiresGuid': false, 'route': Routes.sagaPageView},
    'Environmental Sensor': {'requiresGuid': true, 'route': Routes.envPageView},
    'Center of Gravity': {'requiresGuid': true, 'route': Routes.gravityView},
    'Home Automation': {'requiresGuid': true, 'route': Routes.homePageView},
  };

  bool get requiresGuid =>
      _moduleRegistry[_currentIwkType]?['requiresGuid'] ?? true;
  String? _currentIwkType;

  void init(String iwkType) {
    _currentIwkType = iwkType;
    notifyListeners();
  }

  Future<void> scanQR() async {
    final result = await _navigationService.navigateTo('/qr-scanner');
    if (result != null && result is String) {
      handleQrResult(result);
    }
  }

  void handleQrResult(String result) {
    try {
      // Try to parse as JSON
      final Map<String, dynamic> jsonMap = jsonDecode(result);
      if (jsonMap.containsKey('guid')) {
        guidController.text = jsonMap['guid'];
      } else {
        // Fallback if JSON but no guid key (unlikely based on req, but safe)
        guidController.text = result;
      }
    } catch (e) {
      // Not JSON, use raw string
      guidController.text = result;
    }
    notifyListeners();
  }

  void submit(String iwkType) {
    final guid = guidController.text;
    final topic = keywordController.text;

    if (requiresGuid && guid.isEmpty) {
      // Show error (for now just return)
      return;
    }

    final route = _moduleRegistry[iwkType]?['route'];
    if (route != null) {
      // Navigate with arguments
      // Note: We need to ensure all target views accept these arguments
      // We are using the generated arguments classes which we updated earlier

      switch (iwkType) {
        case 'Smart Watering':
          _navigationService.navigateToWaterPageView(guid: guid, topic: topic);
          break;
        case 'Smart Saga':
          _navigationService.navigateToSagaPageView(guid: guid, topic: topic);
          break;
        case 'Environmental Sensor':
          _navigationService.navigateToEnvPageView(guid: guid, topic: topic);
          break;
        case 'Center of Gravity':
          _navigationService.navigateToGravityView(guid: guid, topic: topic);
          break;
        case 'Home Automation':
          _navigationService.navigateToHomePageView(guid: guid, topic: topic);
          break;
        default:
          // Fallback
          _navigationService.navigateToHomePageView(guid: guid, topic: topic);
      }
    }
  }
}
