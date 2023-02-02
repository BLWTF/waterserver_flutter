part of 'login_cubit.dart';

class LoginState extends Equatable {
  final LoginFormState formState;
  final bool wrongUsernamePassword;
  final bool loading;

  const LoginState({
    this.formState = const LoginFormState(
      username: Username.pure(),
      password: Password.pure(),
    ),
    this.wrongUsernamePassword = false,
    this.loading = false,
  });

  LoginState copyWith({
    LoginFormState? formState,
    bool? wrongUsernamePassword,
    bool? loading,
  }) =>
      LoginState(
        formState: formState ?? this.formState,
        wrongUsernamePassword:
            wrongUsernamePassword ?? this.wrongUsernamePassword,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [formState, wrongUsernamePassword, loading];
}
