import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../services/mqtt_sevice.dart';
import '../services/storage_service.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _brokerService = locator<MQTTService>();
  final _storageService = locator<StorageService>();

  final TextEditingController userController = TextEditingController(
    text: 'trainerkit',
  );
  final TextEditingController passwordController = TextEditingController(
    text: '12345678',
  );
  final TextEditingController hostController = TextEditingController(
    text: 'iwkrmq.pptik.id',
  );
  final TextEditingController vhostController = TextEditingController(
    text: '/trainerkit',
  );

  String? errorMessage;
  bool _isAutoLoginAttempted = false;

  // Check for saved credentials and auto-login
  Future<void> init() async {
    if (_isAutoLoginAttempted) return;
    _isAutoLoginAttempted = true;

    final credentials = await _storageService.loadCredentials();
    if (credentials != null) {
      // Populate controllers
      userController.text = credentials['user']!;
      passwordController.text = credentials['password']!;
      hostController.text = credentials['host']!;
      vhostController.text = credentials['vhost']!;

      // Auto-login
      await login(autoLogin: true);
    }
  }

  Future<void> login({bool autoLogin = false}) async {
    setBusy(true);
    errorMessage = null;
    notifyListeners();

    try {
      await _brokerService.connect(
        host: hostController.text,
        user: userController.text,
        password: passwordController.text,
        vhost: vhostController.text,
      );

      // Save credentials on successful login
      await _storageService.saveCredentials(
        user: userController.text,
        password: passwordController.text,
        host: hostController.text,
        vhost: vhostController.text,
      );

      // Navigate to List Modul (Dashboard) on success
      await _navigationService.replaceWith(Routes.dashboardView);
    } catch (e) {
      errorMessage = e.toString();

      // If auto-login fails, clear saved credentials
      if (autoLogin) {
        await _storageService.clearCredentials();
      }

      notifyListeners();
    } finally {
      setBusy(false);
    }
  }

  Future<void> logout() async {
    await _storageService.clearCredentials();
    await _brokerService.disconnect();
    await _navigationService.clearStackAndShow(Routes.loginView);
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    hostController.dispose();
    vhostController.dispose();
    super.dispose();
  }
}
