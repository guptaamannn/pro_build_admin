import 'dart:io';

import 'package:nanoid/async.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_build_admin/core/model/user_record.dart';
import '/core/enums/view_state.dart';
import '/core/model/invoice.dart';
import '/core/model/user.dart';
import '/core/services/firestore_service.dart';
import '/core/services/storage_service.dart';
import '/core/services/url_launch_service.dart';
import '/core/viewModel/base_model.dart';
import '/locator.dart';

class UserModel extends BaseModel {
  final FirestoreService _firestore = locator<FirestoreService>();
  final _storage = locator<StorageService>();

  List<User>? _cachedUsers;

  List<User>? get getCachedUsers => _cachedUsers;

  void updateCachedUsers(User user) {
    _cachedUsers == null ? _cachedUsers = [user] : _cachedUsers!.add(user);
    notifyListeners();
  }

  String? _tempDirPath;

  Future<String?> getCacheDpPath(String userId) async {
    if (_tempDirPath == null) {
      var directory = await getTemporaryDirectory();
      _tempDirPath = directory.path;
    }

    final file = File('$_tempDirPath/$userId');
    if (!file.existsSync()) {
      return null;
    }

    return file.path;
  }

  ///Create [User]
  Future<void> createUser(
      {required String name,
      required String phone,
      String? imagePath,
      List<String>? usersList}) async {
    setState(ViewState.busy);
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
    } else {
      throw 'duplicate-phone';
    }
    setState(ViewState.idle);
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
      for (var element in users) {
        updateCachedUsers(element);
      }
      return users;
    }
    return const Iterable.empty();
  }

  Future<String?> downloadUserDp(String fileName) async {
    var fromMemory = await getCacheDpPath(fileName);
    if (fromMemory != null) {
      return fromMemory;
    }

    return await _storage.downloadDp(fileName);
  }

  Stream<User> getUserStream(String documentId) {
    return FirestoreService()
        .getUserStream(documentId)
        .map((e) => User.fromUsers(e.data()));
  }

  Future<void> updateEDate(User user, DateTime date) async {
    await _firestore.updateEDate(user.id!, date);
  }

  Future<void> callUser(String phone) async {
    UrlService().call(phone);
  }

  Future<void> messageUser(String phone) async {
    UrlService().message(phone);
  }

  void mailUser(User user) async {
    if (user.email != null && user.email != "" && user.email!.isNotEmpty) {
      UrlService().mail(user.email!);
    }
  }

  Future<User> editUser(String userId) async {
    var snapshot = await _firestore.getUser(userId);
    User user = User.fromUsers(snapshot.data());
    return user;
  }

  Future<int> useAfterEnd(User user) async {
    if (user.eDate!.isBefore(DateTime.now())) {
      int days = await _firestore.daysAfterExp(user.id!, user.eDate!);
      return days;
    } else {
      return 0;
    }
  }

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

  Stream<Iterable<User>> getUsersStream() {
    return _firestore
        .getUsersStream(
          sortBy: _sortBy,
          sortByDescending: _isSortByDescending,
        )
        .map((event) => event.docs.map((e) => User.fromUsers(e.data())));
  }

  Future<void> updateUserInfo({required User user, String? dp}) async {
    setState(ViewState.busy);
    if (dp != null) {
      String? imageUrl = await _storage.uploadPicture(File(dp), user.id!);
      user.dpUrl = imageUrl;
    }

    await _firestore.updateUserInfo(user.id!, user.toJson());
    setState(ViewState.idle);
  }

  final List<User> _users = [];

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

  Future<Invoice?> getLastTransaction(String userId) async {
    Map<String, dynamic>? snapshot =
        await _firestore.getLastTransaction(userId);
    if (snapshot != null) {
      Invoice invoice = Invoice.fromJson(snapshot);
      return invoice;
    }
    return null;
  }

  Future<UserRecord?> getUserRecords(String userId) async {
    Map<String, dynamic>? data =
        await _firestore.getUserRecords(userId, "2022");
    if (data != null) {
      UserRecord record = UserRecord.fromJson(data);
      return record;
    }
    return null;
  }

  Future<void> refreshDp(String userId) async {
    await _storage.downloadDp(userId);
  }
}
