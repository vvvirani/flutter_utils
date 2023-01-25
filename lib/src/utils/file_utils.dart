import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FileUtils {
  FileUtils._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage(ImageSource source) async {
    XFile? xFile = await _picker.pickImage(source: source);
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  }

  static Future<File?> pickVideo(ImageSource source) async {
    XFile? xFile = await _picker.pickVideo(source: source);
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  }

  static Future<List<File>> pickMultiImage() async {
    List<XFile> xFiles = await _picker.pickMultiImage();
    return xFiles.map((e) => File(e.path)).toList();
  }
}
