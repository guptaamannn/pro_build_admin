import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro_build_attendance/model/user.dart';

class Firestore {
  final CollectionReference<Map<String, dynamic>> _users =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference<Map<String, dynamic>> _attendance =
      FirebaseFirestore.instance.collection("attendance");

  Stream<DocumentSnapshot<Map<String, dynamic>>> attendanceStream(
          String documentId) =>
      _attendance.doc(documentId).snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(
      String documentId) {
    return _users.doc(documentId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersStream(
      {String? sortBy, bool? sortByDescending}) {
    return _users
        .orderBy(
          sortBy == null ? "name" : sortBy,
          descending: sortByDescending == null ? false : sortByDescending,
        )
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(
      String documentId) async {
    return await _users.doc(documentId).get();
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    await _users.doc(data["id"]).set(data).catchError((e) => print(e));
  }

  Future<void> createAttendance(
    User user,
    String documentId,
    String time,
  ) async {
    user.attendTime = time;
    await _attendance.doc(documentId).set({
      "date": DateTime.now(),
      "users": [user.toAttendance()],
      "userIds": [user.id],
    });
  }

  Future<void> updateAttendance(
    User user,
    String documentId,
    String time,
  ) async {
    user.attendTime = time;
    await _attendance.doc(documentId).update({
      "users": FieldValue.arrayUnion([user.toAttendance()]),
      "userIds": FieldValue.arrayUnion([user.id]),
    });
  }

  /// Returns the number of days user attended gym after subscription expiered
  Future<int> daysAfterExp(String userId, DateTime eDate) async {
    var data = await _attendance
        .where("date", isGreaterThan: eDate)
        .where("userIds", arrayContains: userId)
        .get();
    return data.docs.length;
  }

  //Remove user entry from attendance.
  Future<void> removeAttendee({
    required String documentId,
    required User user,
  }) async {
    _attendance.doc(documentId).update({
      "users": FieldValue.arrayRemove([
        user.attendTime == null
            ? {
                "name": user.name,
                "id": user.id,
                "eDate": user.eDate,
                "dpUrl": user.dpUrl
              }
            : {
                "name": user.name,
                "id": user.id,
                "eDate": user.eDate,
                "time": user.attendTime,
                "dpUrl": user.dpUrl,
              }
      ]),
      "userIds": FieldValue.arrayRemove([user.id])
    });
  }

  //Update user's subscription expiriation date
  Future<void> updateEDate(String documentId, DateTime date) async {
    await _users.doc(documentId).update({"eDate": date});
  }

  //Update user information
  Future<void> updateUserInfo(
      String userId, Map<String, dynamic> object) async {
    await _users.doc(userId).update(object);
  }

  ///Return if number is already added to db
  Future<bool> isNumberRegesitered(String phone) async {
    var result = await _users.where("phone", isEqualTo: phone).get();
    return result.docs.isNotEmpty;
  }

  ///get User by name
  Future<QuerySnapshot<Map<String, dynamic>>> searchUserByName(
      String searchKey) async {
    return await _users
        .where('name', isGreaterThanOrEqualTo: searchKey)
        .where('name', isLessThan: searchKey + 'z')
        .orderBy('name')
        .limit(3)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchUserByPhone(
      String searchKey) async {
    return await _users
        .where('phone', isGreaterThanOrEqualTo: searchKey)
        .where('phone', isLessThan: '+9999999999999')
        .orderBy('phone')
        .limit(3)
        .get();
  }
}
