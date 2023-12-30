import 'package:flutter/material.dart';
import 'package:shriken/screen/share.dart';
import "screen/config.dart";

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

class Main extends StatelessWidget {
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
                  MaterialPageRoute(builder: (context) => SharePage()),
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
