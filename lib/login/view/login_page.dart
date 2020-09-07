import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/login/login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final Map persistence;
  LoginPage(this.persistence);

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    LoginForm form = LoginForm(persistence);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: form,
        ),
      ),
    );
  }
}
