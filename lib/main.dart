import 'package:flutter/material.dart';
import 'package:shriken/screen/share.dart';
import 'package:shriken/screen/convert_hex.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import "screen/config.dart";
import "dart:async";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shriken',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main> {
  StreamSubscription? _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    _handleSharedData();
  }

  void _handleSharedData() {
    // 初期共有データの取得
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      if (value.isNotEmpty && value.first.value != null) {
        _navigateToPostPage(value.first.value!);
      }
    });

    // アプリが実行中の場合の共有データのリスニング
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      if (value.isNotEmpty && value.first.value != null) {
        _navigateToPostPage(value.first.value!);
      }
    });
  }

  void _navigateToPostPage(String sharedText) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostPage(postText: sharedText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supported Nostr Life'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Post to Nostr'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostPage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Convert To Hex'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConvertToHex()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Config'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppConfig()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
