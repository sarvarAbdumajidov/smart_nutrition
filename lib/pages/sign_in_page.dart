import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nutrition/pages/admin/home_page.dart';
import 'package:smart_nutrition/pages/categories_page.dart';
import 'package:smart_nutrition/pages/sign_up_page.dart';
import 'package:smart_nutrition/provider/providers.dart';

import '../service/hive_service.dart';
import 'forgot_password_page.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  void _signIn(BuildContext context, WidgetRef ref) async {
    final emailController = ref.read(emailControllerProvider);
    final passwordController = ref.read(passwordControllerProvider);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    final auth = ref.read(authProvider.notifier);

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("str_fill_in_the_blank".tr())));
      return;
    }
    final user = await auth.signInUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    bool emailVerified = await auth.checkEmailVerified();
    if (!emailVerified) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("str_email_not_verified".tr())));
      return;
    }

    if (user != null) {
      FocusScope.of(context).unfocus();
      ref.read(loadingProvider.notifier).startLoading();
      String? role = await auth.getUserRole();
      ref.read(loadingProvider.notifier).stopLoading();
      ref.read(emailControllerProvider).clear();
      ref.read(passwordControllerProvider).clear();
      final hiveService = HiveService();
      hiveService.setLoginStatus(true);

      switch (role) {
        case 'user':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CategoriesPage()),
          );
        case 'admin':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("str_incorrect_login_or_password".tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
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

                    // EMAIL
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

                    // PASSWORD
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "str_password".tr(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Sign in
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: MaterialButton(
                        color: Color(0xFFBD883E),
                        onPressed: () {
                          _signIn(context, ref);
                        },
                        child: Text("str_sign_in".tr()),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("str_dont_have_account".tr()),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            ref.read(emailControllerProvider).clear();
                            ref.read(passwordControllerProvider).clear();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text("str_sign_up".tr()),
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text("str_forgot_password".tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
