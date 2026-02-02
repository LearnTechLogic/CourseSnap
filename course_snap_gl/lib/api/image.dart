import 'package:course_snap_gl/constants/index.dart';
import 'package:course_snap_gl/utils/DioRequest.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<String> postImageAPI(XFile image, int account, int imageNum) async {
  MultipartFile file;
  if (kIsWeb) {
    final Uint8List imageBytes = await image.readAsBytes();
    file = MultipartFile.fromBytes(imageBytes, filename: image.name);
  } else {
    file = await MultipartFile.fromFile(image.path);
  }
  FormData formData = FormData.fromMap({
    "userAccount": account,
    "imageNum": imageNum,
    "image": file,
  });
  return await dioRequest.postImage(HttpConstants.IMAGE_POST, formData);
}