import 'dart:convert';
import 'dart:typed_data';

import 'package:control_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:control_app/Screens/automatic.dart';
import 'package:control_app/Screens/developers.dart';
import 'package:control_app/Screens/manual.dart';
import 'package:control_app/Screens/settings.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final BluetoothDevice server;

  const Home({Key key, @required this.server}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  BluetoothConnection connection;
  static List<Widget> _widgetOptions = <Widget>[
    AutomaticScreen(),
    ManualScreen(),
    SettingsScreen(),
    DevelopersScreen(),
  ];

  /// Start Bluetooth Connection implementation

  String prevString = '';

  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  String level = '0.0';

  List<String> dataList = [];
  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onData((data) {
        // Allocate buffer for parsed data
        int backspacesCounter = 0;
        data.forEach((byte) {
          if (byte == 8 || byte == 127) {
            backspacesCounter++;
          }
        });
        Uint8List buffer = Uint8List(data.length - backspacesCounter);
        int bufferIndex = buffer.length;

        // Apply backspace control character
        backspacesCounter = 0;
        for (int i = data.length - 1; i >= 0; i--) {
          if (data[i] == 8 || data[i] == 127) {
            backspacesCounter++;
          } else {
            if (backspacesCounter > 0) {
              backspacesCounter--;
            } else {
              buffer[--bufferIndex] = data[i];
            }
          }
        }
        // Create message if there is new line character
        String dataString = String.fromCharCodes(buffer);
        dataList.add(dataString);

        print('data ${dataList.join().split(",").last}');
        try {
          String x = dataList.join().split(",").last;
          double.parse(x);

          level = x;
        } catch (e) {
          // level = '00.0';
        }

        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
      setState(() {});
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    setState(() {});
  }

  //////////////////////////////////

  String startValidator(String val) {
    return int.tryParse(val) != null
        ? int.tryParse(val) > 0
            ? endVal.toInt() < startVal.toInt()
                ? 'Minimun temperature should be less Maximum'
                : null
            : 'Minimun temperature should be more than 0 C°'
        : 'Minimun temperature should be more than 0 C°';
  }

  String endValidator(String val) {
    return int.tryParse(val) != null
        ? int.tryParse(val) < 75
            ? endVal.toInt() < startVal.toInt()
                ? 'Minimun temperature should be less Maximum'
                : null
            : 'Minimun temperature should be less than 75 C°'
        : 'Minimun temperature should be less than 75 C°';
  }

  bool edit = false;
  int startVal;
  int endVal;
  final formGlobalKey = GlobalKey<FormState>();

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
    var myProv = Provider.of<Myprovider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 20,
        title: const Text('Sample Incubator'),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
        actions: [
          Consumer<Myprovider>(
            builder: (context, value, child) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.thermostat,
                      color: double.parse(level.trim()) < value.start
                          ? Colors.blueAccent
                          : double.parse(level.trim()) > value.end
                              ? Colors.red
                              : Colors.green),
                  Text(
                    level.trim() + ' C°',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                ],
              )),
            ),
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              backgroundColor: Colors.grey[900],
              rippleColor: Colors.grey[300],
              hoverColor: Colors.grey[500],
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              curve: Curves.easeInCubic,
              tabBackgroundGradient: LinearGradient(
                  colors: [Colors.deepPurple[900], Colors.blueAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.7, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 500),
              color: Colors.white,
              tabs: [
                GButton(
                  icon: Icons.thermostat_auto_rounded,
                  text: 'Automatic',
                ),
                GButton(
                  icon: Icons.thermostat,
                  text: 'Manual',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
                GButton(
                  icon: Icons.developer_mode_rounded,
                  text: 'Developers',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                myProv.connection = connection;
                myProv.status = double.parse(level.trim()) < myProv.start
                    ? 1
                    : double.parse(level.trim()) > myProv.end
                        ? 3
                        : 2;
                if (index == 0) {
                  _sendMessage('200', connection);
                } else if (index == 1) {
                  _sendMessage('300', connection);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
