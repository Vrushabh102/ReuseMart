import 'dart:developer';

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  ImagePicker picker = ImagePicker();
  XFile? file = await picker.pickImage(source: source);
  if (file != null) {
    return file.readAsBytes();
  }
  log('Image not selected');
}
