import 'dart:async';

import 'package:bm5500_flutter_plugin/bm5500_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? message;
  String? closeMessage;
  String? captureMessage;
  final _bm5500FlutterPlugin = Bm5500FlutterPlugin();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  _requestPermissions()async{
     await Future.wait([
      Permission.manageExternalStorage.request(),
      Permission.accessMediaLocation.request(),
      Permission.storage.request(),
    ]);

  }

  Future<void> openDevice() async {
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      result =
          await _bm5500FlutterPlugin.openDevice() ?? 'Unknown platform version';
    } on PlatformException {
      result = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      message = result;
    });
  }

  Future<void> closeDevice() async {
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      result = await _bm5500FlutterPlugin.closeDevice() ?? 'Unknown';
    } on PlatformException {
      result = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      closeMessage = result;
    });
  }

  Future<void> captureFingerprint() async {
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      result = await _bm5500FlutterPlugin.captureFingerprint() ?? 'Unknown';
    } on PlatformException {
      result = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      captureMessage = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  PrimaryButton(
                    title: message ?? "Open Device",
                    onTap: () async {
                      await openDevice();
                    },
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    title: closeMessage ?? "Close Device",
                    onTap: () async {
                      await closeDevice();
                    },
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    title: captureMessage ?? "capture fingerprint",
                    onTap: () async {
                      await captureFingerprint();
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, this.onTap, required this.title})
      : super(key: key);
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        //height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        child: Text(
          title,
          style:
              Theme.of(context).textTheme.button?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
