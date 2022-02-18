import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_attendance/core/enums/view_state.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/core/viewModel/user_model.dart';
import 'package:pro_build_attendance/ui/widgets/image_avatar_updater.dart';
import 'package:pro_build_attendance/ui/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class UserEditView extends HookWidget {
  final User? user;

  UserEditView({Key? key, this.user}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String?> path = useState(null);
    final ValueNotifier<User> userState =
        useState(user != null ? user! : User());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: CloseButton(),
          title: Text(
            user != null ? "Edit Profile" : "Create Profile",
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
                    await context.read<UserModel>().updateUserInfo(
                          user: userState.value,
                          dp: path.value,
                        );
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
              ),
            )
          ],
        ),
        body: ModalProgressIndicator(
          isLoading: context.watch<UserModel>().state == ViewState.busy,
          child: ListView(
            children: [
              ImageUpdater(
                  url: user?.dpUrl.toString(),
                  path: path.value,
                  onChange: (value) {
                    path.value = value;
                  }),
              Divider(color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.person_outline_rounded),
                          labelText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        initialValue: user?.name,
                        onSaved: (newValue) =>
                            userState.value.name = newValue.toString(),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name must not be empty.";
                          }
                          return null;
                        },
                      ),
                      Divider(color: Colors.transparent),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.phone_outlined),
                          labelText: "Phone",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        initialValue: userState.value.phone,
                        onSaved: (newValue) => userState.value.phone = newValue,
                        keyboardType: TextInputType.phone,
                      ),
                      Divider(color: Colors.transparent),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.email_outlined),
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        initialValue: userState.value.email,
                        onSaved: (newValue) => userState.value.email = newValue,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Divider(color: Colors.transparent),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.location_on_outlined),
                          labelText: "Address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        initialValue: userState.value.address,
                        onSaved: (newValue) =>
                            userState.value.address = newValue,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      Divider(color: Colors.transparent),
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          DateTime? _joinedDate = await showDatePicker(
                            context: context,
                            initialDate: userState.value.joinedDate != null
                                ? DateTime.now()
                                : userState.value.joinedDate!,
                            firstDate: DateTime(2021),
                            lastDate: DateTime.now(),
                          );
                          if (_joinedDate != null) {
                            userState.value.joinedDate = _joinedDate;
                          }
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today_rounded),
                          labelText: "Joined Date",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        initialValue: Formatter.fromDateTime(DateTime.now()),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
