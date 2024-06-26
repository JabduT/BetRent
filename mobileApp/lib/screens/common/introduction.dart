import 'package:flutter/material.dart';
import 'package:owner_app/themes/colors.dart';
class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int _currentIndex = 0;
  final List<String> imagePaths = [
    'assets/images/homeA1.jpg',
    'assets/images/location.jpg',
    'assets/images/girl.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          setState(() {
            _currentIndex =
                (_currentIndex - 1).clamp(0, imagePaths.length - 1);
          });
        } else if (details.primaryVelocity! < 0) {
          setState(() {
            _currentIndex =
                (_currentIndex + 1).clamp(0, imagePaths.length - 1);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (_currentIndex < 2)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                
                child: Text(
                  'Skip',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primaryColor),
                ),
              ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Container(
              child: Image.asset(
                imagePaths[_currentIndex],
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentIndex == 0
                            ? 'Welcome\n to the BetRent app'
                            : _currentIndex == 1
                                ? 'Easily find houses'
                                : 'Start today',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _currentIndex == 0
                            ? 'Discover the best rental options in your area.'
                            : _currentIndex == 1
                                ? 'Browse through a wide range of properties.'
                                : 'Get started and find your ideal home.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imagePaths.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: CircleAvatar(
                    backgroundColor:
                        _currentIndex == index ? Colors.blue : Colors.grey,
                    radius: 6,
                  ),
                ),
              ),
            ),
            if (_currentIndex == imagePaths.length - 1) SizedBox(height: 20),
            if (_currentIndex == imagePaths.length - 1)
              ElevatedButton(
                onPressed: () {
Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Start',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
