import 'package:intl/intl.dart';

/* CLASS DISTANCE, non si dovrebbe toccare troppo */

class Distance {
  final DateTime time;
  final int value;

  Distance({required this.time, required this.value});

  Distance.fromJson(String date, Map<String, dynamic> json)
      : time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value = int.parse(json["value"]);

  @override
  String toString() {
    return 'Distance(time: $time, value: $value)';
  } //toString
}
