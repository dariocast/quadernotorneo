import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

final playerImages = [
  Image.asset('assets/images/gk.png'),
  Image.asset('assets/images/defender.png'),
  Image.asset('assets/images/fullback.png'),
  Image.asset('assets/images/wings.png'),
  Image.asset('assets/images/striker.png'),
];

Future<File?> cropImage(BuildContext context, String activityTitle,
    File imageFile, CropAspectRatio ratio) async {
  CroppedFile? croppedFile = await ImageCropper()
      .cropImage(sourcePath: imageFile.path, aspectRatio: ratio, uiSettings: [
    AndroidUiSettings(
      toolbarTitle: activityTitle,
      toolbarColor: Theme.of(context).primaryColor,
      toolbarWidgetColor: Colors.white,
      activeControlsWidgetColor: Theme.of(context).colorScheme.secondary,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: true,
    ),
    IOSUiSettings(
      title: activityTitle,
      aspectRatioLockEnabled: true,
    ),
  ]);
  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    return null;
  }
}
