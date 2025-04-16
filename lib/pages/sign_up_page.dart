import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nutrition/provider/providers.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  void _signUp(BuildContext context, WidgetRef ref) async {
    final emailController = ref.read(emailControllerProvider);
    final passwordController = ref.read(passwordControllerProvider);
    final confirmPasswordController = ref.read(confirmPasswordControllerProvider);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final auth = ref.read(authProvider.notifier);
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("str_fill_in_the_blank".tr())),
      );
      return;
    }

    if (confirmPassword != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("str_passwords_should_be_the_same".tr())),
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("str_email_doesnt_fit_the_requirements".tr())),
      );
      return;
    }

    ref.read(loadingProvider.notifier).startLoading();

    final user = await auth.signUpUser(email, password);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("str_verification_link_sent".tr())),
      );

      // Email tasdiqlanganini kutamiz
      _waitForEmailVerification(context, ref);
    } else {
      ref.read(loadingProvider.notifier).stopLoading();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("str_sign_up_failed".tr())),
      );
    }
  }

  void _waitForEmailVerification(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authProvider.notifier);

    while (true) {
      await Future.delayed(Duration(seconds: 3));

      bool emailVerified = await auth.checkEmailVerified();
      if (emailVerified) {
        ref.read(loadingProvider.notifier).stopLoading();
        Navigator.pop(context);
        break;
      }
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final confirmPasswordController = ref.watch(confirmPasswordControllerProvider);

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
                    Text("str_welcome".tr(), style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(hintText: "str_email".tr()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(hintText:  "str_password".tr()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: confirmPasswordController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(hintText: "str_confirm_password".tr()),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: MaterialButton(
                        color: Color(0xFFBD883E),
                        onPressed: () => _signUp(context, ref),
                        child: Text("str_sign_up".tr()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("str_already_have_account".tr()),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            ref.read(emailControllerProvider).clear();
                            ref.read(passwordControllerProvider).clear();
                            Navigator.of(context).pop();
                          },
                          child: Text("str_sign_in".tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
