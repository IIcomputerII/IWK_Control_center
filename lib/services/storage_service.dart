import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  // Keys for stored credentials
  static const String _keyUser = 'broker_user';
  static const String _keyPassword = 'broker_password';
  static const String _keyHost = 'broker_host';
  static const String _keyVhost = 'broker_vhost';

  // Save credentials
  Future<void> saveCredentials({
    required String user,
    required String password,
    required String host,
    required String vhost,
  }) async {
    await Future.wait([
      _storage.write(key: _keyUser, value: user),
      _storage.write(key: _keyPassword, value: password),
      _storage.write(key: _keyHost, value: host),
      _storage.write(key: _keyVhost, value: vhost),
    ]);
  }

  // Load credentials
  Future<Map<String, String>?> loadCredentials() async {
    final user = await _storage.read(key: _keyUser);
    final password = await _storage.read(key: _keyPassword);
    final host = await _storage.read(key: _keyHost);
    final vhost = await _storage.read(key: _keyVhost);

    if (user != null && password != null && host != null && vhost != null) {
      return {'user': user, 'password': password, 'host': host, 'vhost': vhost};
    }
    return null;
  }

  // Clear credentials (for logout)
  Future<void> clearCredentials() async {
    await Future.wait([
      _storage.delete(key: _keyUser),
      _storage.delete(key: _keyPassword),
      _storage.delete(key: _keyHost),
      _storage.delete(key: _keyVhost),
    ]);
  }

  // Check if credentials exist
  Future<bool> hasCredentials() async {
    final user = await _storage.read(key: _keyUser);
    return user != null;
  }
}
