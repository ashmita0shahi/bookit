import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class SensorManager {
  static final SensorManager _instance = SensorManager._internal();
  factory SensorManager() => _instance;
  SensorManager._internal();

  final StreamController<GyroscopeEvent> _gyroscopeStreamController =
      StreamController.broadcast();
  final StreamController<AccelerometerEvent> _accelerometerStreamController =
      StreamController.broadcast();

  Stream<GyroscopeEvent> get gyroscopeStream =>
      _gyroscopeStreamController.stream;
  Stream<AccelerometerEvent> get accelerometerStream =>
      _accelerometerStreamController.stream;

  void startListening() {
    gyroscopeEvents.listen((event) {
      _gyroscopeStreamController.add(event);
    });

    accelerometerEvents.listen((event) {
      _accelerometerStreamController.add(event);
    });
  }

  void dispose() {
    _gyroscopeStreamController.close();
    _accelerometerStreamController.close();
  }
}
