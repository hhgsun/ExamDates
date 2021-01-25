import 'package:examdates/constans.dart';
import 'package:examdates/models/NotificationContent.dart';
import 'package:examdates/services/data_service.dart';
import 'package:examdates/services/notification_service.dart';
import 'package:flutter/material.dart';

class AddExamPage extends StatefulWidget {
  final NotificationContent notificationContent;

  const AddExamPage({Key key, this.notificationContent}) : super(key: key);
  @override
  _AddExamPageState createState() => _AddExamPageState();
}

class _AddExamPageState extends State<AddExamPage> {
  final _formKey = GlobalKey<FormState>();
  DataService dataService = new DataService();

  String textTitle = "";
  String textBody = "";
  DateTime selectedDate;
  DateTime selectedTime;
  DateTime selectedBeforeTime;

  bool isUpdate = false;
  String errorMsgDate = '';
  String errorMsgTime = '';
  String errorMsgBeforeTime = '';

  @override
  void initState() {
    if (widget.notificationContent != null) {
      setState(() {
        this.isUpdate = true;
        this.textTitle = widget.notificationContent.title;
        this.textBody = widget.notificationContent.body;
        this.selectedDate = widget.notificationContent.date;
        this.selectedTime = widget.notificationContent.time;
        this.selectedBeforeTime = widget.notificationContent.beforeTime;
      });
    }
    super.initState();
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate != null ? selectedDate : DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
      });
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime != null
          ? TimeOfDay.fromDateTime(selectedTime)
          : TimeOfDay(hour: 00, minute: 00),
    );
    if (picked != null) {
      var now = new DateTime.now();
      setState(() {
        selectedTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      });
    }
  }

  void _selectBeforeTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedBeforeTime != null
          ? TimeOfDay.fromDateTime(selectedBeforeTime)
          : TimeOfDay(hour: 00, minute: 00),
    );
    if (picked != null) {
      var now = new DateTime.now();
      setState(() {
        selectedBeforeTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      });
    }
  }

  void sendSave() {
    if (this.selectedDate == null ||
        this.selectedTime == null ||
        this.selectedBeforeTime == null) {
      setState(() {
        if (this.selectedDate == null)
          this.errorMsgDate = 'Lütfen sınav tarihini seçiniz';
        if (this.selectedTime == null)
          this.errorMsgTime = 'Lütfen sınav saatini seçiniz';
        if (this.selectedBeforeTime == null)
          this.errorMsgBeforeTime = 'Lütfen hatırlatma saatini seçiniz';
      });
    }
    if (_formKey.currentState.validate()) {
      NotificationContent not = new NotificationContent(
        generateNotificationId(), // id generate
        this.textTitle,
        this.textBody,
        this.selectedDate,
        this.selectedTime,
        this.selectedBeforeTime,
      );
      if (isUpdate) {
        dataService.update(widget.notificationContent.id, not);
        Navigator.of(context).pop('Güncelleme gerçekleşti');
      } else {
        dataService.add(not).then((value) {
          notificationService.zonedScheduleNotification(not).then((value) {
            print("BİLDİRİM EKLENDİ");
          });
        });
        Navigator.of(context).pop('Ekleme gerçekleşti');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(isUpdate ? 'Güncelle' : 'Yeni Sınav Ekle'),
        actions: [
          isUpdate
              ? IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    dataService.delete(widget.notificationContent.id);
                    Navigator.of(context).pop('Silme gerçekleşti');
                  })
              : Text(''),
        ],
      ),
      bottomSheet: Container(
        height: 60.0,
        alignment: Alignment.center,
        child: FlatButton(
          minWidth: MediaQuery.of(context).size.width * 0.9,
          height: 50.0,
          color: Theme.of(context).primaryColor,
          onPressed: () => sendSave(),
          child: Text(
            isUpdate ? 'Kaydet' : 'Ekle',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: this.textTitle.toString(),
                  decoration: InputDecoration(
                    hintText: 'Sınav Adı',
                  ),
                  onChanged: (String value) {
                    this.textTitle = value;
                  },
                  validator: (value) {
                    if (value.isEmpty || value == "") {
                      return 'Lütfen sınav adını giriniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  initialValue: this.textBody.toString(),
                  decoration: InputDecoration(
                    hintText: 'Açıklama',
                  ),
                  onChanged: (String value) {
                    this.textBody = value;
                  },
                ),
                SizedBox(height: 20.0),
                Divider(),
                ListTile(
                  title: Text('Tarih:'),
                  onTap: () {
                    _selectDate(context);
                  },
                  trailing: selectedDate != null
                      ? Text(
                          selectedDate.day.toString() +
                              " " +
                              selectedDate.month.toString() +
                              " " +
                              selectedDate.year.toString(),
                        )
                      : Text('Sınav tarihi seçin'),
                  subtitle: errorMsgDate != ''
                      ? Text(
                          errorMsgDate,
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                            fontSize: 12.0,
                          ),
                        )
                      : null,
                  leading: Icon(Icons.calendar_today_rounded),
                ),
                Divider(),
                ListTile(
                  title: Text('Saat:'),
                  onTap: () {
                    _selectTime(context);
                  },
                  trailing: selectedTime != null
                      ? Text(
                          selectedTime.hour.toString() +
                              ":" +
                              selectedTime.minute.toString(),
                        )
                      : Text('Sınav saati seçin'),
                  subtitle: errorMsgTime != ''
                      ? Text(
                          errorMsgTime,
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                            fontSize: 12.0,
                          ),
                        )
                      : null,
                  leading: Icon(Icons.alarm_sharp),
                ),
                Divider(),
                ListTile(
                  title: Text('Hatırlatma:'),
                  onTap: () {
                    _selectBeforeTime(context);
                  },
                  trailing: selectedBeforeTime != null
                      ? Text(
                          selectedBeforeTime.hour.toString() +
                              ":" +
                              selectedBeforeTime.minute.toString(),
                        )
                      : Text('Hatırlatma saati seçin'),
                  subtitle: errorMsgBeforeTime != ''
                      ? Text(
                          errorMsgBeforeTime,
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                            fontSize: 12.0,
                          ),
                        )
                      : null,
                  leading: Icon(Icons.notification_important_outlined),
                ),
                Divider(),
                SizedBox(height: 100.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
