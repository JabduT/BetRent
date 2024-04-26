import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int _currentIndex = 0;
  final List<String> imagePaths = [
    'assets/images/homeA1.jpg',
    'assets/images/girl.jpg',
    'assets/images/location.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (_currentIndex < imagePaths.length - 1) {
                  _currentIndex++;
                }
              });
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              imagePaths[_currentIndex],
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              _currentIndex == 0
                  ? 'Welcome to the BetRent app'
                  : _currentIndex == 1
                      ? 'Easily find houses'
                      : 'Start today',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (_currentIndex == imagePaths.length - 1)
            ElevatedButton(
              onPressed: () {
                // Handle start button press
              },
              child: Text('Start'),
            ),
        ],
      ),
    );
  }
}
