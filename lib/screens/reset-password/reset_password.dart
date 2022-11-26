import '/widgets/custom_textfield.dart';
import '/screens/reset-password/cubit/reset_password_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/show_snakbar.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/auth/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/curved_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordArgs {
  final String? email;
  final bool isEnabled;

  ResetPasswordArgs({
    required this.email,
    this.isEnabled = false,
  });
}

class ResetPassword extends StatefulWidget {
  static const String routeName = '/resetPassword';

  final String? email;
  final bool isEnabled;

  const ResetPassword({
    Key? key,
    this.email,
    this.isEnabled = false,
  }) : super(key: key);

  static Route route({required ResetPasswordArgs? args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => ResetPasswordCubit(
          authBloc: context.read<AuthBloc>(),
          authRepository: context.read<AuthRepository>(),
        )..load(),
        child: ResetPassword(
          isEnabled: args?.isEnabled ?? false,
          email: args?.email,
        ),
      ),
    );
  }

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  void _submit(bool isSubmitting) async {
    print('aaa $isSubmitting');
    if (!isSubmitting) {
      if (_formKey.currentState!.validate()) {
        context.read<ResetPasswordCubit>().resetPassword();
      }
    }
  }

  @override
  void initState() {
    if (widget.isEnabled && widget.email != null) {
      context.read<ResetPasswordCubit>().emailChanged(widget.email!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state.status == ResetPasswordStatus.error) {
            ShowSnackBar.showSnackBar(
              context,
              title: state.failure.message,
              backgroundColor: Colors.red,
            );
          }
          if (state.status == ResetPasswordStatus.succuss) {
            ShowSnackBar.showSnackBar(
              context,
              title:
                  'We have sent an email, with a link to reset your password',
              backgroundColor: Colors.green,
            );

            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.status == ResetPasswordStatus.loading) {
            return const LoadingIndicator();
          }
          return Stack(
            children: [
              const CurvedContainer(),
              Positioned(
                top: 38.0,
                left: 2.0,
                right: 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/twins.svg',
                          height: 27.0,
                          width: 27.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10.0),
                        const Text(
                          'AstroTwins',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_back,
                        size: 18.0,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 140.0,
                left: 10.0,
                right: 10.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.amber,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        height: size.height * 0.35,
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              const Center(
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              const Text('Email'),
                              const SizedBox(height: 5.0),
                              CustomTextField(
                                initialValue: state.email,
                                isEnabled: widget.isEnabled,

                                onChanged: (value) {
                                  if (widget.isEnabled) {
                                    context
                                        .read<ResetPasswordCubit>()
                                        .emailChanged(value);
                                  }
                                },
                                //onChanged: _registrationCubit.emailChanged,
                                hintText: 'Enter enter your email',
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
                              const SizedBox(height: 40.0),
                              SizedBox(
                                height: 42.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xffDC402B),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  onPressed: () => _submit(state.status ==
                                      ResetPasswordStatus.loading),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
