import 'package:examdates/services/notification_service.dart';
import 'package:examdates/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(ExamDates());
}

class ExamDates extends StatefulWidget {
  @override
  _ExamDatesState createState() => _ExamDatesState();
}

class _ExamDatesState extends State<ExamDates> {
  @override
  void initState() {
    notificationService.init(onSelectNotification);
    super.initState();
  }

  Future<void> onSelectNotification(String payload) async {
    print(payload);
    showAlertDialog(context);
  }

  void showAlertDialog(BuildContext context) async {
    print('alert dialog');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Simple Alert"),
          content: Text("This is an alert message."),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exam Dates',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr', 'TR'),
      ],
      home: HomePage(),
    );
  }
}
