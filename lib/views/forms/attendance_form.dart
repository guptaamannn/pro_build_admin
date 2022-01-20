import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_attendance/model/attendance.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/views/attendance/attendanceModel.dart';
import 'package:pro_build_attendance/views/forms/autocomplete_user_search.dart';
import 'package:pro_build_attendance/widgets/error_dialog.dart';

///Form to add user in attendance record
class AttendanceForm extends HookWidget {
  final Attendance? attendance;

  AttendanceForm(this.attendance);

  @override
  Widget build(BuildContext context) {
    final AttendanceViewModel model = AttendanceViewModel(context);
    final ValueNotifier<TimeOfDay?> timeState = useState(null);
    final ValueNotifier<String> filterBy = useState('name');

    void onSelected(User user) async {
      try {
        await model.addAttendee(
            user: user,
            time: timeState.value == null ? TimeOfDay.now() : timeState.value!,
            currentRecord: attendance?.userIds);
        Navigator.pop(context);
      } catch (e) {
        if (e == 'duplicate-entry') {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              message: "User already added.",
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
            model: model,
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
