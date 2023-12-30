import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptManager {
  final Key _key;
  final IV _iv;

  EncryptManager._internal()
      : _key = Key.fromUtf8('nostr_util_project_flutter_apps.'),
        _iv = IV.fromLength(16);

  static final EncryptManager _instance = EncryptManager._internal();
  factory EncryptManager() {
    return _instance;
  }

  Future<void> saveItem(String itemName, String itemValue) async {
    if (itemValue.isEmpty) return;
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(itemValue, iv: _iv);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(itemName, encrypted.base64);
  }

  Future<String?> getItem(String itemName) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedData = prefs.getString(itemName);

    if (encryptedData != null) {
      final encrypter = Encrypter(AES(_key));
      final decrypted =
          encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: _iv);
      return decrypted;
    }
    return null;
  }

  Future<void> deleteItem(String itemName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(itemName);
  }
}
