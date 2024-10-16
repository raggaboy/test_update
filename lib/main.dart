import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:updat/theme/chips/floating_with_silent_download.dart';
import 'package:updat/updat.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Text("hui"),
          ),
          UpdatWidget(
            currentVersion: "1.0.0",
            getLatestVersion: () async {
              // Here you should fetch the latest version. It must be semantic versioning for update detection to work properly.
              return "2.1.0";
            },
            getBinaryUrl: (latestVersion) async {
              // Here you provide the link to the binary the user should download. Make sure it is the correct one for the platform!
              return "https://github.com/raggaboy/test_update/releases/download/2.1.0/test_update.exe";
            },
            // Lastly, enter your app name so we know what to call your files.
            appName: "test_update",
          )
        ],
      ),

      // floatingActionButton: , // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

String get platformExt {
  switch (Platform.operatingSystem) {
    case 'windows':
      {
        return 'msix';
      }

    case 'macos':
      {
        return 'dmg';
      }

    case 'linux':
      {
        return 'AppImage';
      }
    default:
      {
        return 'zip';
      }
  }
}
