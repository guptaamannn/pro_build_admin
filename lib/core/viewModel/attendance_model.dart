import 'package:pro_build_attendance/core/enums/view_state.dart';
import 'package:pro_build_attendance/core/model/attendance.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/core/services/firestore_service.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/locator.dart';

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

  void setCurrentAttendance(Attendance object) {
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
    setState(ViewState.idle);
  }

  ///Delete [User] from attendance list
  Future<void> deleteAttendee({required User user}) async {
    setState(ViewState.busy);
    await _firestore.removeAttendee(
      documentId: Formatter.attendanceDocumentId(_selectedDate),
      user: user,
    );
    _currentViewAttendance!.userIds!.remove(user.id);
    setState(ViewState.idle);
  }
}
