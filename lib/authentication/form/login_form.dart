import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/utilities/forms.dart';

class LoginFormState extends Equatable with FormzMixin {
  final Username username;
  final Password password;

  const LoginFormState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    Username? username,
    Password? password,
  }) =>
      LoginFormState(
        username: username ?? this.username,
        password: password ?? this.password,
      );

  @override
  List<FormzInput> get inputs => [username, password];

  @override
  List<Object?> get props => inputs;
}
