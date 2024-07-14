import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class BaseProvider extends ChangeNotifier {
  File? selectedImage;
  ImagePicker imagePicker = ImagePicker();
  String?
      selectedImageWeb; // To store the base64 or URL of the selected image for web

  Future<void> setImage(ImageSource source) async {
    if (kIsWeb) {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        selectedImageWeb = await pickedImage
            .readAsBytes()
            .then((bytes) => "data:image/png;base64,${base64Encode(bytes)}");
      } else {
        selectedImageWeb = null;
      }
    } else {
      final pickedImage = await imagePicker.pickImage(source: source);
      selectedImage = pickedImage != null ? File(pickedImage.path) : null;
    }
    notifyListeners();
  }
}
