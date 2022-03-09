import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../database.dart';
import '../../models/models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(
        (event, emit) => _handleUsernameChanged(event, emit));
    on<LoginPasswordChanged>(
        (event, emit) => _handlePasswordChanged(event, emit));
    on<LoginSubmitted>((event, emit) => _handleLoginSubmitted(event, emit));
    on<LoginPersistChanged>(
        (event, emit) => _handleLoginPersistChanged(event, emit));
    on<LoginLoaded>(
        (event, emit) => _handleLoginPersistenceLoaded(event, emit));
  }

  final AuthenticationRepository _authenticationRepository;

  _handleUsernameChanged(LoginUsernameChanged event, Emitter<LoginState> emit) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    ));
  }

  _handlePasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    ));
  }

  _handleLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
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
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } on Exception catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  _handleLoginPersistChanged(
      LoginPersistChanged event, Emitter<LoginState> emit) {
    final persist = event.persist;
    emit(state.copyWith(
        persist: persist,
        status: Formz.validate([state.password, state.username])));
  }

  _handleLoginPersistenceLoaded(
      LoginLoaded event, Emitter<LoginState> emit) async {
    var persistenceObj = await Database.get('persistence');
    if (persistenceObj != null) {
      final persistence =
          Persistence(persistenceObj['username'], persistenceObj['password']);
      final username = Username.dirty(persistence.username);
      final password = Password.dirty(persistence.password);
      emit(state.copyWith(
        status: Formz.validate([username, password]),
        username: username,
        password: password,
      ));
      try {
        await _authenticationRepository.logIn(
          username: persistence.username,
          password: persistence.password,
        );
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } on Exception catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } else {
      emit(state.copyWith());
    }
  }
}
