import 'package:control_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatefulWidget {
  final BluetoothDevice device;

  BluetoothDeviceListEntry({@required this.device});

  @override
  _BluetoothDeviceListEntryState createState() =>
      _BluetoothDeviceListEntryState();
}

class _BluetoothDeviceListEntryState extends State<BluetoothDeviceListEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        child: Text(
          'Connect',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 20,
            primary: Colors.blue[900],
            shape: CircleBorder(),
            padding: EdgeInsets.all(30)),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Home(server: this.widget.device);
              },
            ),
          );
        },
      ),
    );
  }
}
