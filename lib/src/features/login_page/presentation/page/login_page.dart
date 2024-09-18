import 'dart:ui';
import 'package:bus_app/nav_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app_localization/l10n.dart';
import '../../../../constant/custom_text_from_field.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool obscurePassword = true;
  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          setState(() {
            signInRequired = false;
          });
          // print('success state');
          /* Navigator.of(context).replace(
              oldRoute: ModalRoute.of(context)!,
              newRoute: MaterialPageRoute(builder: (context) => MyHomePage()));*/
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const NavPage()),
              (route) => false);
        }
        if (state is LoginInProcessState) {
          setState(() {
            signInRequired = true;
          });
        }
        if (state is LoginFailureState) {
          setState(() {
            signInRequired = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amberAccent,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-2.7, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 1.3,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(2.7, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 1.3,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Theme.of(context).colorScheme.primary
                        color: Colors.purple),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(),
                ),
                const SizedBox(
                  height: 200,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            l10n.login,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  MyTextField(
                                    controller: emailController,
                                    hintText: l10n.email,
                                    obsecureText: false,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon:
                                        const Icon(CupertinoIcons.mail_solid),
                                    errorMsg: _errorMsg,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return l10n.enterEmail;
                                      } else if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                          .hasMatch(val)) {
                                        return l10n.enterValidEmail;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  MyTextField(
                                    controller: passwordController,
                                    hintText: l10n.password,
                                    obsecureText: obscurePassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    prefixIcon: const Icon(
                                      CupertinoIcons.lock_fill,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                          if (obscurePassword) {
                                            iconPassword =
                                                CupertinoIcons.eye_slash_fill;
                                          } else {
                                            iconPassword =
                                                CupertinoIcons.eye_fill;
                                          }
                                        });
                                      },
                                      icon: Icon(iconPassword),
                                    ),
                                    // validator: (val) {
                                    //   if (val!.isEmpty) {
                                    //     return l10n.enterpassword;
                                    //   } else if (!RegExp(
                                    //           r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                    //       .hasMatch(val)) {
                                    //     return l10n.entervalidpassword;
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  !signInRequired
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: BlocBuilder<LoginBloc,
                                              LoginState>(
                                            builder: (context, state) {
                                              return TextButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      context
                                                          .read<LoginBloc>()
                                                          .add(GetLoginEvent(
                                                              email:
                                                                  emailController
                                                                      .text,
                                                              password:
                                                                  passwordController
                                                                      .text));
                                                    }
                                                  },
                                                  style: TextButton.styleFrom(
                                                      elevation: 3.0,
                                                      // backgroundColor:
                                                      //     Theme.of(context)
                                                      //         .colorScheme
                                                      //           .primary,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60))),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 25,
                                                        vertical: 5),
                                                    child: Text(
                                                      l10n.login,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ));
                                            },
                                          ),
                                        )
                                      : const CircularProgressIndicator(),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
