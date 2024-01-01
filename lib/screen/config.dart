import 'package:flutter/material.dart';
import 'package:shriken/class/encrypt.dart';

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
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nsec,
                decoration: InputDecoration(
                  labelText: 'nsec',
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
                ),
                obscureText: _isObscured,
                validator: (value) {
                  if (value == null ||
                      !value.startsWith('nsec1') ||
                      value.length != 63) {
                    return 'Value must start with "nsec1" and be 63 characters long';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: _updateSettings,
              child: Text('Save Config'),
            ),
          ],
        ),
      )),
    );
  }
}
