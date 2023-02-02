import 'dart:async';
import 'package:crypt/crypt.dart';
import 'package:waterserver/database/repository/mysql_database_repository.dart';
import 'package:waterserver/user/repository/user_repository.dart';
import 'package:waterserver/user/user.dart';

import '../exceptions.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final UserRepository _userRepository;
  static const table = 'users';

  AuthenticationRepository({
    required MysqlDatabaseRepository mysqlDatabaseRepository,
    required UserRepository userRepository,
  })  : _mysqlDatabaseRepository = mysqlDatabaseRepository,
        _userRepository = userRepository;

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    final rows = await _mysqlDatabaseRepository.get(
      table: table,
      where: {'user_name': username},
      limit: 1,
    );

    if (rows.isEmpty) {
      throw WrongUsernamePassword();
    }

    final hashedPassword = rows.first['password'];

    final isPassword = Crypt(hashedPassword).match(password);

    if (isPassword) {
      await saveUser(User.fromFPMap(rows.first));
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      throw WrongUsernamePassword();
    }
  }

  Future<User?> getUser() async {
    return await _userRepository.getUser();
  }

  Future<void> saveUser(User user) async {
    await _userRepository.saveUser(user);
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
