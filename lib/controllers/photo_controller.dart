import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoController {
  Future<String?> getIDProofURL(int filename, bool front) async {
    final storage = Supabase.instance.client.storage.from('');
    final response = await storage.createSignedUrl(
      front ? 'doc/front/${filename}.jpg' : 'doc/back/${filename}.jpg',
      60,
    );
    print(response);
    return response;
  }

  // Future<bool> uploadProfileImage(File image, int filename) async {
  //   final status = await _compressImage(image, true, filename);
  //   return status;
  // }

  // Future<bool> uploadIDProofImage(File image, int filename) async {
  //   final status = await _compressImage(image, true, filename);
  //   return status;
  // }

  Future<String> compressAndUploadImage(File image) async {
    final result = await FlutterImageCompress.compressWithFile(
      image.path,
      quality: 20,
      rotate: 0,
    );

    if (result != null) {
      // Save the compressed image to a temporary file
      final tempDir = Directory.systemTemp;
      final tempFile = await File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      ).create();
      await tempFile.writeAsBytes(result);
      final status = await _uploadImage(tempFile);
      return status;
    } else {
      return '';
    }
  }

  // Method to upload the image to Supabase
  Future<String> _uploadImage(File image) async {
    if (image == null) return '';

    try {
      final bucketname = 'doc';
      // Create a Supabase Storage instance
      final storage = Supabase.instance.client.storage.from(bucketname);

      // Generate a unique file name (you can use a timestamp or UUID)
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      // final fileName = profilepic
      //     ? '${name}.jpg'
      //     : (front ? 'front/${name}.jpg' : 'back/${name}.jpg');

      // Upload the file to Supabase Storage

      // final response = await supabase.storage
      //     .from(bucketName)
      //     .uploadBinary(
      //       pathInBucket,
      //       fileBytes,
      //       fileOptions: const FileOptions(upsert: true), // This enables overwrite
      //     );
      // final response = await storage.upload(fileName, image!);
      final response = await storage.upload(
        fileName,
        image!,
        fileOptions: FileOptions(upsert: true),
      );
      print(response.length);
      return fileName;
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }
}
