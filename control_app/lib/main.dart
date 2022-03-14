import 'package:control_app/screens/bluetooth_status.dart';
import 'package:control_app/screens/connection_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample Incubator',
      theme: ThemeData(
        primaryColor: Colors.grey[900],
      ),
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            SplashScreenView(
              navigateRoute: Services(),
              duration: 4000,
              imageSize: 250,
              imageSrc: "assets/logo.png",
              text: 'Sample Incubator',
              textType: TextType.TyperAnimatedText,
              textStyle: TextStyle(
                fontSize: 30.0,
              ),
              backgroundColor: Colors.white,
            ),
            Positioned(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Powered by Akwa Mix'),
                  Text('Team 16'),
                ],
              ),
              bottom: 50,
            )
          ],
        ),
      ),
    );
  }
}

class Services extends StatelessWidget {
  const Services({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FlutterBluetoothSerial.instance.requestEnable(),
      builder: (context, future) {
        if (future.connectionState == ConnectionState.waiting) {
          return BluetoothStatus();
        } else {
          return ConnectionRoute();
        }
      },
    );
  }
}
