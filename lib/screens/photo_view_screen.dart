import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:save_images_with_password_sqlite/models/photo.dart';

class PhotoViewScreen extends StatefulWidget {
  const PhotoViewScreen(
      {super.key,
      required this.photos,
      required this.index,
      required this.images});
  final List<Photo> photos;
  final List<Image> images;
  final int index;
  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late PageController _pageController;

  //! make current photo and total photos
  late int currentPhoto;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    currentPhoto = widget.index + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('$currentPhoto/${widget.photos.length}'),
        automaticallyImplyLeading: true,
      ),
      body: PageView.builder(
          onPageChanged: (page) {
            currentPhoto = page + 1;
            setState(() {});
          },
          controller: _pageController,
          itemCount: widget.photos.length,
          itemBuilder: (context, index) {
            return widget.images[index];
          }),
    );
  }
}
