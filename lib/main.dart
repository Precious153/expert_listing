import 'package:flutter/material.dart';
import 'package:expert_listing/app/app.dart';
import 'package:expert_listing/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}
