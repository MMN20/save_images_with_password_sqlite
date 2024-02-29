import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_images_with_password_sqlite/models/folder.dart';

class FolderProvider extends ChangeNotifier {
  List<Folder> folders = [];

  void refreshFolder() async {
    folders.clear();
    folders = await Folder.getAllFolders();
    notifyListeners();
  }

  FolderProvider() {
    refreshFolder();
  }
}
