import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/repository/login_repository_impl.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ImplLoginRepository _loginRepository;
  LoginBloc({required ImplLoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(LoginInitialState()) {
    on<GetLoginEvent>((event, emit) async {
      try {
        emit(LoginInProcessState());
        await _loginRepository.login(event.email, event.password);
        emit(LoginSuccessState());
      } catch (errMsg) {
        emit(LoginFailureState(errMsg: errMsg.toString()));
      }
    });
  }
}
