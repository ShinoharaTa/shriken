import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shriken/screen/convert_hex.dart';
import 'package:shriken/screen/sats_price.dart';
import 'package:shriken/screen/config.dart';
import 'package:shriken/screen/notification_screen.dart';
import 'package:shriken/providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _buildThemeButton(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeMode themeMode,
    IconData icon,
    String label,
  ) {
    final isSelected = themeProvider.themeMode == themeMode;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          themeProvider.setThemeMode(themeMode);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withOpacity(0.3),
              width: 1, // 最小幅に統一
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8), // 最小限の上部パディング
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
                size: 18, // アイコンサイズを小さく
              ),
              SizedBox(height: 2), // アイコンとテキストの間隔を縮小
              Text(
                label,
                style: TextStyle(
                  fontSize: 10, // 文字サイズを小さく
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6), // 最小限の下部パディング
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Nostr Life',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'SNSをもっと楽しく',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('ホーム（投稿）'),
            onTap: () {
              Navigator.pop(context); // Drawerを閉じる
              // ホーム画面に戻る（全ての画面をクリア）
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: Icon(Icons.transform),
            title: Text('キー変換'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConvertToHex()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.currency_bitcoin),
            title: Text('ビットコイン価格'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SatsPrice()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('設定'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppConfig()),
              );
            },
          ),
          ListTile(
            leading: Stack(
              children: [
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            title: Text('通知'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('アプリについて'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Shriken v1.0'),
                  content: Text('Nostrプロトコルを使用したSNS支援アプリです。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('閉じる'),
                    ),
                  ],
                ),
              );
            },
          ),
          Spacer(), // 下部に配置するためのスペーサー
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'テーマ設定',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildThemeButton(
                      context,
                      themeProvider,
                      ThemeMode.system,
                      Icons.brightness_auto,
                      'システム',
                    ),
                    _buildThemeButton(
                      context,
                      themeProvider,
                      ThemeMode.light,
                      Icons.light_mode,
                      'ライト',
                    ),
                    _buildThemeButton(
                      context,
                      themeProvider,
                      ThemeMode.dark,
                      Icons.dark_mode,
                      'ダーク',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
        );
      },
    );
  }
}
