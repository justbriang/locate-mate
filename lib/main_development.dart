import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_space/app/app.dart';
import 'package:on_space/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  await bootstrap(() => const App());
}
