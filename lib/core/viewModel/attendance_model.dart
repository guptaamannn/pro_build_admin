import 'package:pro_build_admin/core/model/user_record.dart';

import '/core/enums/view_state.dart';
import '/core/model/attendance.dart';
import '/core/model/user.dart';
import '/core/services/firestore_service.dart';
import '/core/utils/formatter.dart';
import '/locator.dart';

import 'base_model.dart';

class AttendanceModel extends BaseModel {
  final _firestore = locator<FirestoreService>();

  DateTime _selectedDate = Formatter.justDate(DateTime.now());
  DateTime getSelectedDate() {
    return _selectedDate;
  }

  void updateViewDate(DateTime newDate) {
    _selectedDate = Formatter.justDate(newDate);
    notifyListeners();
  }

  Attendance? _currentViewAttendance;

  Attendance? get getCurrentAttendance => _currentViewAttendance;

  void setCurrentAttendance(Attendance? object) {
    _currentViewAttendance = object;
  }

  /// Returns [Stream<User>] from attendance document
  Stream<Attendance> attendanceStream() {
    var snapshot = _firestore
        .attendanceStream(Formatter.attendanceDocumentId(_selectedDate))
        .map((event) => Attendance.fromJson(event.data()!));
    return snapshot;
  }

//Add user in attendance record
  Future<void> addUserToAttendance({
    required User user,
    required String time,
  }) async {
    setState(ViewState.busy);
    Days userDailyRecord = Days(
      date: _selectedDate,
      eDate: user.eDate,
    );

    String documentId = Formatter.attendanceDocumentId(_selectedDate);

    if (_currentViewAttendance == null ||
        _currentViewAttendance?.userIds == null ||
        _currentViewAttendance!.userIds!.isEmpty) {
      await _firestore.createAttendance(user, documentId, time);
    } else if (!_currentViewAttendance!.userIds!.contains(user.id)) {
      await _firestore.updateAttendance(user, documentId, time);
    } else {
      setState(ViewState.idle);
      throw 'duplicate-entry';
    }

    // add to user's record subcollection here

    _firestore.addUserRecord(
        user, userDailyRecord.toJson(), _selectedDate.year.toString());

    setState(ViewState.idle);
  }

  ///Delete [User] from attendance list
  Future<void> deleteAttendee({required User user}) async {
    setState(ViewState.busy);
    await _firestore.removeAttendee(
      documentId: Formatter.attendanceDocumentId(_selectedDate),
      user: user,
    );
    await _firestore.removeUserDailyRecord(user, _selectedDate.year.toString(),
        Days(date: _selectedDate, eDate: user.eDate).toJson());
    _currentViewAttendance!.userIds!.remove(user.id);
    setState(ViewState.idle);
  }
}
