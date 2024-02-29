import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_images_with_password_sqlite/models/folder.dart';
import 'package:save_images_with_password_sqlite/providers/folder_provider.dart';
import 'package:save_images_with_password_sqlite/screens/folder_screen.dart';
import 'package:save_images_with_password_sqlite/screens/update_password_screen.dart';
import 'package:save_images_with_password_sqlite/widgets/add_folder_dialog.dart';
import 'package:save_images_with_password_sqlite/widgets/folder_widget.dart';
import 'package:save_images_with_password_sqlite/widgets/my_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  void refreshFolder() async {
    Provider.of<FolderProvider>(context, listen: false).refreshFolder();
  }

  void addFolder(String folderName) async {
    Folder folder = Folder(folderName: folderName, id: 0);
    await folder.insertFolder();
    Navigator.pop(context);
    Provider.of<FolderProvider>(context, listen: false).refreshFolder();
  }

  void showAddFolderDialog() {
    showDialog(
      context: context,
      builder: (c) => AddFolderDialog(
        addFolder: addFolder,
      ),
    );
  }

  void onTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => FolderScreen(
          folder: Provider.of<FolderProvider>(context, listen: false)
              .folders[index],
        ),
      ),
    );
  }

  void deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (c) => SimpleDialog(
              title: const Center(
                child: Text(
                  'Deleting this folder will also delete all its images, Are you sure?',
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Folder folder = Provider.of<FolderProvider>(context,
                                  listen: false)
                              .folders[index];
                          await Folder.deleteFolder(folder.id);
                          Provider.of<FolderProvider>(context, listen: false)
                              .folders
                              .remove(folder);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text(
                          'Delete',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  void renameDialog(int index) {
    showDialog(
        context: context,
        builder: (c) => SimpleDialog(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      MyTextField(
                        hintText: 'New name',
                        controller: _nameController,
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_nameController.text != '') {
                            Folder folder = Provider.of<FolderProvider>(context,
                                    listen: false)
                                .folders[index];
                            folder.folderName = _nameController.text;
                            await folder.updateFolder();
                            Navigator.pop(context);
                            setState(() {});
                          }
                        },
                        child: const Text(
                          'Rename',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  void showDeleteRenameDialog(int index) async {
    showDialog(
        context: context,
        builder: (c) => SimpleDialog(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteDialog(index);
                  },
                  child: const Text(
                    'Delete',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    renameDialog(index);
                  },
                  child: const Text(
                    'Rename',
                  ),
                ),
              ],
            ));
  }

  void onLognPress(int index) {
    showDeleteRenameDialog(index);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FolderProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAddFolderDialog,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const UpdatePasswordScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount:
            Provider.of<FolderProvider>(context, listen: false).folders.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              onTap(index);
            },
            onLongPress: () {
              onLognPress(index);
            },
            child: FolderWidget(
              folder: Provider.of<FolderProvider>(context, listen: false)
                  .folders[index],
            ),
          );
        },
      ),
    );
  }
}
