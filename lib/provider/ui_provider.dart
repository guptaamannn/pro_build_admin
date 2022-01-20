import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/utils/formatter.dart';

class Ui extends ChangeNotifier {
//<-----------Attendance View---------------->
  DateTime _selectedDate = Formatter.justDate(DateTime.now());

  DateTime getSelectedDate() {
    return _selectedDate;
  }

  void updateViewDate(DateTime newDate) {
    _selectedDate = Formatter.justDate(newDate);
    notifyListeners();
  }

  // <----------- Users View ------------>
  //Sliver App Bar Widgets Functionality
  //Sort Users List
  String _sortBy = 'name';
  bool _isSortByDescending = false;

  String get getSortListBy => _sortBy;
  bool get getIsSortByDescending => _isSortByDescending;

  void setSortListBy(String value) {
    _sortBy = value;
    notifyListeners();
  }

  void setSortByDescending() {
    _isSortByDescending = !_isSortByDescending;
    notifyListeners();
  }

  //<--------- Loading State ----------->
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  //<------ Search --------->
  List<User> _users = [];

  List<User> get getUsers => _users;

  void addUserToList(User user) {
    if (_users.isEmpty) {
      _users.add(user);
    } else {
      if (_users.every((element) => element.id != user.id)) {
        _users.add(user);
      }
    }
    notifyListeners();
  }
}
