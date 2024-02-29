import 'package:flutter/material.dart';
import 'package:save_images_with_password_sqlite/models/password.dart';
import 'package:save_images_with_password_sqlite/screens/home_screen.dart';
import 'package:save_images_with_password_sqlite/widgets/my_text_field.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  Future<void> setUpNewPassword() async {
    Password.password = _passwordController.text;
    await Password.setUpThePasswordForFirstTime();
  }

  Future<bool> checkPassword() async {
    return Password.password == _passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Password.password == null
                  ? MyTextField(
                      hintText: 'Set up password',
                      controller: _passwordController)
                  : MyTextField(
                      hintText: 'Enter the password',
                      controller: _passwordController),
              TextButton(
                onPressed: () async {
                  if (_passwordController.text != '') {
                    if (Password.password == null) {
                      await setUpNewPassword();
                    } else {
                      if (!await checkPassword()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Wrong password!',
                            ),
                          ),
                        );
                        return;
                      }
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const HomeScreen(),
                      ),
                    );
                  }
                },
                child: const Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
