import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Myprovider extends ChangeNotifier {
  int _start = 0;
  int _end = 0;
  int _status = 0;

  BluetoothConnection _connection;

  get connection => this._connection;

  set connection(value) {
    this._connection = value;
    notifyListeners();
  }

  int get start => this._start;

  set start(int value) {
    this._start = value;
    notifyListeners();
  }

  get end => this._end;

  set end(value) {
    this._end = value;
    notifyListeners();
  }

  get status => this._status;

  set status(value) {
    this._status = value;
    notifyListeners();
  }
}
