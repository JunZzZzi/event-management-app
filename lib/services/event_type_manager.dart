import 'package:shared_preferences/shared_preferences.dart';


class EventTypeManager {
  static late SharedPreferences _prefs;
  static List<String>? _eventTypes;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _eventTypes = _prefs.getStringList('eventTypes') ?? ['All', 'Conference', 'Workshop', 'Webinar'];
  }

  static List<String> get eventTypes => _eventTypes ?? ['All', 'Conference', 'Workshop', 'Webinar'];

  static Future<void> addEventType(String type) async {
    if (!eventTypes.contains(type)) {
      _eventTypes?.add(type);
      await _prefs.setStringList('eventTypes', _eventTypes!);
      print('Event type added: $type');
    }
  }

}