import 'dart:convert';

import 'package:control_app/provider/provider.dart';
import 'package:control_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({Key key}) : super(key: key);

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.blue,
    Colors.grey[900]
  ];
  int isPressed = 0;
  void _sendMessage(String text, connection) async {
    text = text.trim();
    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      } catch (e) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<Myprovider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                _sendMessage('301', value.connection);
                setState(() {
                  isPressed = 3;
                });
              },
              child: Text('COOLING'),
              style: ElevatedButton.styleFrom(
                  primary: isPressed == 3 ? Colors.blueAccent[700] : colors[3],
                  shape: CircleBorder(),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                      MediaQuery.of(context).size.width * 0.3)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          Consumer<Myprovider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                _sendMessage('302', value.connection);
                setState(() {
                  isPressed = 1;
                });
              },
              child: Text('HEATING'),
              style: ElevatedButton.styleFrom(
                  primary: isPressed == 1 ? Colors.red : colors[3],
                  shape: CircleBorder(),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                      MediaQuery.of(context).size.width * 0.3)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          Consumer<Myprovider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                _sendMessage('303', value.connection);
                setState(() {
                  isPressed = 2;
                });
              },
              child: Text('COOLING &\n HEATING'),
              style: ElevatedButton.styleFrom(
                primary: isPressed == 2 ? Colors.orange : colors[3],
                shape: CircleBorder(),
                fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                    MediaQuery.of(context).size.width * 0.3),
              ),
            ),
          )
        ],
      ),
    );
  }
}
