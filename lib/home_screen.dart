import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:thinkedln_mobile/api_service.dart';
import 'package:thinkedln_mobile/media_screen.dart';
import 'dart:io';
import 'camera_screen_controller.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> playVideo(String videoPath) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  // If permission is granted, use the videoPath to play the video with the VideoPlayerController
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _selectedImagePath = ''; // Initialize with empty string
  late String _selectedVideoPath = ''; // Initialize with empty string
  late VideoPlayerController _controller;
  late Future<void> _video;
  late final TextEditingController _textEditingController = TextEditingController(); // Declare TextEditingController
  late String _enteredText = ''; // Variable to store the entered text
  final _post = Post(image: '', context: ''); // Create an instance of the Post class

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(_selectedVideoPath));
    _video = _controller.initialize();
  }

  void _sendImageToAPI(XFile imageFile) async {
    try {
      // Convert XFile to File
      File file = File(imageFile.path);

      // Compress and encode the image
      final compressedImageFile =
          await _post.compressAndEncodeImage(file);

      // Replace 'your-api-url' with the actual API endpoint URL
      var apiUrl = Uri.parse('https://anonymaskedcoder.pythonanywhere.com/upload');

      // Create a multipart request
      var request = http.MultipartRequest('POST', apiUrl);

      // Attach the compressed image file to the request
      request.files.add(await http.MultipartFile.fromPath(
          'image', compressedImageFile!.path)); // Use null-aware operator to avoid null error

      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double imageHeight = screenHeight * 0.62; // 55% of screen height

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'socialAll',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pacifico',
          )
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Display selected image
          if (_selectedImagePath.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: imageHeight,
                child: Image.file(
                  File(_selectedImagePath),
                  fit: BoxFit.cover, // Fill the available space while maintaining aspect ratio
                ),
              ),
            ),
          if (_selectedVideoPath.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: imageHeight,
                child: FutureBuilder(
                  future: _video,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return VideoPlayer(_controller);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 160.0, // Adjust the position as needed
              left: 16.0, // Adjust the position as needed
              right: 16.0, // Adjust the position as needed
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () => _showTextFieldPopup(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
                    child: Text(
                      'Add context',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                )
              ),
            ),
          // Your main content here
          Positioned(
            left: 0,
            right: 0,
            bottom: 100, // Adjust the position as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _showDialog(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                    child: Text(
                      'Button 1',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const MediaScreen()); // Navigate to MediaScreen();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                    child: Text(
                      'Button 3',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.white, // Background color for the buttons
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Check if _selectedImagePath and _enteredText are not empty or null
                      if (_selectedImagePath.isNotEmpty && _enteredText.isNotEmpty) {
                        // Create a Post object with the entered text and selected image
                        var post = Post(
                          image: _selectedImagePath,
                          context: _enteredText,
                        );

                        // Compress and encode the image
                        var compressedImageFile = await _post.compressAndEncodeImage(File(_selectedImagePath));
                        
                        // Check if compressedImageFile is not null before sending to API
                        if (compressedImageFile != null) {
                          // Send the compressed image to the API
                          _sendImageToAPI(compressedImageFile as XFile);
                          
                          // Call the postData method to make the POST request
                          post.postData(post);
                        } else {
                          print('Error compressing image');
                        }
                      } else {
                        print('Please select an image and add context');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      child: Text(
                        'Generate',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      child: Text(
                        'View',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final CameraScreenController controller = Get.put(CameraScreenController());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await controller.pickImagefromCamera();
                  setState(() {
                    _selectedImagePath = controller.selectedImagePath.value;
                  });
                  Navigator.pop(context); // Close dialog
                  // Call a method to send the image to the API
                  _sendImageToAPI(File(controller.selectedImagePath.value) as XFile);
                },
                child: const Text('Take Photo'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.pickImagefromGallery();
                  setState(() {
                    _selectedImagePath = controller.selectedImagePath.value;
                  });
                  Navigator.pop(context); // Close dialog
                  // Call a method to send the image to the API
                  _sendImageToAPI(File(controller.selectedImagePath.value) as XFile);
                },
                child: const Text('Upload Photo'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialog2(BuildContext context) {
    final CameraScreenController controller = Get.put(CameraScreenController());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final videoPlayerController = VideoPlayerController.file(File(controller.selectedImagePath.value));
        if (controller.selectedImagePath.value != null) {
          final videoPlayerController = VideoPlayerController.file(File(controller.selectedImagePath.value));
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await controller.pickVideofromCamera();
                    videoPlayerController.initialize().then((_) {
                      setState(() {});
                    });
                    setState(() {
                      _selectedVideoPath = controller.selectedImagePath.value;
                    });
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Text('Take Video'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await controller.pickVideofromGallery();
                    videoPlayerController.initialize().then((_) {
                      setState(() {});
                    });
                    setState(() {
                      _selectedVideoPath = controller.selectedImagePath.value;
                    });
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Text('Upload Video'),
                ),
              ],
            ),
          );
        } 
        else {
            print('Please select a video first');
            return AlertDialog(
            content: const Text('Please select a video first'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
            );
        }
      },
    );
  }

  void _showTextFieldPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog on outside tap
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // Close dialog when tapped outside
            Navigator.of(context).pop();
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _textEditingController,
                    maxLines: null, // Allow multiple lines of text
                    onChanged: (value) {
                      // Update _enteredText variable whenever text changes
                      setState(() {
                        _enteredText = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your text here',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Close dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}