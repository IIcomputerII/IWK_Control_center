import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../app/app.router.dart';
// NOTE: Assuming your data model path is correct
import 'package:iwk_control_center/model/data_model.dart'; 

class ChooseIwkViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  // 1. Define the full configuration data objects
  final List<IWKConfig> cardOptions = const [
    IWKConfig(
      name: 'Smart Watering',
      image: 'assets/water/water.png',
      primaryColor: Colors.blue,
      backgroundColor: Colors.blue,
      requiresGuid: true,
      route: Routes.waterPageView,
    ),
    IWKConfig(
      name: 'Smart Saga',
      image: 'assets/saga/RFIDkit.png',
      primaryColor: Colors.green,
      backgroundColor: Colors.green,
      requiresGuid: true,
      route: Routes.sagaPageView,
    ),
    IWKConfig(
      name: 'Environmental Sensor',
      image: 'assets/env/eskit.png',
      primaryColor: Colors.orange,
      backgroundColor: Colors.orange,
      requiresGuid: true,
      route: Routes.envPageView,
    ),
    IWKConfig(
      name: 'Center of Gravity',
      image: 'assets/gravity/cogkit.png',
      primaryColor: Colors.purple,
      backgroundColor: Colors.purple,
      requiresGuid: true,
      route: Routes.gravityView,
    ),
    IWKConfig(
      name: 'Home Automation',
      image: 'assets/home/homeautokit.png',
      primaryColor: Colors.red,
      backgroundColor: Colors.red,
      requiresGuid: true,
      route: Routes.homePageView,
    ),
  ];

  // 2. The selectOption method now accepts the full config object
  void selectOption(IWKConfig config) {
    if (config.requiresGuid) {
      // Pass the IWKConfig object as the 'config' argument
      _navigationService.navigateToUniqueCredentialView(config: config);
    } else {
      // Direct navigation for non-GUID modules (e.g., Smart Saga)
      _navigationService.navigateToSagaPageView(
        guid: null, 
        topic: null,
      );
    }
  }
}