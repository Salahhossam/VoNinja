import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/modules/singup_page/singup_page.dart';
import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = LoginCubit.get(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).wrongCredentials)),
          );
        } else if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).resetPassword)),
          );
        } else if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).wrongResetPassword)),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.mainColor,
            resizeToAvoidBottomInset: true,
            body: WillPopScope(
              onWillPop: () async => loginCubit.doubleBack(context),
              child: SafeArea(
                child: Stack(
                  children: [
                    _buildBackground(),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: loginCubit.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            _buildHeaderTitle(context),
                            const SizedBox(height: 135),
                            _buildLoginTitle(context),
                            const SizedBox(height: 20),
                            _buildEmailField(context),
                            const SizedBox(height: 20),
                            _buildPasswordField(state, loginCubit, context),
                            _buildRememberMeRow(state, loginCubit, context),
                            const SizedBox(height: 20),
                            _buildLoginButton(state, loginCubit, context),
                            const SizedBox(height: 30),
                            _buildSignUpRow(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/Background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return _buildTextField(
      controller: LoginCubit.get(context).emailOrUserNameController,
      labelText: S.of(context).email,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).enterEmail;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
      LoginState state, LoginCubit loginCubit, BuildContext context) {
    return _buildTextField(
      controller: LoginCubit.get(context).passwordController,
      labelText: S.of(context).password,
      keyboardType: TextInputType.visiblePassword,
      obscureText:
          !(state is LoginPasswordVisibilityChanged && state.isVisible),
      suffixIcon: IconButton(
        icon: Icon(
          (state is LoginPasswordVisibilityChanged && state.isVisible)
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: loginCubit.togglePasswordVisibility,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).enterPassword;
        }
        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        filled: true,
        fillColor: Colors.grey,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  Widget _buildRememberMeRow(
      LoginState state, LoginCubit loginCubit, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                activeColor: AppColors.whiteColor,
                checkColor: AppColors.mainColor,
                value: (state is LoginRememberMeChanged && state.rememberMe),
                onChanged: (value) {
                  loginCubit.toggleRememberMe(value ?? false);
                },
              ),
              Flexible(
                child: Text(
                  S.of(context).rememberMe,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () async {
            final emailOrUserName = loginCubit.emailOrUserNameController.text;
            if (emailOrUserName.isNotEmpty) {
              loginCubit.forgotPassword(emailOrUserName, context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).enterEmailOrUserNameToReset),
                ),
              );
            }
          },
          child: Text(
            S.of(context).forgetPassword,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginState state, LoginCubit loginCubit, context) {
    final loginCubit = LoginCubit.get(context);

    return ElevatedButton(
      onPressed: (state is LoginLoading)
          ? null
          : () async {
              String? fcmToken = await getFcmToken();
              if (loginCubit.formKey.currentState != null &&
                  loginCubit.formKey.currentState!.validate()) {
                loginCubit.login(
                    context,
                    loginCubit.emailOrUserNameController.text,
                    loginCubit.passwordController.text,
                    fcmToken!);
              }
            },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: const Size(double.infinity, 70),
      ),
      child: (state is LoginLoading)
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              S.of(context).loginButton,
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Center(
      child: Text(
        S.of(context).appTitle,
        style: const TextStyle(
          fontSize: 25,
          color: AppColors.whiteColor,
          fontFamily: 'JollyLodger-Regular',
        ),
      ),
    );
  }

  Widget _buildLoginTitle(BuildContext context) {
    return Center(
      child: Text(
        S.of(context).login,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
          fontFamily: 'JollyLodger-Regular',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.of(context).noAccount,
          style: const TextStyle(fontSize: 18, color: AppColors.whiteColor),
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SingupPage()),
            );
          },
          child: Text(
            S.of(context).signUp,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.whiteColor,
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }
}
