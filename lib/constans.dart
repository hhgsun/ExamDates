import 'package:flutter/material.dart';

void openSnackBar(context, GlobalKey<ScaffoldState> scaffoldKey, text) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 1),
  ));
}

int generateNotificationId() {
  return DateTime.now().year +
      DateTime.now().month +
      DateTime.now().day +
      DateTime.now().hour +
      DateTime.now().minute +
      DateTime.now().second +
      DateTime.now().millisecond;
}
