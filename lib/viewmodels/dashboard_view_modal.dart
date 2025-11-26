import 'package:flutter/material.dart';
import 'package:iwk_control_center/model/data_model.dart';
import 'package:iwk_control_center/services/mqtt_sevice.dart';
import 'package:iwk_control_center/services/storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../app/app.router.dart';

class DashboardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _brokerService = locator<MQTTService>();
  final _storageService = locator<StorageService>();

  final List<IWKConfig> cardConfigs = [
    IWKConfig(
      name: 'Smart Watering',
      image: 'assets/water/water.png',
      primaryColor: Colors.green,
      backgroundColor: Colors.green.shade50,
      requiresGuid: true,
      route: Routes.waterPageView,
    ),
    IWKConfig(
      name: 'Smart Saga',
      image: 'assets/saga/RFIDkit.png',
      primaryColor: Colors.red,
      backgroundColor: Colors.red.shade50,
      requiresGuid: true,
      route: Routes.sagaPageView,
    ),
    IWKConfig(
      name: 'Environmental Sensor',
      image: 'assets/env/eskit.png',
      primaryColor: Colors.orange,
      backgroundColor: Colors.orange.shade50,
      requiresGuid: true,
      route: Routes.envPageView,
    ),
    IWKConfig(
      name: 'Center of Gravity',
      image: 'assets/gravity/cogkit.png',
      primaryColor: Colors.blue,
      backgroundColor: Colors.blue.shade50,
      requiresGuid: true,
      route: Routes.gravityView,
    ),
    IWKConfig(
      name: 'Home Automation',
      image: 'assets/home/homeautokit.png',
      primaryColor: Colors.cyan,
      backgroundColor: Colors.cyan.shade50,
      requiresGuid: true,
      route: Routes.homePageView,
    ),
  ];

  void selectModule(IWKConfig config) {
    if (config.requiresGuid) {
      _navigationService.navigateToUniqueCredentialView(config: config);
    } else {
      _navigationService.navigateTo(config.route);
    }
  }
  
  Future<void> logout() async {
    await _storageService.clearCredentials();
    await _brokerService.disconnect();
    await _navigationService.clearStackAndShow(Routes.loginView);
  }
}