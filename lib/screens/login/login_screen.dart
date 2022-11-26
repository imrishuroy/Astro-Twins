import '/constants/constants.dart';
import '/screens/reset-password/reset_password.dart';

import '/widgets/custom_textfield.dart';
import '/blocs/auth/auth_bloc.dart';
import '/screens/nav/nav_screen.dart';
import '/screens/registration/screens/registration_screen.dart';
import '/widgets/loading_indicator.dart';
import '/repositories/auth/auth_repo.dart';
import '/screens/login/cubit/login_cubit.dart';
import '/widgets/show_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
          authBloc: context.read<AuthBloc>(),
        ),
        child: const LoginScreen(),
      ),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().loginEmail();
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('Height of Login Screen -- ${size.height}');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              ShowSnackBar.showSnackBar(
                context,
                title: state.failure.message,
                backgroundColor: Colors.red,
              );
            }
            if (state.status == LoginStatus.succuss) {
              ShowSnackBar.showSnackBar(
                context,
                title: 'Login Successful',
                backgroundColor: Colors.green,
              );
              Navigator.of(context).pushReplacementNamed(NavScreen.routeName);
            }
          },
          builder: (context, state) {
            if (state.status == LoginStatus.submitting) {
              return const LoadingIndicator();
            }
            return Form(
              key: _formKey,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: size.height * 0.35,
                        //height: 250.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            // stops: [0.1, 0.5, 0.7, 0.9],
                            stops: [0.1, 0.3],
                            colors: [
                              Color(0xffF28931),
                              Color(0xffED462F),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 60.0,
                    left: 2.0,
                    right: 2.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/twins.svg',
                          height: 27.0,
                          width: 27.0,
                        ),
                        const SizedBox(width: 10.0),
                        const Text(
                          'AstroTwins',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 140.0,
                    left: 10.0,
                    right: 10.0,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: size.height * 0.65,
                          child: ListView(
                            children: [
                              const Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              const Text('Email'),
                              const SizedBox(height: 5.0),
                              CustomTextField(
                                initialValue: state.email,
                                onChanged:
                                    context.read<LoginCubit>().emailChanged,
                                hintText: 'Enter email',
                                validator: (value) {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!);

                                  if (emailValid) {
                                    return null;
                                  }
                                  return 'Invalid Email';
                                },
                                inputType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20.0),
                              const Text('Password'),
                              const SizedBox(height: 5.0),
                              CustomTextField(
                                maxLines: 1,
                                suffixIcon: IconButton(
                                  color: Colors.grey.shade400,
                                  icon: Icon(
                                    state.showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => context
                                      .read<LoginCubit>()
                                      .showPassword(state.showPassword),
                                ),
                                onChanged:
                                    context.read<LoginCubit>().passwordChanged,
                                hintText: 'Password',
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return 'Please check password';
                                  }
                                  return null;
                                  //return _checkPassword(value!);

                                  // if (value!.length < 6) {
                                  //   return 'Password too short';
                                  // }
                                  // return null;
                                },
                                inputType: TextInputType.visiblePassword,
                                isPassowrdField: !state.showPassword,
                              ),
                              const SizedBox(height: 15.0),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed(
                                    ResetPassword.routeName,
                                    arguments: ResetPasswordArgs(
                                      email: state.email,
                                      isEnabled: true,
                                    ),
                                  ),
                                  child: const Text(
                                    'Forget Password?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.0,
                                      color: Contants.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(height: size.height * 0.08),
                              const SizedBox(height: 35.0),
                              SizedBox(
                                height: 42.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xffDC402B),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  onPressed: () => _submitForm(context,
                                      state.status == LoginStatus.submitting),
                                  child: const Text('Login'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              const Center(child: Text('or')),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(RegistrationScreen.routeName),
                                child: const Text(
                                  'Don\'t have account, Register',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Contants.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
