import 'package:flutter/material.dart';
import 'package:owner_app/screens/common/messaging.dart';

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/screen4');
        },
        child: Text('Go to Screen 4'),
      ),
    );
  }
}
