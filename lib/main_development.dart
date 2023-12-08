import 'package:flutter/material.dart';
import 'package:on_space/app/app.dart';
import 'package:on_space/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bootstrap(() => const App());
}
