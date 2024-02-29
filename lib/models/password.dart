import 'package:save_images_with_password_sqlite/data/db_helper.dart';

class Password {
  static String? password;

  static Future<void> initPassword() async {
    List<Map<String, dynamic>> map =
        await DBHelper.select('select * from password');
    if (map.length == 0) {
      return;
    }
    password = map[0]['password'];
  }

  static Future<void> setUpThePasswordForFirstTime() async {
    await DBHelper.insert(
        'insert into password (password) values (?)', [password]);
  }

  static Future<void> updatePassword() async {
    await DBHelper.insert('update password set password = ?', [password]);
  }
}
