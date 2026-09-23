import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _handleRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(RegisterRequested(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go('/dashboard');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/Logo.png',
                        height: 20.h,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    AppText(
                      'Create Account',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 6.h),
                    AppText(
                      'Sign up to get started',
                      fontSize: 14,
                      color: AppColors.text.withValues(alpha: 0.7),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _firstNameController,
                            labelText: 'First Name',
                            hintText: 'John',
                            textInputAction: TextInputAction.next,
                            validator: (val) => Validators.required(val, 'First name is required'),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: AppTextField(
                            controller: _lastNameController,
                            labelText: 'Last Name',
                            hintText: 'Doe',
                            textInputAction: TextInputAction.next,
                            validator: (val) => Validators.required(val, 'Last name is required'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Create a password',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: Validators.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.hint,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  SizedBox(height: 24.h),
                  AppButton(
                    text: 'Register',
                    isLoading: state is AuthLoading,
                    onPressed: () => _handleRegister(context),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        'Already have an account? ',
                        fontSize: 14,
                      ),
                      GestureDetector(
                        onTap: () => context.pop(), // Go back to login
                        child: AppText(
                          'Login',
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            );
          },
        ),
      ),
    );
        },
      ),
    );
  }
}
