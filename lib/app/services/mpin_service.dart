import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MpinService {
  final _storage = const FlutterSecureStorage();
  final _key = "mpin";

  Future<void> savePin(String pin) async {
    await _storage.write(key: _key, value: pin);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: _key);
  }

  Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }

  Future<bool> verifyPin(String input) async {
    final saved = await getPin();
    return saved == input;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _key);
  }
}