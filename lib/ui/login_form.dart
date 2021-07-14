import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../models/models.dart';
import 'style_helpers.dart';

class LoginForm extends StatelessWidget {
  const LoginForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content: Text(
                      'Autenticazione non riuscita, controlla username e password')),
            );
        }
      },
      builder: (context, state) {
        return Align(
          alignment: const Alignment(0, -1 / 3),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _UsernameInput(state.username.value),
                const Padding(padding: EdgeInsets.all(12)),
                _PasswordInput(state.password.value),
                const Padding(padding: EdgeInsets.all(12)),
                _LoginButton(),
                const Padding(padding: EdgeInsets.all(12)),
                _SaveCredentialCheckbox(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SaveCredentialCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SwitchListTile(
          key: const Key('loginForm_saveCredential_switch'),
          title: Text("Ricordami"),
          onChanged: (bool value) {
            context.read<LoginBloc>().add(LoginPersistChanged(persist: value));
          },
          value: state.persist,
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  final String? username;
  _UsernameInput(this.username);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_usernameInput_textField'),
          initialValue: state.username.value,
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.username.invalid ? 'Username non valida' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final String? password;
  _PasswordInput(this.password);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_passwordInput_textField'),
          initialValue: state.password.value,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.password.invalid ? 'Password non valida' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: elevatedButtonStyle,
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('Login'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}
