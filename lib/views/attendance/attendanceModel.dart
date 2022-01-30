import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nanoid/async.dart';
import 'package:pro_build_attendance/model/attendance.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:provider/provider.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/services/authentication_service.dart';
import 'package:pro_build_attendance/services/firestore_service.dart';
import 'package:pro_build_attendance/services/storage_service.dart';

class AttendanceViewModel {
  BuildContext context;
  Firestore _firestore = Firestore();
  AuthService _auth = AuthService();
  StorageService _storage = StorageService();
  AttendanceViewModel(this.context);

  //Add user in attendance record
  Future<void> addAttendee({
    required User user,
    List<String>? currentRecord,
    required TimeOfDay time,
  }) async {
    String documentId =
        Formatter.attendanceDocumentId(context.read<Ui>().getSelectedDate());

    if (currentRecord == null || currentRecord.isEmpty) {
      _firestore.createAttendance(user, documentId, time.format(context));
    } else if (!currentRecord.contains(user.id)) {
      _firestore.updateAttendance(user, documentId, time.format(context));
    } else {
      throw 'duplicate-entry';
    }
  }

  //Delete user from attendance list
  void deleteAttendee({required User user}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Heads-up"),
          content:
              Text("Remove ${user.name!.split(" ")[0]} from selected date?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            TextButton(
              onPressed: () async {
                await _firestore.removeAttendee(
                    documentId: Formatter.attendanceDocumentId(
                        context.read<Ui>().getSelectedDate()),
                    user: user);
                Navigator.pop(context);
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Returns [Stream<User>] from attendance document
  Stream<Attendance> attendeeStream(DateTime date) {
    var snapshot = _firestore
        .attendanceStream(Formatter.attendanceDocumentId(date))
        .map((event) => Attendance.fromJson(event.data()!));
    return snapshot;
  }

  void updateViewDate(bool subtract) {
    DateTime? currentDate = context.read<Ui>().getSelectedDate();

    DateTime newDate;
    if (subtract == true) {
      newDate = currentDate.subtract(new Duration(days: 1));
      context.read<Ui>().updateViewDate(newDate);
    } else if (!currentDate.isAfter(Formatter.justDate(DateTime.now()))) {
      newDate = currentDate.add(new Duration(days: 1));
      context.read<Ui>().updateViewDate(newDate);
    }
  }

  //Create User
  Future<void> createUser(
      {required String name,
      required String phone,
      String? imagePath,
      List<String>? usersList}) async {
    context.read<Ui>().setLoading();
    //Generate uid using nanoid
    String id = await nanoid(6);
    //Check if number is already registered.
    bool isRegistered = await _firestore.isNumberRegesitered(phone);

    if (!isRegistered) {
      String? imageUrl = imagePath != null
          ? await _storage.uploadPicture(File(imagePath), id)
          : null;

      User user = User(
        name: name,
        id: id,
        phone: phone,
        dpUrl: imageUrl,
        joinedDate: DateTime.now(),
        eDate: DateTime.now(),
      );

      await _firestore.createUser(user.toJson());
      await addAttendee(
          user: user, time: TimeOfDay.now(), currentRecord: usersList);
      context.read<Ui>().setLoading();
      Navigator.of(context).pop();
    } else {
      context.read<Ui>().setLoading();
      throw 'duplicate-phone';
    }
  }

  bool isSubExpired(DateTime eDate) {
    if (eDate.isBefore(context.read<Ui>().getSelectedDate())) {
      return true;
    } else {
      return false;
    }
  }

  void logOut() {
    _auth.signOut();
  }

  Future<Iterable<User>> searchUser(String query, String searchUsing) async {
    Iterable<User> users = [];
    if (searchUsing == 'name' && query.length > 3) {
      var result = await _firestore.searchUserByName(query);
      users = result.docs.map((e) => User.fromUsers(e.data()));
    } else if (searchUsing == 'phone' && query.length > 7) {
      var result = await _firestore.searchUserByPhone(query);
      users = result.docs.map((e) => User.fromUsers(e.data()));
    }
    if (users.isNotEmpty) {
      users.forEach((element) {
        context.read<Ui>().addUserToList(element);
      });
      return users;
    }
    return Iterable.empty();
  }
}
