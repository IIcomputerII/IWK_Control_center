import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../app/app.router.dart';

class DashboardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final List<String> modules = [
    'Smart Watering',
    'Smart Saga',
    'Environmental Sensor',
    'Center of Gravity',
    'Home Automation',
  ];

  // Module registry to determine GUID requirements
  final Map<String, Map<String, dynamic>> _moduleRegistry = {
    'Smart Watering': {'requiresGuid': true, 'route': Routes.waterPageView},
    'Smart Saga': {'requiresGuid': false, 'route': Routes.sagaPageView},
    'Environmental Sensor': {'requiresGuid': true, 'route': Routes.envPageView},
    'Center of Gravity': {'requiresGuid': true, 'route': Routes.gravityView},
    'Home Automation': {'requiresGuid': true, 'route': Routes.homePageView},
  };

  void selectModule(String moduleName) {
    final moduleConfig = _moduleRegistry[moduleName];
    if (moduleConfig == null) return;

    final requiresGuid = moduleConfig['requiresGuid'] as bool;

    if (requiresGuid) {
      // Navigate to GUID input screen
      _navigationService.navigateToUniqueCredentialView(iwkType: moduleName);
    } else {
      // Navigate directly to module page (e.g., SAGA)
      switch (moduleName) {
        case 'Smart Saga':
          _navigationService.navigateToSagaPageView(guid: null);
          break;
        default:
          // Fallback to GUID screen if no direct navigation defined
          _navigationService.navigateToUniqueCredentialView(
            iwkType: moduleName,
          );
      }
    }
  }
}
