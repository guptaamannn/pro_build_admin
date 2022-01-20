import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Formatter {
  static String fromTimeStamp(Timestamp timestamp) {
    DateFormat formatter = DateFormat("yyyy-MMM-dd");
    return formatter.format(timestamp.toDate());
  }

  static String fromDateTime(DateTime? date) {
    DateFormat formatter = DateFormat("yyyy-MMM-dd");
    return formatter.format(date!);
  }

  /// Return just the date from a [DateTime] object.
  static DateTime justDate(DateTime date) {
    DateFormat formatter = DateFormat("yyyy-MMM-dd");
    return formatter.parse(formatter.format(date));
  }

  /// Returns current time in 12:00 AM format.
  static String get getCurrentTime {
    DateTime now = DateTime.now();
    return DateFormat.jm().format(now);
  }

  /// Returns [String] from [DateTime] formatted to match attendance document id.
  static String attendanceDocumentId(DateTime date) {
    DateFormat formatter = DateFormat("yyyMMdd");
    return formatter.format(date);
  }

  /// Returns Month name from [DateTime]
  static String toMonth(DateTime date) {
    DateFormat formatter = DateFormat("MMMM");
    return formatter.format(date);
  }

  /// Returns Day as [String] from [DateTime]
  static String toDay(DateTime date) {
    DateFormat format = DateFormat("EE");
    return format.format(date);
  }
}
