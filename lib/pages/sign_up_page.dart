import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_nutrition/provider/providers.dart';
import 'package:smart_nutrition/service/auth_service.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  void _signUp(BuildContext context, WidgetRef ref) async {
    final emailController = ref.read(emailControllerProvider);
    final passwordController = ref.read(passwordControllerProvider);
    final confirmPasswordController = ref.read(
      confirmPasswordControllerProvider,
    );
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final auth = ref.read(authProvider.notifier);
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fill in the blank!')));
      return;
    }
    if (confirmPassword != password) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('passwords should be the same')));
      return;
    }
    if(!emailRegex.hasMatch(email)){
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Email don't fit with requirements ")));
      ref.read(emailControllerProvider).clear();
      ref.read(passwordControllerProvider).clear();
      ref.read(confirmPasswordControllerProvider).clear();

      return;
    }
    ref.read(loadingProvider.notifier).startLoading();
    await auth.signUpUser(email, password);
    if (context.mounted) {
      ref.read(loadingProvider.notifier).stopLoading();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final confirmPasswordController = ref.watch(
      confirmPasswordControllerProvider,
    );
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Welcome', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 40),

                    // EMAIL
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // PASSWORD
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(hintText: 'Password'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // CONFIRM PASSWORD
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: confirmPasswordController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Sign Up
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: MaterialButton(
                        color: Color(0xFFBD883E),
                        onPressed: () => _signUp(context, ref),
                        child: Text('Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Already have an account?'),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            ref.read(emailControllerProvider).clear();
                            ref.read(passwordControllerProvider).clear();
                            ref.read(confirmPasswordControllerProvider).clear();
                            Navigator.of(context).pop();
                          },
                          child: Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
