import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:save_images_with_password_sqlite/models/folder.dart';

class FolderWidget extends StatelessWidget {
  const FolderWidget({super.key, required this.folder});
  final Folder folder;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: size.height * 0.25,
        child: Stack(
          children: [
            folder.firstImage != null
                ? Image.memory(
                    base64Decode(folder.firstImage!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Container(
                    color: Colors.grey[800],
                  ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 25,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.2),
                    ],
                    tileMode: TileMode.decal,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Center(child: Text(folder.folderName)),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Icon(
                Icons.folder_rounded,
              ),
            )
          ],
        ),
      ),
    );
  }
}
