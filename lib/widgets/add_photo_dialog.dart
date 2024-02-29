import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_images_with_password_sqlite/models/folder.dart';
import 'package:save_images_with_password_sqlite/models/photo.dart';
import 'package:save_images_with_password_sqlite/widgets/my_text_field.dart';

class AddPhotoDialog extends StatefulWidget {
  const AddPhotoDialog(
      {super.key, required this.folder, required this.updatePhotos});
  final Folder folder;
  final void Function(Photo photo) updatePhotos;
  @override
  State<AddPhotoDialog> createState() => _AddPhotoDialogState();
}

class _AddPhotoDialogState extends State<AddPhotoDialog> {
  XFile? file;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    file = await picker.pickImage(source: source);
    if (file != null) {
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> saveImageToDB() async {
    Uint8List bytes = await file!.readAsBytes();
    String base64String = base64Encode(bytes);
    Photo photo = Photo(
        id: 0,
        imageName: _nameController.text,
        image: base64String,
        folderId: widget.folder.id);
    await photo.insertImage();
    widget.updatePhotos(photo);
  }

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return SizedBox(
        height: 330,
        child: SingleChildScrollView(
          child: SimpleDialog(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.file(
                      File(
                        file!.path,
                      ),
                      height: 300,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        hintText: 'Image name', controller: _nameController),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            await saveImageToDB();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Ok',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SimpleDialog(
      children: [
        SimpleDialogOption(
          child: const Center(
              child: Text(
            'From gallery',
            style: TextStyle(fontSize: 20),
          )),
          onPressed: () {
            pickImage(ImageSource.gallery);
          },
        ),
        SimpleDialogOption(
          child: const Center(
              child: Text(
            'From camera',
            style: TextStyle(fontSize: 20),
          )),
          onPressed: () async {
            pickImage(ImageSource.camera);
          },
        ),
      ],
    );
  }
}
