part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  @override
  List<Object?> get props => [];
}

class GetLoginEvent extends LoginEvent {
  String email;
  String password;
  GetLoginEvent({required this.email, required this.password});
}
