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

Future<void> showCustomAlert(context,
    {String title, String content, String desc, bool isSuccess = true}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: isSuccess
            ? Icon(
                Icons.done,
                color: Colors.green,
              )
            : Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title != null ? title : '',
              textAlign: TextAlign.center,
            ),
            content != null
                ? Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : SizedBox(),
            desc != null
                ? Text(
                    desc,
                    textAlign: TextAlign.center,
                  )
                : SizedBox(),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Tamam'),
          )
        ],
      );
    },
  );
}

void showLoading(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.all(20.0),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Bekleyiniz..."),
          ],
        ),
      );
    },
  );
}

void hideLoading(context) {
  Navigator.of(context).pop();
}
