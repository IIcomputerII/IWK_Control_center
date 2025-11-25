import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../app/app.router.dart';

class UniqueCredentialViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController guidController = TextEditingController();

  // Module Registry Configuration
  // Map<ModuleName, Map<ConfigKey, ConfigValue>>
  final Map<String, Map<String, dynamic>> _moduleRegistry = {
    'Smart Watering': {'requiresGuid': true, 'route': Routes.waterPageView},
    'Smart Saga': {'requiresGuid': false, 'route': Routes.sagaPageView},
    'Environmental Sensor': {'requiresGuid': true, 'route': Routes.envPageView},
    'Center of Gravity': {'requiresGuid': true, 'route': Routes.gravityView},
    'Home Automation': {'requiresGuid': true, 'route': Routes.homePageView},
    'AntiGravity': {
      'requiresGuid': true,
      'route': Routes.homePageView,
    }, // Assuming Home for now or new page
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
      guidController.text = result;
      notifyListeners();
    }
  }

  void submit(String iwkType) {
    final guid = guidController.text;

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
          _navigationService.navigateToWaterPageView(guid: guid);
          break;
        case 'Smart Saga':
          _navigationService.navigateToSagaPageView(guid: guid);
          break;
        case 'Environmental Sensor':
          _navigationService.navigateToEnvPageView(guid: guid);
          break;
        case 'Center of Gravity':
          _navigationService.navigateToGravityView(guid: guid);
          break;
        case 'Home Automation':
          _navigationService.navigateToHomePageView(guid: guid);
          break;
        default:
          // Fallback
          _navigationService.navigateToHomePageView(guid: guid);
      }
    }
  }
}
