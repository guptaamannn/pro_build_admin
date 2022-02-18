import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_attendance/core/enums/view_state.dart';
import 'package:pro_build_attendance/core/model/attendance.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/core/viewModel/attendance_model.dart';
import 'package:pro_build_attendance/locator.dart';
import 'package:pro_build_attendance/ui/views/search_view.dart';
import 'package:pro_build_attendance/ui/views/user_view.dart';
import 'package:pro_build_attendance/ui/widgets/autocomplete_user_search.dart';
import 'package:pro_build_attendance/ui/widgets/bottom_navigation_bar.dart';
import 'package:pro_build_attendance/ui/widgets/date_pill.dart';
import 'package:pro_build_attendance/ui/widgets/dumbbell_spinner.dart';
import 'package:pro_build_attendance/ui/widgets/error_dialog.dart';
import 'package:pro_build_attendance/ui/widgets/image_avatar.dart';
import 'package:pro_build_attendance/ui/widgets/loading_overlay.dart';
import 'package:pro_build_attendance/ui/widgets/no_data_image.dart';
import 'package:pro_build_attendance/ui/widgets/user_create_form.dart';

import 'package:provider/provider.dart';

class AttendanceView extends StatelessWidget {
  static const String id = '/attendance';
  const AttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar _buildCalendarAppBar(BuildContext context) {
      return AppBar(
        elevation: 0,
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
                selectedDate:
                    context.watch<AttendanceModel>().getSelectedDate(),
                onTap: (DateTime value) {
                  context.read<AttendanceModel>().updateViewDate(value);
                },
              );
            },
          ),
        ),
      );
    }

    AppBar _buildAppBar(BuildContext context) {
      return AppBar(
        title: Text("Daily Records"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                User? result = await showSearch<User?>(
                    context: context, delegate: CustomSearchDelegate());
                if (result != null) {
                  Navigator.pushNamed(context, UserView.id,
                      arguments: result.id);
                }
              },
              icon: Icon(Icons.search)),
          IconButton(
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: context.read<AttendanceModel>().getSelectedDate(),
                firstDate: DateTime(2021),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                context.read<AttendanceModel>().updateViewDate(selectedDate);
              }
            },
            icon: Icon(Icons.calendar_today_rounded),
          ),
        ],
        bottom: _buildCalendarAppBar(context),
      );
    }

    Widget _buildFloatingActionButton(
        BuildContext context, AttendanceModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            heroTag: "something",
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return UserAttendanceAdd();
                },
              );
            },
            child: Icon(Icons.person_add),
            mini: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return AttendanceForm(model);
                },
              );
              print("Add User");
            },
            child: Icon(Icons.add),
          ),
        ],
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<AttendanceModel>())
      ],
      child: Consumer<AttendanceModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: _buildAppBar(context),
            // drawer: NavigationDrawer(
            //   currentRoute: AttendanceView.id,
            // ),
            bottomNavigationBar: Hero(
                tag: "nav",
                child: CustomBottomNavigation(
                  currentRoute: id,
                )),
            floatingActionButton:
                _buildFloatingActionButton(context, viewModel),
            body: ModalProgressIndicator(
              isLoading: viewModel.state == ViewState.busy,
              child: StreamBuilder<Attendance>(
                stream: viewModel.attendanceStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: DumbbellSpinner());
                  }
                  if (snapshot.data == null ||
                      !snapshot.hasData ||
                      snapshot.data!.userIds!.isEmpty) {
                    return Center(child: NoDataSign());
                  }
                  if (snapshot.hasError) {
                    print("Somethings is wrong");
                  }

                  Attendance model = snapshot.data!;
                  viewModel.setCurrentAttendance(model);

                  return ListView.builder(
                    addAutomaticKeepAlives: true,
                    cacheExtent: 80,
                    itemExtent: 85,
                    itemCount: model.userIds!.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (model.users?.first.attendTime != null) {
                        model.users!.sort((a, b) =>
                            Formatter.stringToTimeOfDay(a.attendTime!)
                                .toString()
                                .compareTo(
                                    Formatter.stringToTimeOfDay(b.attendTime!)
                                        .toString()));
                      }
                      String? lastTime;
                      if (index < model.userIds!.length - 1) {
                        lastTime = model.users!.reversed
                            .toList()[index + 1]
                            .attendTime;
                      }

                      User _user = model.users!.reversed.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AttendanceListTile(
                          isSubExpired: _user.eDate!
                              .isBefore(viewModel.getSelectedDate()),
                          user: _user,
                          showTime: lastTime != null
                              ? lastTime == _user.attendTime
                              : null,
                          onLongPress: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.delete_forever_rounded,
                                      size: 30,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  content: Text(
                                    '''Are you sure you want to remove ${_user.name!.split(" ")[0]} from the records of ${Formatter.fromDateTime(viewModel.getSelectedDate())} ?''',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel")),
                                    TextButton(
                                      onPressed: () async {
                                        await viewModel.deleteAttendee(
                                            user: _user);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Delete",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserView(
                                    userId: model.users!.reversed
                                        .toList()[index]
                                        .id!),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class AttendanceListTile extends StatelessWidget {
  const AttendanceListTile({
    Key? key,
    required this.user,
    this.onTap,
    this.onLongPress,
    required this.isSubExpired,
    this.showTime,
  }) : super(key: key);

  final User user;
  final Function? onTap;
  final bool isSubExpired;
  final bool? showTime;
  final Function? onLongPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  child: Text(
                    showTime == null || showTime == false
                        ? user.attendTime.toString()
                        : "",
                  ),
                ),
                VerticalDivider(
                  thickness: 2,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: onTap == null ? null : () => onTap!(),
              onLongPress: onLongPress == null ? null : () => onLongPress!(),
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    gradient: isSubExpired
                        ? LinearGradient(stops: [
                            0.01,
                            0.01
                          ], colors: [
                            Colors.red,
                            Theme.of(context).colorScheme.surfaceVariant
                          ])
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 9,
                        offset: Offset(3, 3),
                      )
                    ]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: user.id!,
                      child: CachedImageAvatar(
                        key: Key(user.id!),
                        name: user.name,
                        fileName: user.id!,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.name!,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.subtitle1),
                          Text(Formatter.fromDateTime(user.eDate),
                              style: Theme.of(context).textTheme.caption!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceForm extends HookWidget {
  final AttendanceModel model;

  AttendanceForm(this.model);
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<TimeOfDay?> timeState = useState(null);
    final ValueNotifier<String> filterBy = useState('name');

    void onSelected(User user) async {
      print(user.name);
      try {
        await model.addUserToAttendance(
          user: user,
          time: timeState.value == null
              ? TimeOfDay.now().format(context)
              : timeState.value!.format(context),
        );
        Navigator.pop(context);
      } catch (e) {
        print(e);
        if (e == 'duplicate-entry') {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              message: "${user.name} is already added to the list.",
              icon: Icons.error_outline_rounded,
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          );
        }
      }
    }

    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 2, 12, bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchUser(
            searchUsing: filterBy.value,
            onSelected: onSelected,
            keyboardType:
                filterBy.value == 'phone' ? TextInputType.phone : null,
          ),
          Container(
            height: 4,
          ),
          Row(
            children: [
              ChoiceChip(
                label: Text("Name"),
                selected: filterBy.value == 'name',
                onSelected: (value) => filterBy.value = 'name',
                avatar: Icon(
                  Icons.person_outline_rounded,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              ChoiceChip(
                label: Text("Phone"),
                selected: filterBy.value == 'phone',
                onSelected: (value) => filterBy.value = 'phone',
                avatar: Icon(Icons.phone_enabled_outlined, size: 20),
              ),
              Spacer(),
              IconButton(
                onPressed: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (time != null) {
                    timeState.value = time;
                  }
                },
                icon: Icon(Icons.timer_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
