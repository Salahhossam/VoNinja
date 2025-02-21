import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/modules/login_page/login_page.dart';

import '../../generated/l10n.dart';
import '../../shared/style/color.dart';
import 'singup_cubit/singup_cubit.dart';
import 'singup_cubit/singup_state.dart';

class SingupPage extends StatelessWidget {
  const SingupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final singupCubit = SingupCubit.get(context);

    return BlocBuilder<SingupCubit, SingupState>(
      builder: (BuildContext context, SingupState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                // Background image and shadow overlay
                _buildBackground(),
                // Register form
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: singupCubit.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                            child: Text(S.of(context).appTitle,
                                style: const TextStyle(
                                    fontSize: 25, color: Colors.white))),
                        const SizedBox(height: 60),
                        Text(S.of(context).register,
                            style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        _buildTextField(
                            S.of(context).fristName,
                            singupCubit.fristNameController,
                            TextInputType.text,
                            context),
                        const SizedBox(height: 20),
                        _buildTextField(
                            S.of(context).lastName,
                            singupCubit.lastNameController,
                            TextInputType.text,
                            context),
                        const SizedBox(height: 20),
                        _buildTextField(
                            S.of(context).userName,
                            singupCubit.userNameController,
                            TextInputType.text,
                            context),
                        const SizedBox(height: 20),
                        _buildTextField(
                            S.of(context).phoneNumber,
                            singupCubit.phoneNumberController,
                            TextInputType.phone,
                            context),
                        const SizedBox(height: 20),
                        _buildTextField(
                            S.of(context).email,
                            singupCubit.emailController,
                            TextInputType.emailAddress,
                            context),
                        const SizedBox(height: 20),
                        _buildPasswordField(
                            context: context,
                            label: S.of(context).password,
                            controller: singupCubit.passwordController,
                            isVisible: singupCubit.isPasswordVisible,
                            toggleVisibility:
                                singupCubit.toggleNewPasswordVisibility,
                            passwordLabel: S.of(context).password),
                        const SizedBox(height: 20.0),
                        _buildPasswordField(
                            context: context,
                            label: S.of(context).confirmPassword,
                            controller: singupCubit.confirmPasswordController,
                            isVisible: singupCubit.isConfirmPasswordVisible,
                            toggleVisibility:
                                singupCubit.toggleConfirmPasswordVisibility,
                            passwordLabel: S.of(context).confirmPassword),
                        const SizedBox(height: 20),
                        _buildRegisterButton(context),
                        const SizedBox(height: 10),
                        _buildLoginButton(context),
                      ],
                    ),
                  ),
                ),
              ],
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
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType, BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
        filled: true,
        fillColor: Colors.grey,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).enterLabel(label);
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required String passwordLabel,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !isVisible,
      style: const TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
        filled: true,
        fillColor: Colors.grey,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).enterPasswordLabel(passwordLabel);
        }
        if (value != SingupCubit.get(context).passwordController.text) {
          return S.of(context).doNotMatch;
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(context) {
    final singupCubit = SingupCubit.get(context);

    return BlocBuilder<SingupCubit, SingupState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is SingupLoading
              ? null
              : () async {
                  if (singupCubit.formKey.currentState != null &&
                      singupCubit.formKey.currentState!.validate()) {
                    await singupCubit.singup(
                      context,
                      singupCubit.fristNameController.text,
                      singupCubit.lastNameController.text,
                      singupCubit.userNameController.text,
                      singupCubit.phoneNumberController.text,
                      singupCubit.emailController.text,
                      singupCubit.passwordController.text,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            minimumSize: const Size(double.infinity, 70),
          ),
          child: state is SingupLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
              : Text(S.of(context).createAccount,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xFF1A3037),
                      fontWeight: FontWeight.bold)),
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).alreadyHaveAccount,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Text(
              S.of(context).login,
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
      ),
    );
  }
}
