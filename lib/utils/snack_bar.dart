import 'package:flutter/material.dart';
import 'package:bookscout/main.dart';

class SnackMessage {
  static void showSnackBar(String message) {
    final scaffold = scaffoldMessengerKey.currentState;

    scaffold?.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          scaffold.hideCurrentSnackBar();
        },
      ),
      duration: const Duration(minutes: 1),
    ));
  }
}
