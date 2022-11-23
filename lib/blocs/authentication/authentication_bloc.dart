import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

import '../../database.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );

    // Handler for auth changed
    on<AuthenticationStatusChanged>((event, emit) async {
      switch (event.status) {
        case AuthenticationStatus.unauthenticated:
          emit(const AuthenticationState.unauthenticated());
          break;
        case AuthenticationStatus.authenticated:
          final user = await _tryGetUser();
          return emit(
            user != null
                ? AuthenticationState.authenticated(user)
                : const AuthenticationState.unauthenticated(),
          );
        default:
          emit(const AuthenticationState.unknown());
          break;
      }
    });

    // Handler for logout
    on<AuthenticationLogoutRequested>((event, emit) async {
      _authenticationRepository.logOut();
      await Database.remove();
    });
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }
}
