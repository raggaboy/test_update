import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:updat/theme/chips/floating_with_silent_download.dart';
import 'package:updat/updat_window_manager.dart';
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

    return UpdatWindowManager(
      getLatestVersion: () async {
        // Github gives us a super useful latest endpoint, and we can use it to get the latest stable release
        final data = await http.get(Uri.parse(
          "https://api.github.com/repos/raggaboy/test_update/releases",
        ));

        // Return the tag name, which is always a semantically versioned string.
        return jsonDecode(data.body)["tag_name"];
      },
      getBinaryUrl: (version) async {
        // Github also gives us a great way to download the binary for a certain release (as long as we use a consistent naming scheme)

        // Make sure that this link includes the platform extension with which to save your binary.
        // If you use https://exapmle.com/latest/macos for instance then you need to create your own file using `getDownloadFileLocation`
        return "https://github.com/raggaboy/test_update/releases/download/$version/sidekick-${Platform.operatingSystem}-$version.$platformExt";
      },
      appName: "Updat Example", // This is used to name the downloaded files.
      getChangelog: (_, __) async {
        // That same latest endpoint gives us access to a markdown-flavored release body. Perfect!
        final data = await http.get(Uri.parse(
          "https://api.github.com/repos/raggaboy/test_update/releases/latest",
        ));
        return jsonDecode(data.body)["body"];
      },
      updateChipBuilder: floatingExtendedChipWithSilentDownload,
      currentVersion: '1.0.2',
      callback: (status) {},
      child: Scaffold(
        appBar: AppBar(
      
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      
          title: Text(widget.title),
        ),
        body: Center(
      
          child: Column(
      
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Если заработало то ты хорош',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'hui',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
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