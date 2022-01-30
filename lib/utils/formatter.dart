import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show TimeOfDay;
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
  static DateTime get getCurrentTime {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat.jm();
    return format.parse(now.toString());
  }

  /// Returns [String] from [DateTime] formatted to match attendance document id.
  static String attendanceDocumentId(DateTime date) {
    DateFormat formatter = DateFormat("yyyMMdd");
    return formatter.format(date);
  }

  static DateTime fromString(String date) {
    DateFormat format = DateFormat('yyyy-MMM-dd');
    return format.parse(date);
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

  ///Returns [DateTime] from [String] like 12:00 AM
  // static DateTime stringToDateTime(String tod) {
  //   final format = DateFormat.jm();
  //   return format.parse(tod);
  // }

  ///Returns [TimeOfDay] from [String]
  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(tod));
  }
}
