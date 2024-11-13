import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/blocs.dart';
import 'style_helpers.dart';

class LoginForm extends StatelessWidget {
  const LoginForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.loginAuthFailureMessage,
                ),
              ),
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
          title:
              Text(AppLocalizations.of(context)!.loginRememberMeCheckboxLabel),
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
            labelText: AppLocalizations.of(context)!.loginFormEmailLabel,
            errorText: state.username.isNotValid
                ? AppLocalizations.of(context)!.loginFormEmailErrorLabel
                : null,
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
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.hidePassword != current.hidePassword,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_passwordInput_textField'),
          initialValue: state.password.value,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: state.hidePassword,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.loginFormPasswordLabel,
            errorText: state.password.isNotValid
                ? AppLocalizations.of(context)!.loginFormPasswordErrorLabel
                : null,
            suffixIcon: InkWell(
              onTap: () => context
                  .read<LoginBloc>()
                  .add(LoginTogglePasswordVisibility()),
              child: state.hidePassword
                  ? Icon(Icons.visibility_off_outlined)
                  : Icon(Icons.visibility_outlined),
            ),
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
      builder: (context, state) {
        return ElevatedButton(
          style: elevatedButtonStyle,
          key: const Key('loginForm_continue_raisedButton'),
          child: Text(AppLocalizations.of(context)!.loginFormSubmitLabel),
          onPressed: state.isValid && !state.status.isInProgress
              ? () {
                  context.read<LoginBloc>().add(const LoginSubmitted());
                }
              : null,
        );
      },
    );
  }
}
