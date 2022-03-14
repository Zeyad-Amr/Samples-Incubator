import 'package:flutter/material.dart';

import '../utils.dart';

class DevelopersScreen extends StatelessWidget {
  const DevelopersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Image.asset("assets/logo.png")),
          Text(
            'Akwa Mix',
            style: optionStyle,
          ),
        ],
      ),
    );
  }
}
