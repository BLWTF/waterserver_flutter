import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user.dart';

class UserRepository {
  static const String storageKey = "__user_secure_key";
  final FlutterSecureStorage _secureStorage;

  UserRepository({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<User?> getUser() async {
    String? userJson = await _secureStorage.read(key: storageKey);
    if (userJson != null) {
      return User.fromMap(jsonDecode(userJson));
    }

    throw "No User Found";
  }

  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toMap());
    await _secureStorage.write(key: storageKey, value: userJson);
  }
}
