import 'package:flutter/foundation.dart';
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

  String _status = 'idle';
  String get status => _status;

  // Load saved credentials (populate only, NO auto-login)
  // User can freely change broker settings before clicking login
  Future<void> init() async {
    if (_isAutoLoginAttempted) return;
    _isAutoLoginAttempted = true;

    final credentials = await _storageService.loadCredentials();
    if (credentials != null) {
      // Populate controllers - user can modify before login
      userController.text = credentials['user']!;
      passwordController.text = credentials['password']!;
      hostController.text = credentials['host']!;
      vhostController.text = credentials['vhost']!;

      debugPrint('[LOGIN] 📋 Loaded saved credentials (no auto-login)');
    } else {
      debugPrint('[LOGIN] 📋 No saved credentials found');
    }
  }

  // Login with current broker settings (no validation)
  Future<void> login() async {
    setBusy(true);
    errorMessage = null;
    _status = 'connecting';
    notifyListeners();

    try {
      debugPrint('[LOGIN] 📡 Connecting to MQTT broker...');
      debugPrint('[LOGIN] Host: ${hostController.text}');
      debugPrint('[LOGIN] VHost: ${vhostController.text}');
      debugPrint('[LOGIN] User: ${userController.text}');

      await _brokerService.connect(
        host: hostController.text,
        user: userController.text,
        password: passwordController.text,
        vhost: vhostController.text,
      );
      debugPrint('[LOGIN] ✅ MQTT Connection successful!');

      // Save credentials on successful login
      debugPrint('[LOGIN] 💾 Saving credentials...');
      await _storageService.saveCredentials(
        user: userController.text,
        password: passwordController.text,
        host: hostController.text,
        vhost: vhostController.text,
      );
      debugPrint('[LOGIN] ✅ Credentials saved');

      // Navigate to Dashboard
      debugPrint('[LOGIN] 🚀 Navigating to Dashboard...');
      await _navigationService.replaceWith(Routes.dashboardView);
      debugPrint('[LOGIN] ✅ Navigation complete');

      _status = 'connected';
    } catch (e) {
      debugPrint('[LOGIN] ❌ ERROR: $e');
      errorMessage =
          'Connection failed: ${e.toString()}\n\nPlease check your broker settings.';

      _status = 'error';
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
