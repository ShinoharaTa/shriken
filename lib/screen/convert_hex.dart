import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:shriken/components/app_drawer.dart';

class ConvertToHex extends StatefulWidget {
  @override
  _ConvertToHexState createState() => _ConvertToHexState();
}

class _ConvertToHexState extends State<ConvertToHex> {
  final TextEditingController _nip19 = TextEditingController();
  final TextEditingController _hex = TextEditingController();

  void _convert() {
    String convert = "";
    try {
      convert = Nip19.decodePrivkey(_nip19.text);
      // convert = Nip19.bech32Decode(_nip19.text);
    } catch (e) {
      convert = "Decord failed.";
    }
    try {
      convert = Nip19.decodePubkey(_nip19.text);
    } catch (e) {
      convert = "Decord failed.";
    }
    print({"result $convert"});
    _hex.text = convert;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('キー変換'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // 戻るボタンを非表示
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(), // ハンバーガーメニューを追加
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ヘッダー説明
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.transform,
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
                        'Nostrキー変換',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'npub/nsecからHEX形式に変換',
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

            // 入力カード
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.input,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '入力 (npub/nsec)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _nip19,
                      decoration: InputDecoration(
                        hintText: 'npub... または nsec... を入力してください',
                        prefixIcon: Icon(Icons.key),
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
                      ),
                      onChanged: (value) => _convert(),
                      maxLines: 3,
                      minLines: 2,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 変換アイコン
            Center(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.swap_vert,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
            ),

            SizedBox(height: 16),

            // 出力カード
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.output,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '出力 (HEX)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        if (_hex.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              // TODO: クリップボードにコピー
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('クリップボードにコピーしました')),
                              );
                            },
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        _hex.text.isEmpty ? '変換結果がここに表示されます' : _hex.text,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          color: _hex.text.isEmpty ? Colors.grey[500] : Colors.black87,
                        ),
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            // ヒント
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
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
                        'ヒント',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• npubは公開鍵、nsecは秘密鍵です\n• HEX形式はプログラムで使用される16進数形式です\n• 秘密鍵は絶対に他人に教えないでください',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
