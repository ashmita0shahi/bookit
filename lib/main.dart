import 'package:bookit/app/app.dart';
import 'package:flutter/material.dart';

import 'app/di/di.dart';
import 'core/network/hive_service.dart';
import 'core/sensor/sensor_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  // Initialize dependencies (including Hive)
  await initDependencies();
  SensorManager().startListening();

  runApp(
    const MyApp(),
  );
}
