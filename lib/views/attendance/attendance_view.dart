import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/attendance.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:pro_build_attendance/views/forms/attendance_form.dart';
import 'package:pro_build_attendance/views/forms/user_create_form.dart';
import 'package:pro_build_attendance/views/attendance/attendance_list_tile.dart';
import 'package:pro_build_attendance/views/attendance/attendanceModel.dart';
import 'package:pro_build_attendance/views/user/user_view.dart';
import 'package:pro_build_attendance/views/users/users_view.dart';
import 'package:pro_build_attendance/widgets/date_pill.dart';
import 'package:pro_build_attendance/widgets/no_data_image.dart';
import 'package:provider/provider.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AttendanceViewModel model = AttendanceViewModel(context);

    return StreamBuilder<Attendance>(
        stream: model.attendeeStream(context.watch<Ui>().getSelectedDate()),
        builder: (context, snapshot) {
          return FullView(
            snapshot: snapshot,
            model: model,
          );
        });
  }
}

class FullView extends StatelessWidget {
  final AsyncSnapshot<Attendance> snapshot;
  final AttendanceViewModel model;

  const FullView({Key? key, required this.snapshot, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: buildFloationActionButton(context),
      body: snapshot.connectionState == ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: !snapshot.hasData || snapshot.data!.userIds!.isEmpty
                  ? Center(child: NoDataSign())
                  : snapshot.hasError
                      ? Center(
                          child: Text("Something wrong"),
                        )
                      : AttendanceList(model: snapshot.data!),
            ),
    );
  }

  FloatingActionButton buildFloationActionButton(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return AttendanceForm(
                snapshot.data == null ? null : snapshot.data!);
          },
        );
      },
      child: Icon(Icons.add),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: TextButton(
        onPressed: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: context.read<Ui>().getSelectedDate(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            context.read<Ui>().updateViewDate(selectedDate);
          }
        },
        child: Text(Formatter.toMonth(
          context.watch<Ui>().getSelectedDate(),
        )),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'create-user') {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return UserAttendanceAdd(
                        model: model, usersList: snapshot.data?.userIds);
                  },
                );
              } else if (value == 'all-users') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UsersView()));
              } else if (value == 'log-out') {
                model.logOut();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Create User")
                    ],
                  ),
                  value: "create-user",
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.people_alt_outlined),
                      SizedBox(width: 8),
                      Text("All Users"),
                    ],
                  ),
                  value: 'all-users',
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.logout_outlined),
                      SizedBox(width: 8),
                      Text("Log Out")
                    ],
                  ),
                  value: 'log-out',
                )
              ];
            })
      ],
      bottom: buildCalendarAppBar(context),
    );
  }

  AppBar buildCalendarAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      automaticallyImplyLeading: false,
      toolbarHeight: 90,
      title: Container(
        height: 65,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          cacheExtent: 12,
          reverse: true,
          itemBuilder: (context, index) {
            return DatePill(
              date: DateTime.now().subtract(Duration(days: index)),
              selectedDate: context.watch<Ui>().getSelectedDate(),
              onTap: (DateTime value) {
                context.read<Ui>().updateViewDate(value);
              },
            );
          },
        ),
      ),
    );
  }
}

///Returns a [ListView] of users in attendance
class AttendanceList extends StatelessWidget {
  final Attendance model;

  const AttendanceList({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemExtent: 85,
      itemCount: model.userIds!.length,
      reverse: true,
      itemBuilder: (context, index) {
        if (model.users?.first.attendTime != null) {
          model.users!
              .sort((a, b) => a.attendTime!.compareTo(b.attendTime.toString()));
        }
        String? lastTime;
        if (index < model.userIds!.length - 1) {
          lastTime = model.users!.reversed.toList()[index + 1].attendTime;
        }

        User _user = model.users!.reversed.toList()[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AttendanceListTile(
            isSubExpired:
                AttendanceViewModel(context).isSubExpired(_user.eDate),
            user: _user,
            showTime: lastTime != null ? lastTime == _user.attendTime : null,
            onLongPress: () {
              AttendanceViewModel(context).deleteAttendee(user: _user);
            },
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserView(userId: model.users!.reversed.toList()[index].id),
              ),
            ),
          ),
        );
      },
    );
  }
}
