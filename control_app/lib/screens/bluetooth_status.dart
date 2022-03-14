import 'package:flutter/material.dart';

class BluetoothStatus extends StatefulWidget {
  BluetoothStatus({Key key}) : super(key: key);

  @override
  State<BluetoothStatus> createState() => _BluetoothStatusState();
}

class _BluetoothStatusState extends State<BluetoothStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.grey[900],
        child: Center(
          child: Icon(
            Icons.bluetooth_disabled,
            size: MediaQuery.of(context).size.width * 0.7,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
