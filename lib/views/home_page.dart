import 'package:examdates/constans.dart';
import 'package:examdates/models/NotificationContent.dart';
import 'package:examdates/services/data_service.dart';
import 'package:examdates/services/notification_service.dart';
import 'package:examdates/views/add_exam_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
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
  String lastPayload;

  @override
  void initState() {
    this.getAllData();
    super.initState();
  }

  void getAllData() async {
    setState(() {
      this.isLoad = false;
    });
    notificationService
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationService.setOnNotificationClick(onNotificationClick);
    this.dataService.getAll().then((contents) {
      notificationService.getPendingNotfs().then((pendings) {
        pendingNotificationRequests = pendings;
        contents.forEach((content) {
          pendingNotificationRequests.forEach((pending) {
            if (content.id == pending.id) {
              content.done = 0; // henüz bildirimi bekleniyor
            }
          });
        });
        setState(() {
          this.notificationsData = contents;
          this.isLoad = true;
        });
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

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    if (lastPayload != payload) {
      lastPayload = payload;
      dataService.getOne(payload).then((not) {
        showCustomAlert(context, title: not.title, desc: not.body)
            .then((value) {
          this.getAllData();
        });
      });
    }
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
              children: [Icon(Icons.add_alert), Text('Yeni Ekle')],
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: isLoad
          ? notificationsData.length > 0
              ? ListView.separated(
                  separatorBuilder: (context, i) => Divider(),
                  itemCount: notificationsData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      tileColor: notificationsData[index].done == 0
                          ? Colors.black26
                          : Colors.transparent,
                      title: Text(notificationsData[index].title),
                      subtitle: Text(notificationsData[index].body),
                      trailing: notificationsData[index].done == 0
                          ? Icon(Icons.watch_later_outlined)
                          : Icon(Icons.done_rounded),
                      onTap: () => openAddExamPage(context,
                          not: notificationsData[index]),
                    );
                  },
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
