// @dart=2.9
import 'dart:async';
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final name = await _userRepository.getAquaUser();
      yield Authenticated(name);
    } else {
      yield Unauthenticated(await _userRepository.aqariSignOut());
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getAquaUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated(await _userRepository.aqariSignOut());
    //   _userRepository.signOut();
  }
}
