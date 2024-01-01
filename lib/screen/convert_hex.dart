import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';

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
        title: Text('npub/nsec to Hex'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nip19,
              decoration: InputDecoration(labelText: 'nsec/npub key'),
              onChanged: (value) => _convert(),
              maxLines: null,
              minLines: 2,
            ),
            TextField(
              controller: _hex,
              decoration: InputDecoration(labelText: 'Hex key'),
              readOnly: true,
              maxLines: null,
              minLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
