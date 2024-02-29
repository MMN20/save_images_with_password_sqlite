// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:save_images_with_password_sqlite/data/db_helper.dart';

class Photo {
  int id;
  String imageName;
  String image;
  int folderId;

  Photo({
    required this.id,
    required this.imageName,
    required this.image,
    required this.folderId,
  });

  Future<void> insertImage() async {
    id = await DBHelper.insert(
        'insert into images (imageName, image, folderId) values (?,?,?)',
        [imageName, image, folderId]);
  }

  Future<bool> updateImage() async {
    bool res = await DBHelper.update(
        'update images set  imageName = ? where id = ?', [imageName, id]);
    return res;
  }

  static Future<bool> deleteImage(int imageID) async {
    bool res =
        await DBHelper.delete('delete from images where id = ?', [imageID]);
    return res;
  }

  static Future<List<Photo>> getAllImagesOfFolder(int folderID) async {
    List<Photo> images = [];
    List<Map<String, dynamic>> maps = await DBHelper.select(
        'select * from images where folderId = ?', [folderID]);
    for (var map in maps) {
      images.add(Photo(
          id: map['id'],
          imageName: map['imageName'],
          image: map['image'],
          folderId: map['folderId']));
    }
    return images;
  }

  static Future<Photo?> getTheFirstImageOfFolder(int folderID) async {
    Photo? image;
    List<Map<String, dynamic>> map = await DBHelper.select(
        'select * from images where folderId = ? LIMIT 1', [folderID]);

    if (map.length == 1) {
      image = Photo(
        id: map[0]['id'],
        imageName: map[0]['imageName'],
        image: map[0]['image'],
        folderId: map[0]['folderId'],
      );
    }
    return image;
  }
}
