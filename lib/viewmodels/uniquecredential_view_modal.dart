import 'package:flutter/material.dart';
import 'package:iwk_control_center/model/data_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../app/app.router.dart';

import 'dart:convert'; // Add this import

class UniqueCredentialViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController guidController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();

  IWKConfig? _config;
  bool get requiresGuid => _config?.requiresGuid ?? true;
  String get iwkType => _config?.name ?? 'Unknown Module';


  void init(IWKConfig config) {
    _config = config;
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
      final Map<String, dynamic> jsonMap = jsonDecode(result);
      if (jsonMap.containsKey('guid')) {
        guidController.text = jsonMap['guid'];
      } else {
        guidController.text = result;
      }
    } catch (e) {
      guidController.text = result;
    }
    notifyListeners();
  }

  void submit() { 
    final guid = guidController.text;
    final topic = keywordController.text;

    if (_config == null) return;

    if (requiresGuid && guid.isEmpty) {
      return;
    }

    final route = _config!.route;
    final iwkType = _config!.name; 

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
        _navigationService.navigateTo(route, arguments: {'guid': guid, 'topic': topic});
    }
  }
}