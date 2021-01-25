class NotificationContent {
  int id;
  String title;
  String body;
  DateTime date;
  DateTime time;
  DateTime beforeTime;
  int done;

  NotificationContent(
    this.id,
    this.title,
    this.body,
    this.date,
    this.time,
    this.beforeTime, {
    this.done = 1, // bildirim listesinde var ise 0 olur tamamlanmamıştır.
  });

  factory NotificationContent.fromJson(Map json) {
    return NotificationContent(
      json['id'],
      json['title'],
      json['body'],
      DateTime.parse(json['date']),
      DateTime.parse(json['time']),
      DateTime.parse(json['beforeTime']),
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "title": this.title,
        "body": this.body,
        "date": this.date.toString(),
        "time": this.time.toString(),
        "beforeTime": this.beforeTime.toString(),
        "done": this.done,
      };
}
