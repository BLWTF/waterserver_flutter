import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/authentication/exceptions.dart';
import 'package:waterserver/authentication/form/login_form.dart';
import 'package:waterserver/authentication/repository/authentication_repository.dart';
import 'package:waterserver/utilities/forms.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState());

  void usernameChanged(String value) {
    final username = Username.dirty(value);
    final newFormState = state.formState.copyWith(username: username);
    emit(state.copyWith(formState: newFormState, wrongUsernamePassword: false));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final newFormState = state.formState.copyWith(password: password);
    emit(state.copyWith(formState: newFormState, wrongUsernamePassword: false));
  }

  Future<void> submitted() async {
    final username = state.formState.username.value;
    final password = state.formState.password.value;

    emit(state.copyWith(loading: true));
    try {
      await _authenticationRepository.logIn(
        username: username,
        password: password,
      );
    } on WrongUsernamePassword catch (_) {
      emit(state.copyWith(wrongUsernamePassword: true));
    }

    emit(state.copyWith(loading: false));
  }
}
