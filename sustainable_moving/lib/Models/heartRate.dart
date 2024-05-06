import 'package:intl/intl.dart';

/* CLASS HEART RATE, non si dovrebbe toccare troppo */

class HeartRate {
  final DateTime time;
  final int value;
  final int confidence;

  HeartRate(
      {required this.time, required this.value, required this.confidence});

  HeartRate.fromJson(String date, Map<String, dynamic> json)
      : time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value = (json["value"]),
        confidence = (json["confidence"]);

  @override
  String toString() {
    return 'HeartRate(time: $time, value: $value, confidence: $confidence)';
  }
}
