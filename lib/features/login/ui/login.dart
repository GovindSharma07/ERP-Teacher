import 'package:erp_teacher/features/home/ui/home.dart';
import 'package:erp_teacher/features/login/bloc/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final LoginBloc _loginBloc;
  late final FirebaseAuth _mAuth;

  @override
  void initState() {
    _loginBloc = LoginBloc();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _mAuth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.close();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        bloc: _loginBloc,
        listenWhen: (previous, current) {
          if (current is LoginActionState) {
            return true;
          } else {
            return false;
          }
        },
        buildWhen: (previous, current) =>
            (current is LoginActionState) ? false : true,
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          }
        },
        builder: (context, state) {
          if (state is LoginLoadingState) {
            return const Scaffold(
              body: Center(child: Text("Loading...")),
            );
          } else {
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/login_bg.jpg"),
                        fit: BoxFit.fill)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text("Welcome!",
                          style: TextStyle(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      const Text(
                        "We're so happy to have you with us on this",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75),
                            image: const DecorationImage(
                                image: AssetImage("assets/images/teacher.jpg"),
                                fit: BoxFit.contain)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (state is LoginErrorState)
                          ? Text(
                              state.error,
                              style: const TextStyle(color: Colors.red),
                            )
                          : const SizedBox(),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            enabled: true,
                            labelText: "Email Address",
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(width: 2))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: "*",
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.key,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(width: 2)),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_emailController.text.isEmpty) {
                              _loginBloc.add(LoginButtonErrorEvent(
                                  "Please fill the Email id !!!"));
                            } else if (_passwordController.text.isEmpty) {
                              _loginBloc.add(LoginButtonErrorEvent(
                                  "Please fill the Password !!!"));
                            } else {
                              _loginBloc.add(SignInLoginEvent(
                                  email: _emailController.text.toString(),
                                  password: _passwordController.text.toString(),
                                  mAuth: _mAuth));
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
