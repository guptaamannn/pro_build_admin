import 'package:flutter/material.dart';
import '/core/enums/view_state.dart';
import '/core/viewModel/user_model.dart';
import '/ui/widgets/dumbbell_spinner.dart';
import 'package:provider/provider.dart';

import 'error_dialog.dart';
import 'image_avatar_updater.dart';

class UserAttendanceAdd extends StatefulWidget {
  // final AttendanceViewModel model;
  final List<String>? usersList;
  const UserAttendanceAdd({key, this.usersList}) : super(key: key);

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
      child: context.watch<UserModel>().state == ViewState.busy
          ? const Center(
              child: DumbbellSpinner(),
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
                  const SizedBox(
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
                  const SizedBox(height: 12),
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
                      const SizedBox(width: 10),
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
                          await context.read<UserModel>().createUser(
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
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
    );
  }
}
