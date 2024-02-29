import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_images_with_password_sqlite/models/password.dart';
import 'package:save_images_with_password_sqlite/providers/folder_provider.dart';
import 'package:save_images_with_password_sqlite/screens/home_screen.dart';
import 'package:save_images_with_password_sqlite/widgets/my_text_field.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPassword2Controller = TextEditingController();

  Future<void> update() async {
    Password.password = _newPassword2Controller.text;
    await Password.updatePassword();
  }

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<FolderProvider>(context);
    value.folders;
    print(
        '==================================== found providerrr ${value.folders}');
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyTextField(
                  hintText: 'Old password',
                  controller: _oldPasswordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                  hintText: 'Enter the password',
                  controller: _newPasswordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                  hintText: 'Enter the password',
                  controller: _newPassword2Controller,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () async {
                    if (_oldPasswordController.text == Password.password) {
                      if (_newPasswordController.text ==
                          _newPassword2Controller.text) {
                        await update();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Password had been changes successfully!',
                            ),
                          ),
                        );

                        Navigator.pop(
                          context,
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Wrong old password!',
                          ),
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
      ),
    );
  }
}
