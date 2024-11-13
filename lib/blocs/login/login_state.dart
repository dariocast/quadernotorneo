part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.hidePassword = true,
    this.persist = false,
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Username username;
  final Password password;
  final bool hidePassword;
  final bool persist;
  final bool isValid;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    bool? hidePassword,
    bool? persist,
    bool? isValid,
  }) {
    return LoginState(
        status: status ?? this.status,
        username: username ?? this.username,
        password: password ?? this.password,
        hidePassword: hidePassword ?? this.hidePassword,
        persist: persist ?? this.persist,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [status, username, password, hidePassword, persist];
}
