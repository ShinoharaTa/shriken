import 'package:flutter/material.dart';
import 'package:shriken/class/encrypt.dart'; // EncryptManagerのインポート

class AppConfig extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<AppConfig> {
  final _encryptManager = EncryptManager();
  final TextEditingController _nsec = TextEditingController();
  // final TextEditingController _settingController2 = TextEditingController();
  // final TextEditingController _settingController3 = TextEditingController();

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
    // _settingController2.dispose();
    // _settingController3.dispose();
    super.dispose();
  }

  void _updateSettings() async {
    String nsec = _nsec.text;
    if ( nsec.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nsec,
                decoration: InputDecoration(labelText: 'nsec'),
                maxLines: null, // 長いテキスト用
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: _settingController2,
            //     decoration: InputDecoration(labelText: 'Setting Title 2'),
            //     maxLines: null, // 長いテキスト用
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: _settingController3,
            //     decoration: InputDecoration(labelText: 'Setting Title 3'),
            //     maxLines: null, // 長いテキスト用
            //   ),
            // ),
            ElevatedButton(
              onPressed: _updateSettings,
              child: Text('Save Config'),
            ),
          ],
        ),
      ),
    );
  }
}
