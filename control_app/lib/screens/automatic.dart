import 'package:control_app/provider/provider.dart';
import 'package:control_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutomaticScreen extends StatefulWidget {
  const AutomaticScreen({Key key}) : super(key: key);

  @override
  State<AutomaticScreen> createState() => _AutomaticScreenState();
}

class _AutomaticScreenState extends State<AutomaticScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Consumer<Myprovider>(
            builder: (context, value, child) => Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: value.status == 1
                      ? Image.asset('assets/fire.png')
                      : value.status == 3
                          ? Image.asset('assets/snow.png')
                          : Image.asset('assets/fine.png'),
                )));
  }
}
