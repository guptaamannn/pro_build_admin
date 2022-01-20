import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:pro_build_attendance/widgets/image_avatar.dart';

class AttendanceListTile extends StatelessWidget {
  final User user;
  final Function? onTap;
  final bool isSubExpired;
  final bool? showTime;
  final Function? onLongPress;

  const AttendanceListTile({
    Key? key,
    required this.user,
    this.onTap,
    this.onLongPress,
    required this.isSubExpired,
    this.showTime,
  }) : super(key: key);

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
                  color: isSubExpired ? Colors.red[200] : Colors.teal[100],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                        tag: user.id,
                        child:
                            ImageAvatar(name: user.name, imageUrl: user.dpUrl)),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            Formatter.fromDateTime(user.eDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                            ),
                          ),
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
