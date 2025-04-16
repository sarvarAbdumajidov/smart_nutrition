import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/providers.dart';
import '../service/auth_service.dart';


final authServiceProvider = StateNotifierProvider<AuthService, User?>(
      (ref) => AuthService(),
);

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  void _changePassword() async {
    final newPass = newPassController.text.trim();
    final confirmPass = confirmPassController.text.trim();

    if (newPass != confirmPass) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("str_password_do_not_match".tr())),
      );
      return;
    }

    // Firebase faqat login holatda yangi parolni qabul qiladi
    final authService = ref.read(authServiceProvider.notifier);
    final result = await authService.changePassword(newPass);

    Navigator.of(context).pop();

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("str_password_updated_successfully".tr())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $result".tr())),
      );
    }

    oldPassController.clear();
    newPassController.clear();
    confirmPassController.clear();
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("str_settings".tr(), style: TextStyle(fontSize: 25)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              SizedBox(height: 80),

              // CHANGE PASSWORD
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("str_change_password".tr()),
                          content: SizedBox(
                            width: 400,
                            height: 280,
                            child: Column(
                              children: [
                                TextField(
                                  controller: oldPassController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "str_old_password".tr(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: newPassController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "str_new_password".tr(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: confirmPassController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "str_confirm_new_password".tr(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _changePassword,
                                  child: Text("str_change_password".tr(), style: TextStyle(fontSize: 22)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text("str_change_password".tr(), style: TextStyle(fontSize: 22)),
                ),
              ),

              SizedBox(height: 30),

              // CHANGE LANGUAGE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('str_change_language'.tr()),
                          content: SizedBox(
                            width: 400,
                            height: 280,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CountryFlag.fromLanguageCode('en',width: 40,height: 25,),
                                  title: Text('English'),
                                  onTap: () {
                                    context.setLocale(Locale('en', 'US'));
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: CountryFlag.fromLanguageCode('ru',width: 40,height: 25,),
                                  title: Text('Русский'),
                                  onTap: () {
                                    context.setLocale(Locale('ru', 'RU'));
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: CountryFlag.fromLanguageCode('uz',width: 40,height: 25),
                                  title: Text('O‘zbekcha'),
                                  onTap: () {
                                    context.setLocale(Locale('uz', 'UZ'));
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                  },
                  child: Text("str_change_password".tr(), style: TextStyle(fontSize: 22)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
