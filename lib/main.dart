import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shriken/screen/post_screen.dart';
import 'package:shriken/components/app_drawer.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import "providers/theme_provider.dart";
import "theme/elegant_theme.dart";
import "dart:async";

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Shriken',
          themeMode: themeProvider.themeMode, // 端末設定に従う
          theme: ElegantTheme.lightElegantTheme,
          darkTheme: ElegantTheme.darkElegantTheme,
          home: Main(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main> {
  StreamSubscription? _intentDataStreamSubscription;
  String? _sharedText;

  @override
  void initState() {
    super.initState();
    _handleSharedData();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  void _handleSharedData() {
    // 初期共有データの取得
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      if (value.isNotEmpty && value.first.value != null) {
        setState(() {
          _sharedText = value.first.value!;
        });
      }
    });

    // アプリが実行中の場合の共有データのリスニング
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      if (value.isNotEmpty && value.first.value != null) {
        setState(() {
          _sharedText = value.first.value!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Shriken'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // 通知ボタン
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {
                  // 通知はハンバーガーメニューからアクセス
                  Scaffold.of(context).openDrawer();
                },
              ),
              // 未読通知の赤いバッジ
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '2', // TODO: 実際の未読数を表示
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: PostScreen(postText: _sharedText), // エレガントな投稿画面を固定
    );
  }


}
