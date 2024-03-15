import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: non_constant_identifier_names
PickImage(ImageSource source) async {
  final ImagePicker _imagepick = ImagePicker();

  XFile? _file = await _imagepick.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image selected');
}

// ignore: non_constant_identifier_names
ShowSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
