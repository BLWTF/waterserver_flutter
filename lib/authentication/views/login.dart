import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/authentication/cubit/login_cubit.dart';
import 'package:waterserver/authentication/repository/authentication_repository.dart';
import 'package:waterserver/utilities/forms.dart';
import 'package:waterserver/widgets/window_buttons.dart';
import 'package:window_manager/window_manager.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: const DragToMoveArea(
          child: Align(
            alignment: AlignmentDirectional.center,
            child: Text("Login"),
          ),
        ),
        leading: const Icon(FluentIcons.home),
        actions: Row(
          children: const [
            Spacer(),
            WindowButtons(),
          ],
        ),
      ),
      content: BlocProvider(
        create: (_) => LoginCubit(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context)),
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.all(200),
      content: Center(
        child: Builder(builder: (context) {
          final formState =
              context.select((LoginCubit cubit) => cubit.state.formState);
          final wrongUsernamePassword = context
              .select((LoginCubit cubit) => cubit.state.wrongUsernamePassword);
          return Column(
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 200),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: wrongUsernamePassword,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Wrong username and password combination!",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              color: Color(0xFFFF0000),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormBox(
                              header: "Username:",
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .usernameChanged(value),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (_) {
                                if (formState.username.invalid) {
                                  switch (formState.username.error) {
                                    case UsernameValidationError.empty:
                                    case UsernameValidationError.invalid:
                                      return "Provide a valid username";
                                    case UsernameValidationError.taken:
                                      return "Username has been taken";
                                    case null:
                                      return null;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormBox(
                              header: "Password:",
                              obscureText: true,
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .passwordChanged(value),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (_) {
                                if (formState.password.invalid) {
                                  switch (formState.password.error) {
                                    case PasswordValidationError.empty:
                                    case PasswordValidationError.invalid:
                                      return "Provide a password";
                                    case PasswordValidationError.limitExceeded:
                                      return "Password too short";
                                    case null:
                                      return null;
                                  }
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Builder(builder: (context) {
                        final loading = context
                            .select((LoginCubit cubit) => cubit.state.loading);
                        return FilledButton(
                          onPressed: formState.status.isPure ||
                                  formState.status.isInvalid ||
                                  loading
                              ? null
                              : () => context.read<LoginCubit>().submitted(),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('Login'),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
