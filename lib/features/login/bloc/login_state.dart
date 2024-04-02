part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginActionState extends LoginState{}

final class LoginLoadingState extends LoginState{}

final class LoginSuccessState extends LoginActionState{}

final class LoginErrorState extends LoginState{
  final String error;
  LoginErrorState(this.error);
}
