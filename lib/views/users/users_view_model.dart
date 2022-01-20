import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/services/firestore_service.dart';
import 'package:provider/provider.dart';

class UsersViewModel {
  final BuildContext context;
  final Firestore _firestore = Firestore();

  UsersViewModel(this.context);

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersStream() {
    return _firestore.getUsersStream(
      sortBy: context.watch<Ui>().getSortListBy,
      sortByDescending: context.watch<Ui>().getIsSortByDescending,
    );
  }
}
