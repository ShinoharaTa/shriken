import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:shriken/class/connection.dart';
import 'package:shriken/class/encrypt.dart';

class PostPage extends StatefulWidget {
  final String? postText;

  PostPage({this.postText});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final EncryptManager _encryptManager = EncryptManager();
  late TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.postText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _post() async {
    // TODO: 投稿処理をここに実装
    String? nsec = await _encryptManager.getItem("nsec");
    if (nsec != null) {
      Event event =
          Nip1.textNote(_textController.text, Nip19.decodePrivkey(nsec) ?? "");
      Connect.sharedInstance.sendEventRelays(event, [
        "wss://relay-jp.nostr.wirednet.jp/",
        "wss://yabu.me/",
        "wss://r.kojira.io/",
        "wss://relay-jp.shino3.net/",
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Something'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Share your thoughts',
                alignLabelWithHint: true, // ラベルを上揃えにする
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 7, // 7行のテキストエリア
              maxLength: null, // 最大長は制限なし
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _post,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
