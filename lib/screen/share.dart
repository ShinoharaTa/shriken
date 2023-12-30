import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import "dart:async";

class SharePage extends StatefulWidget {
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final TextEditingController _textController = TextEditingController();
  StreamSubscription? _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    // テキスト共有イベントをリスンする
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen(
      (String value) {
        setState(() {
          _textController.text = value;
        });
      },
      onError: (err) {
        print("共有インテントエラー: $err");
      },
    );

    // 初期起動時のインテントをチェックする
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        setState(() {
          _textController.text = value;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _post() {
    // TODO: 投稿処理をここに実装
    print('投稿された内容: ${_textController.text}');
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
            SizedBox(height: 24.0),
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
