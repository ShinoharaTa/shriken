import 'package:flutter/material.dart';
import 'package:shriken/class/encrypt.dart';
import 'package:shriken/components/app_drawer.dart';

class AppConfig extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<AppConfig> {
  final _encryptManager = EncryptManager();
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;

  final TextEditingController _nsec = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    String? nsec = await _encryptManager.getItem("nsec");
    print("SaveSetting: $nsec");
    if (nsec != null) {
      setState(() {
        _nsec.text = nsec;
      });
    }
  }

  @override
  void dispose() {
    _nsec.dispose();
    super.dispose();
  }

  void _updateSettings() async {
    if (_formKey.currentState!.validate()) {
      String nsec = _nsec.text;
      if (nsec.isNotEmpty) {
        print("seve nsec");
        await _encryptManager.saveItem('nsec', nsec);
      } else {
        print("remove nsec");
        await _encryptManager.deleteItem('nsec');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('done.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(), // ハンバーガーメニューを追加
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ヘッダー
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'アプリケーション設定',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Nostr接続のための秘密鍵を設定',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Nostr設定カード
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.key,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Nostr秘密鍵 (nsec)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _nsec,
                        decoration: InputDecoration(
                          hintText: 'nsec1... で始まる秘密鍵を入力してください',
                          prefixIcon: Icon(Icons.vpn_key),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        obscureText: _isObscured,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // 空文字は許可（削除のため）
                          }
                          if (!value.startsWith('nsec1') || value.length != 63) {
                            return 'nsec1で始まる63文字の秘密鍵を入力してください';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // 保存ボタン
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save),
                              SizedBox(width: 8),
                              Text(
                                '設定を保存',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // セキュリティ警告カード
            Card(
              elevation: 2,
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Colors.orange[700],
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'セキュリティについて',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• 秘密鍵は端末内で暗号化されて保存されます\n• 秘密鍵を他人に教えないでください\n• スクリーンショットや共有時に注意してください\n• 紛失した場合は復元できません',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            // アプリ情報
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'アプリ情報',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('アプリ名'),
                        Text('Shriken'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('バージョン'),
                        Text('v0.1'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nostrプロトコル'),
                        Text('対応'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8),

            // フッター
            Text(
              'Shriken - SNSをもっと楽しくするためのサポートアプリ',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
