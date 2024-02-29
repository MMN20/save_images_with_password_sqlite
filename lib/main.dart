import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_images_with_password_sqlite/data/db_helper.dart';
import 'package:save_images_with_password_sqlite/models/password.dart';
import 'package:save_images_with_password_sqlite/providers/folder_provider.dart';
import 'package:save_images_with_password_sqlite/screens/home_screen.dart';
import 'package:save_images_with_password_sqlite/screens/password_screen.dart';
import 'package:save_images_with_password_sqlite/widgets/my_text_field.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.initalDB();
  await Password.initPassword();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => FolderProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(useMaterial3: true),
        home: const PasswordScreen(),
      ),
    );
  }
}
