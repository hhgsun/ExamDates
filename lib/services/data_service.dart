import 'dart:convert';
import 'package:examdates/models/NotificationContent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  String _key = 'nots';
  Future<List<NotificationContent>> getAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(_key);
    if (list == null || list.length == 0) {
      return new List<NotificationContent>();
    }
    return list.map((e) {
      return NotificationContent.fromJson(json.decode(e));
    }).toList();
  }

  Future<NotificationContent> getOne(String id) async {
    List<NotificationContent> nots = await getAll();
    List<NotificationContent> list =
        nots.where((element) => element.id.toString() == id).toList();
    if (list.length > 0) {
      return list.first;
    }
    return null;
  }

  Future<void> add(NotificationContent notificationContent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<NotificationContent> nots = await getAll();
    nots.add(notificationContent);
    List<String> strList = new List<String>();
    nots.forEach((not) {
      strList.add(json.encode(not.toJson()));
    });
    return prefs.setStringList(_key, strList);
  }

  Future<void> update(int id, NotificationContent notificationContent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<NotificationContent> nots = await getAll();
    List<String> strList = new List<String>();

    nots.forEach((not) {
      if (not.id == id) {
        strList.add(json.encode(notificationContent.toJson()));
      } else {
        strList.add(json.encode(not.toJson()));
      }
    });
    return prefs.setStringList(_key, strList);
  }

  Future<void> delete(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<NotificationContent> nots = await getAll();
    List<String> strList = new List<String>();
    nots.forEach((not) {
      if (not.id != id) {
        strList.add(json.encode(not.toJson()));
      }
    });
    prefs.setStringList(_key, strList);
  }
}
