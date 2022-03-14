import 'package:control_app/utils.dart';
import 'package:flutter/material.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({Key key}) : super(key: key);

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Cool'),
          style: ElevatedButton.styleFrom(primary: Colors.grey[900]),
        )
      ],
    );
  }
}
