import 'package:flutter/material.dart';
import 'package:save_images_with_password_sqlite/widgets/my_text_field.dart';

class AddFolderDialog extends StatefulWidget {
  const AddFolderDialog({super.key, required this.addFolder});
  final void Function(String) addFolder;
  @override
  State<AddFolderDialog> createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  void addFolder() {
    if (_nameController.text != '') {
      widget.addFolder(_nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  controller: _nameController,
                  hintText: 'Folder name',
                ),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  minWidth: double.infinity,
                  onPressed: addFolder,
                  child: const Text('Add Button'),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
