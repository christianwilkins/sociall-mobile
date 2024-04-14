import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CameraScreenController extends GetxController {
  File? _selectedImage;
  var selectedImagePath = ''.obs;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImagefromGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final File image = File(pickedImage.path!);
      final String compressedImagePath = await compressImage(image);
      _selectedImage = File(compressedImagePath);
      selectedImagePath.value = compressedImagePath;
    } else {
      // Handle case where no image is selected
      print('No image selected.');
    }
  }

  Future<void> pickImagefromCamera() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final File image = File(pickedImage.path!);
      final String compressedImagePath = await compressImage(image);
      _selectedImage = File(compressedImagePath);
      selectedImagePath.value = compressedImagePath;
    } else {
      // Handle case where no image is selected
      print('No image selected.');
    }
  }

  Future<String> compressImage(File image) async {
    final List<int> compressedBytes = (await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      quality: 50, // Adjust compression quality as needed
    )) as List<int>;
    final compressedFile = File('${image.path}_compressed.jpg');
    await compressedFile.writeAsBytes(compressedBytes);
    return compressedFile.path;
  }

  Future<void> pickVideofromCamera() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.camera);

    if (pickedVideo != null) {
      final File image = File(pickedVideo.path!);
      //final String compressedImagePath = await compressImage(image);
      //_selectedImage = File(compressedImagePath);
      //selectedImagePath.value = compressedImagePath;
    } else {
      // Handle case where no image is selected
      print('No image selected.');
    }
  }

  Future<void> pickVideofromGallery() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      final File image = File(pickedVideo.path!);
      //final String compressedImagePath = await compressImage(image);
      //_selectedImage = File(compressedImagePath);
      //selectedImagePath.value = compressedImagePath;
    } else {
      // Handle case where no image is selected
      print('No image selected.');
    }
  }
}
