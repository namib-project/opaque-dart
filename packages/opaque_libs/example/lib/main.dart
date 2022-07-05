import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:opaque_libs/opaque_libs.dart';
import 'package:opaque/opaque.ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String? errorMessage;
  final _opaqueLibsPlugin = OpaqueLibs();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _opaqueLibsPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      final opaque = Opaque.init();
      opaque.CreateCredentialRequest(Uint8List.fromList([1,2,3,4,5]));
    } catch (e) {
      errorMessage = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            Row(children: [
              const Text("OPAQUE status: "),
              if (errorMessage == null)
                const Text("Success!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green))
              else
                Flexible(child: Text("Failure!\n($errorMessage)",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)))
            ])
          ],
        )),
      ),
    );
  }
}
