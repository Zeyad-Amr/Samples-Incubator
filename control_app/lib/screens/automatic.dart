import 'package:control_app/utils.dart';
import 'package:flutter/material.dart';

class AutomaticScreen extends StatefulWidget {
  const AutomaticScreen({Key key}) : super(key: key);

  @override
  State<AutomaticScreen> createState() => _AutomaticScreenState();
}

class _AutomaticScreenState extends State<AutomaticScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Automatic",
        style: optionStyle,
      ),
    );
  }
}
