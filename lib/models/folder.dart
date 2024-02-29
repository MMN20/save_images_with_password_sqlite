import 'package:flutter/material.dart';
import 'package:save_images_with_password_sqlite/data/db_helper.dart';
import 'package:save_images_with_password_sqlite/models/photo.dart';

class Folder {
  int id;
  String folderName;
  String? firstImage;

  Folder({required this.folderName, required this.id, this.firstImage});

  Future<bool> insertFolder() async {
    id = await DBHelper.insert(
        'insert into folders (folderName) values (?)', [folderName]);
    return id > 0;
  }

  Future<bool> updateFolder() async {
    bool res = await DBHelper.update(
        'update folders set folderName = ? where id = ?', [folderName, id]);
    return res;
  }

  static Future<bool> deleteFolder(int folderID) async {
    await DBHelper.delete('delete from images where folderId = ?', [folderID]);

    bool res =
        await DBHelper.delete('delete from folders where id = ?', [folderID]);
    return res;
  }

  static Future<List<Folder>> getAllFolders() async {
    List<Folder> folders = [];
    List<Map<String, dynamic>> maps =
        await DBHelper.select('select * from folders');
    for (var map in maps) {
      Photo? firstImage = await Photo.getTheFirstImageOfFolder(map['id']);

      folders.add(
        Folder(
          folderName: map['folderName'],
          id: map['id'],
          firstImage: firstImage?.image,
        ),
      );
    }
    return folders;
  }
}
