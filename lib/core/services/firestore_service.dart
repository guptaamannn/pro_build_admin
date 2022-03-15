import 'package:cloud_firestore/cloud_firestore.dart';
import '/core/model/user.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _users =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference<Map<String, dynamic>> _attendance =
      FirebaseFirestore.instance.collection("attendance");

  final CollectionReference<Map<String, dynamic>> _payments =
      FirebaseFirestore.instance.collection("payments");

  final CollectionReference<Map<String, dynamic>> _expenses =
      FirebaseFirestore.instance.collection("expenses");

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
          sortBy ?? "name",
          descending: sortByDescending ?? false,
        )
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(
      String documentId) async {
    return await _users.doc(documentId).get();
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    await _users.doc(data["id"]).set(data);
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

  Future<void> addUserRecord(
      User user, Map<String, dynamic> record, String year) async {
    try {
      await _users.doc(user.id).collection("records").doc(year).update({
        "days": FieldValue.arrayUnion([record])
      });
    } catch (e) {
      await _users.doc(user.id).collection("records").doc(year).set({
        "days": [record]
      });
    }
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
    await _attendance.doc(documentId).update({
      "users": FieldValue.arrayRemove([
        user.attendTime == null
            ? {
                "name": user.name,
                "id": user.id,
                "eDate": user.eDate,
              }
            : user.toAttendance(),
      ]),
      "userIds": FieldValue.arrayRemove([user.id])
    });
  }

  Future<void> removeUserDailyRecord(
      User user, String year, Map<String, dynamic> record) async {
    await _users.doc(user.id).collection("records").doc(year).update({
      "days": FieldValue.arrayRemove([record])
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

  //<--------------- Payments -------------------->
  Stream<QuerySnapshot<Map<String, dynamic>>> invoiceStream() {
    return _payments.orderBy('orderDate', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> userInvoiceStream(String userId) {
    return _payments
        .where("userId", isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots();
  }

  createInvoice(Map<String, dynamic> invoice, DateTime? eDate,
      Map<String, dynamic> forUser) async {
    await _payments.doc(invoice["invoiceId"]).set(invoice);
    if (eDate != null) await updateEDate(invoice["userId"], eDate);
  }

  Future<void> deleteReceipt(String? invoiceId) async {
    await _payments.doc(invoiceId).delete();
  }

  Future<Map<String, dynamic>?> getLastTransaction(String userId) async {
    QuerySnapshot<Map<String, dynamic>> document = await _payments
        .orderBy("orderDate", descending: true)
        .where("userId", isEqualTo: userId)
        .limit(1)
        .get();
    return document.docs.first.data();
  }

  //<-------------- Expenses ---------------->
  Stream<QuerySnapshot<Map<String, dynamic>>> expenseStream() {
    return _expenses.orderBy('date', descending: true).snapshots();
  }

  ///Add [Expense] to collection.
  Future<void> recordExpense(
      Map<String, dynamic> expense, String documentId) async {
    try {
      await _expenses.doc(documentId).set(expense);
    } catch (e) {
      print(e);
    }
  }

  ///Delete [Expense] document from collection.
  Future<void> deleteExpense(String? expenseId) async {
    try {
      await _expenses.doc(expenseId).delete();
    } catch (e) {
      print(e);
    }
  }

  ///Update [Expense] .
  Future<void> updateExpense(
      String? expenseId, Map<String, dynamic> document) async {
    try {
      await _expenses.doc(expenseId).update(document);
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> getUserRecords(
      String userId, String year) async {
    DocumentSnapshot<Map<String, dynamic>> result =
        await _users.doc(userId).collection("records").doc(year).get();
    if (result.exists) {
      return result.data();
    } else {
      return null;
    }
  }
}
