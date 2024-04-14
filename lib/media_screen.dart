import 'package:flutter/material.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  int _selectedIndex = -1; // Index of the selected item
  final List<String> _names = ['Linkedln', 'Twitter', 'Discord', 'Instagram', 'Facebook', 'Reddit',
    'Pinterest','Youtube','TikTok']; // List of item names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            _names.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index; // Update the selected index
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: _selectedIndex == index ? Colors.blue : Colors.transparent,
                    width: 2.0,
                  ),
                  color: _selectedIndex == index ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      _names[index],
                      style: TextStyle(
                        fontSize: 18.0,
                        color: _selectedIndex == index ? Colors.blue : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
