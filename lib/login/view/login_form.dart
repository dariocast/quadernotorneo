import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/login/login.dart';

class LoginForm extends StatelessWidget {
  final Map persistence;

  const LoginForm(this.persistence);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content: Text(
                      'Autenticazione non riuscita, controlla username e password')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(persistence),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(persistence),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
            const Padding(padding: EdgeInsets.all(12)),
            _SaveCredentialCheckbox(),
          ],
        ),
      ),
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
            context.bloc<LoginBloc>().add(LoginPersistChanged(value));
          },
          value: state.persist,
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  final Map persistence;
  _UsernameInput(this.persistence) {
    print(this.persistence);
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_usernameInput_textField'),
          initialValue: persistence != null ? persistence['username'] : '',
          onChanged: (username) =>
              context.bloc<LoginBloc>().add(LoginUsernameChanged(username)),
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
  final Map persistence;
  _PasswordInput(this.persistence) {
    print(this.persistence);
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_passwordInput_textField'),
          initialValue: persistence != null ? persistence['password'] : '',
          onChanged: (password) =>
              context.bloc<LoginBloc>().add(LoginPasswordChanged(password)),
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
            : RaisedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('Login'),
                onPressed: state.status.isValidated
                    ? () {
                        context.bloc<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}
