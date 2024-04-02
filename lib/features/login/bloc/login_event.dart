part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class SignInLoginEvent implements LoginEvent{
  final String email;
  final String password;
  final FirebaseAuth mAuth;

  SignInLoginEvent({required this.email,required  this.password,required this.mAuth});
}

class LoginButtonErrorEvent extends LoginEvent{
  final String error;
  LoginButtonErrorEvent(this.error);

}

