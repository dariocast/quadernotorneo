import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../database.dart';
import '../../models/models.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    } else if (event is LoginPersistChanged) {
      yield _mapLoginPersistChangedToState(event, state);
    } else if (event is LoginLoaded) {
      yield* _mapLoginPersistenceLoadedToState(event, state);
    }
  }

  Stream<LoginState> _mapLoginPersistenceLoadedToState(
    LoginLoaded event,
    LoginState state,
  ) async* {
    var persistenceObj = await Database.get('persistence');
    if (persistenceObj != null) {
      final persistence =
          Persistence(persistenceObj['username'], persistenceObj['password']);
      final username = Username.dirty(persistence.username);
      final password = Password.dirty(persistence.password);
      yield state.copyWith(
        status: Formz.validate([username, password]),
        username: username,
        password: password,
      );
      try {
        await _authenticationRepository.logIn(
          username: persistence.username,
          password: persistence.password,
        );
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    } else {
      yield state.copyWith();
    }
  }

  LoginState _mapLoginPersistChangedToState(
      LoginPersistChanged event, LoginState state) {
    final persist = event.persist;
    return state.copyWith(
        persist: persist,
        status: Formz.validate([state.password, state.username]));
  }

  LoginState _mapUsernameChangedToState(
    LoginUsernameChanged event,
    LoginState state,
  ) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    );
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        if (state.persist) {
          Database.put('persistence', {
            'username': state.username.value,
            'password': state.password.value
          });
        }
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
