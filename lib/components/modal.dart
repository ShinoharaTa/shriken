import 'package:flutter/material.dart';

class ModalProcess {
  static Future<void> run(String modalTitle, String modalContext, BuildContext context, Future<void> Function() process, {Function? onComplete}) async {
    // モーダルを表示
    showDialog(
      context: context,
      barrierDismissible: false, // ユーザーがモーダル外をタップしても閉じない
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(modalTitle),
          content: CircularProgressIndicator(),
        );
      },
    );

    // 指定された処理を実行
    try {
      await process();

      // コールバックがあれば実行
      onComplete?.call();
    } catch (e) {
      print('エラーが発生しました: $e');
    }

    // モーダルを更新
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(modalTitle),
          content: Text(modalContext),
        );
      },
    );

    // 2秒後にモーダルを閉じる
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
  }
}
