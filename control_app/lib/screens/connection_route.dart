import 'dart:async';
import 'package:animated_background/animated_background.dart';
import 'package:control_app/widgets/bluetoothEntryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class ConnectionRoute extends StatefulWidget {
  final bool checkAvailability = true;

  @override
  _ConnectionRoute createState() => new _ConnectionRoute();
}

class _ConnectionRoute extends State<ConnectionRoute>
    with TickerProviderStateMixin {
  List<_DeviceWithAvailability> devices = [];

  // Availability
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  bool _isDiscovering;

  _ConnectionRoute();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                device,
                widget.checkAvailability
                    ? _DeviceAvailability.maybe
                    : _DeviceAvailability.yes,
              ),
            )
            .toList();
      });
    });
  }

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.yes;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    _discoveryStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices.map(
      (_device) {
        if (_device.device.name == 'HC-05') {
          return BluetoothDeviceListEntry(
            device: _device.device,
          );
        }
      },
    ).toList();
    return Scaffold(
        body: AnimatedBackground(
      behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
        baseColor: Colors.grey[900],
        spawnOpacity: 0.0,
        opacityChangeRate: 0.25,
        minOpacity: 0.1,
        maxOpacity: 0.4,
        spawnMinSpeed: 50.0,
        spawnMaxSpeed: 120.0,
        spawnMinRadius: 7.0,
        spawnMaxRadius: 10.0,
        particleCount: 100,
      )),
      vsync: this,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: list
              .where((element) =>
                  element != null ? element.device.name == 'HC-05' : false)
              .toList(),
        ),
      ),
    ));
  }
}
