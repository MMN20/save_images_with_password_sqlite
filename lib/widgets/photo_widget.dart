import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:save_images_with_password_sqlite/models/folder.dart';
import 'package:save_images_with_password_sqlite/models/photo.dart';

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({super.key, required this.photo});
  final Photo photo;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: size.height * 0.45,
        child: Stack(
          children: [
            Image.memory(
              base64Decode(photo.image),
              width: double.infinity,
              fit: BoxFit.cover,
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
                child: Center(child: Text(photo.imageName)),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Icon(
                Icons.image,
              ),
            )
          ],
        ),
      ),
    );
  }
}
