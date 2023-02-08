import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyRememberState = 'state';
//user
  static const _keyUserFirstname = 'firtsname';
  static const _keyUserLastname = 'lastename';
  static const _keyUserEmail = 'email';
  static const _keyUserOfficelocation = 'officelocation';
  static const _keyPriviledged = 'officelocation';

  static Future setRememberState(String state) async =>
      await _storage.write(key: _keyRememberState, value: state);

  static Future<String?> getRememberState() async =>
      await _storage.read(key: _keyRememberState);
  //user data

  static void setUserValues(dynamic apiUser, dynamic microsoftUser) {
    UserSecureStorage.setUserLastname(microsoftUser["givenName"]).toString();
    UserSecureStorage.setUserFirstname(microsoftUser["surname"].toString());
    UserSecureStorage.setUserEmail(microsoftUser["mail"].toString());
    UserSecureStorage.setUserOfficeLocation(
        microsoftUser["officeLocation"].toString());
    UserSecureStorage.setPrivileged(apiUser["privileged"].toString());
  }

  static Future<Map<String, dynamic>> getUserValues() async {
    var userEmail = await UserSecureStorage.getUserEmail();
    var userFirstname = await UserSecureStorage.getUserFirstname();
    var userLastname = await UserSecureStorage.getUserLastname();
    var userOfficeLocation = await UserSecureStorage.getUserOfficeLocatione();
    var privileged = await UserSecureStorage.getUserOfficeLocatione();

    return Map.of({
      "email": userEmail ?? '',
      "firstname": userFirstname ?? '',
      "lastname": userLastname ?? '',
      "officeLocation": userOfficeLocation ?? '',
      "privileged": (privileged == 'true') ? true : false
    });
  }

  static Future setUserLastname(String value) async =>
      await _storage.write(key: _keyUserLastname, value: value);

  static Future<String?> getUserLastname() async =>
      await _storage.read(key: _keyUserLastname);

  static Future setUserFirstname(String value) async =>
      await _storage.write(key: _keyUserFirstname, value: value);

  static Future<String?> getUserFirstname() async =>
      await _storage.read(key: _keyUserFirstname);

  static Future setUserEmail(String value) async =>
      await _storage.write(key: _keyUserEmail, value: value);

  static Future<String?> getUserEmail() async =>
      await _storage.read(key: _keyUserEmail);

  static Future setUserOfficeLocation(String value) async =>
      await _storage.write(key: _keyUserOfficelocation, value: value);

  static Future<String?> getUserOfficeLocatione() async =>
      await _storage.read(key: _keyUserOfficelocation);

  static Future setPrivileged(String value) async =>
      await _storage.write(key: _keyPriviledged, value: value);

  static Future<String?> getPrivileged() async =>
      await _storage.read(key: _keyPriviledged);
}
