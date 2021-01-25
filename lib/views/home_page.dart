import 'package:examdates/constans.dart';
import 'package:examdates/models/NotificationContent.dart';
import 'package:examdates/services/data_service.dart';
import 'package:examdates/services/notification_service.dart';
import 'package:examdates/views/add_exam_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<PendingNotificationRequest> pendingNotificationRequests =
      new List<PendingNotificationRequest>();

  bool isLoad = false;

  DataService dataService = new DataService();
  List<NotificationContent> notificationsData = List<NotificationContent>();

  @override
  void initState() {
    this.getAllData();
    super.initState();
  }

  void getAllData() {
    setState(() {
      this.isLoad = false;
    });
    this.dataService.getAll().then((value) {
      setState(() {
        this.notificationsData = value;
        this.isLoad = true;
      });
    });
    // bu kısımdan gelen id lere ait local dataları işaretle {done=0} olarak
    notificationService.getPendingNotfs().then((value) {
      setState(() {
        pendingNotificationRequests = value;
      });
    });
  }

  openAddExamPage(context, {NotificationContent not}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) =>
            not != null ? AddExamPage(notificationContent: not) : AddExamPage(),
      ),
    )
        .then((msg) {
      getAllData();
      if (msg != null && msg is String) {
        openSnackBar(context, _scaffoldKey, msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sınav Tarihleri'),
        actions: [
          FlatButton(
            textColor: Colors.white,
            onPressed: () => openAddExamPage(context),
            child: Row(
              children: [Icon(Icons.add), Text('Yeni Ekle')],
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: isLoad
          ? notificationsData.length > 0
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: notificationsData
                            .map(
                              (n) => ListTile(
                                title: Text(n.title),
                                subtitle: Text(n.body),
                                leading: Text(n.id.toString()),
                                onTap: () => openAddExamPage(context, not: n),
                              ),
                            )
                            .toList(),
                      ),
                      Divider(color: Colors.red),
                      Text('Bildirim Bekleyen İd ler'),
                      Column(
                          children: pendingNotificationRequests
                              .map((e) => Text(e.id.toString()))
                              .toList())
                    ],
                  ),
                )
              : Center(
                  child: Text('Zamanlanmış sınav yok.'),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
