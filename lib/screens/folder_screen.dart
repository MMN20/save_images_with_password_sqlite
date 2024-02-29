import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_images_with_password_sqlite/models/folder.dart';
import 'package:save_images_with_password_sqlite/models/photo.dart';
import 'package:save_images_with_password_sqlite/providers/folder_provider.dart';
import 'package:save_images_with_password_sqlite/screens/photo_view_screen.dart';
import 'package:save_images_with_password_sqlite/widgets/add_photo_dialog.dart';
import 'package:save_images_with_password_sqlite/widgets/my_text_field.dart';
import 'package:save_images_with_password_sqlite/widgets/photo_widget.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key, required this.folder});
  final Folder folder;
  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  List<Photo> photos = [];
  List<Image> images = [];
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initAllPhotos();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  void initAllPhotos() async {
    photos.clear();
    photos = await Photo.getAllImagesOfFolder(widget.folder.id);
    for (var photo in photos) {
      images.add(Image.memory(base64Decode(photo.image)));
    }
    setState(() {});
  }

  // I used this because I dont want to fetch all photos again from the database
  void updatePhotosWithTheAddedPhoto(Photo photo) {
    photos.add(photo);
    images.add(Image.memory(base64Decode(photo.image)));
    Provider.of<FolderProvider>(context, listen: false).refreshFolder();
    setState(() {});
  }

  void showAddPhotoDialog() {
    showDialog(
      context: context,
      builder: (c) => AddPhotoDialog(
        folder: widget.folder,
        updatePhotos: updatePhotosWithTheAddedPhoto,
      ),
    );
  }

  void deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (c) => SimpleDialog(
              title: const Center(
                  child: Text(
                      'Deleting this folder will also delete all its images, Are you sure?')),
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
                          Photo photo = photos[index];
                          await Folder.deleteFolder(photo.id);
                          photos.remove(photo);
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
                      Photo photo = photos[index];
                      photo.imageName = _nameController.text;
                      await photo.updateImage();
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
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPhotoDialog,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(widget.folder.folderName),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: photos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onLongPress: () {
              showDeleteRenameDialog(index);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => PhotoViewScreen(
                    images: images,
                    photos: photos,
                    index: index,
                  ),
                ),
              );
            },
            child: PhotoWidget(
              photo: photos[index],
            ),
          );
        },
      ),
    );
  }
}
