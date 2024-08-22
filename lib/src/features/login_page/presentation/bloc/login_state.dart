part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginInProcessState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginState {
  String errMsg;

  LoginFailureState({required this.errMsg});
}
