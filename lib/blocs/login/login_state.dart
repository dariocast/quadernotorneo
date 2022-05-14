part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.hidePassword = true,
    this.persist = false,
  });

  final FormzStatus status;
  final Username username;
  final Password password;
  final bool hidePassword;
  final bool persist;

  LoginState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
    bool? hidePassword,
    bool? persist,
  }) {
    return LoginState(
        status: status ?? this.status,
        username: username ?? this.username,
        password: password ?? this.password,
        hidePassword: hidePassword ?? this.hidePassword,
        persist: persist ?? this.persist);
  }

  @override
  List<Object> get props => [status, username, password, hidePassword, persist];
}
