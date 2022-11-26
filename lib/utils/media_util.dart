import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

import '/models/failure.dart';

class MediaUtil {
  static Future<File?> pickImageFromGallery({
    required CropStyle cropStyle,
    required BuildContext context,
    required String? title,
    int? imageQuality,
  }) async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: imageQuality ?? 70);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        cropStyle: cropStyle,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: title,
            toolbarColor: Colors.grey.shade800,
            //toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings()
        ],
        compressQuality: imageQuality ?? 70,
      );
      // return croppedFile;
      return croppedFile?.path != null ? File(croppedFile!.path) : null;
    }
    return null;
  }

  static Future<File?> pickVideo({required String title}) async {
    try {
      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (error) {
      print('Error in picking image  ${error.toString()}');
      throw const Failure(message: 'Error in picking video');
    }
  }

  static Future<String> uploadProfileImageToStorage(
    String childName,
    Uint8List file,
    bool isPost,
    String uid,
  ) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    // creating location to our firebase storage

    Reference ref = storage.ref().child(childName).child(uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadStoryImageToStorage(
    String childName,
    Uint8List file,
    bool isPost,
    String storyId,
  ) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    // creating location to our firebase storage

    Reference ref = storage.ref().child(childName).child(storyId);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadAdMedia({
    required String childName,
    required File file,
    // bool isVideo = false,
    // required String uid,
  }) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    // creating location to our firebase storage
    String id = const Uuid().v1();
    Reference ref = storage.ref().child(childName).child(id);
    // if (isVideo) {
    //   String id = const Uuid().v1();
    //   ref = ref.child(id);
    // }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File?> compressVideo(File videoFile) async {
    try {
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false, // It's false by default
      );

      if (mediaInfo != null) {
        return mediaInfo.file;
      }
      return null;
    } catch (error) {
      print('Error in compressing video ${error.toString()}');
      await VideoCompress.cancelCompression();
      throw const Failure(message: 'Error in compressing video');
    }
  }
}
