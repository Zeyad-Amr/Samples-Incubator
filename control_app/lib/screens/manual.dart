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
        children: [
          Consumer<Myprovider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                _sendMessage('301', value.connection);
              },
              child: Text('COOLER ON'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[900],
              ),
            ),
          ),
          Consumer<Myprovider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                _sendMessage('302', value.connection);
              },
              child: Text('HEATER ON'),
              style: ElevatedButton.styleFrom(primary: Colors.grey[900]),
            ),
          ),
          Consumer<Myprovider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                _sendMessage('303', value.connection);
              },
              child: Text('COOLER & COOLER ON'),
              style: ElevatedButton.styleFrom(primary: Colors.grey[900]),
            ),
          )
        ],
      ),
    );
  }
}
