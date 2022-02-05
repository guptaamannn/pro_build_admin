import 'package:pro_build_attendance/core/model/user.dart';

class Attendance {
  DateTime? date;
  List<String>? userIds;
  List<User>? users;

  Attendance({required this.date, required this.userIds, required this.users});

  Attendance.fromJson(Map<String, dynamic> json) {
    date = json['date'].toDate();
    userIds = json['userIds'].cast<String>();
    if (json['users'] != null) {
      users = <User>[];
      json['users'].forEach((v) {
        users!.add(new User.fromAttendance(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['userIds'] = this.userIds;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
