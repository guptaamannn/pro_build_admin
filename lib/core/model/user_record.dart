class UserRecord {
  List<Days>? days;

  UserRecord({this.days});

  UserRecord.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (days != null) {
      data['days'] = days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Days {
  DateTime? date;
  DateTime? eDate;

  Days({this.date, this.eDate});

  Days.fromJson(Map<String, dynamic> json) {
    date = json['date'].toDate();
    eDate = json['eDate'].toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['eDate'] = eDate;
    return data;
  }
}
