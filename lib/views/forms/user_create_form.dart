import 'package:flutter/material.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/views/attendance/attendanceModel.dart';
import 'package:pro_build_attendance/widgets/error_dialog.dart';
import 'package:pro_build_attendance/widgets/image_avatar_updater.dart';
import 'package:provider/provider.dart';

class UserAttendanceAdd extends StatefulWidget {
  final AttendanceViewModel model;
  final List<String>? usersList;
  UserAttendanceAdd({required this.model, this.usersList});

  @override
  State<UserAttendanceAdd> createState() => _UserAttendanceAddState();
}

class _UserAttendanceAddState extends State<UserAttendanceAdd> {
  final _formKey = GlobalKey<FormState>();
  Map formData = {
    "name": "",
    "phone": "",
    "countryCode": "+977",
    "imagePath": null,
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      // Adds padding so that bottom sheet remains above the keyboard.
      padding: EdgeInsets.fromLTRB(
          12, 20, 12, MediaQuery.of(context).viewInsets.bottom),
      child: context.watch<Ui>().isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUpdater(
                    onChange: (value) {
                      setState(() {
                        formData["imagePath"] = value;
                      });
                    },
                    path: formData["imagePath"],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name must not be empty.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (String value) {
                      formData["name"] = value;
                    },
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          initialValue: "+977",
                          onChanged: (value) {
                            formData["countryCode"] = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "*";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Code",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Phone number required.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Phone",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (String value) {
                            formData["phone"] = formData["countryCode"] + value;
                          },
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await widget.model.createUser(
                              name: formData["name"],
                              phone: formData["phone"],
                              imagePath: formData["imagePath"],
                              usersList: widget.usersList);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => ErrorDialog(
                              icon: Icons.error_outline_rounded,
                              message: "Phone number already registered.",
                              onTap: () => Navigator.popUntil(
                                  context, (route) => route.isFirst),
                            ),
                          );
                        }
                      }
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
            ),
    );
  }
}
