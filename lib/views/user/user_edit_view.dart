import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:pro_build_attendance/views/user/user_edit_model.dart';
import 'package:pro_build_attendance/widgets/image_avatar_updater.dart';
import 'package:pro_build_attendance/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class UserEditView extends HookWidget {
  final User user;

  UserEditView({Key? key, required this.user}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController joinedDateController = useTextEditingController(
      text: Formatter.fromDateTime(user.joinedDate),
    );
    final ValueNotifier<String?> path = useState(null);

    UserEditModel _model = UserEditModel(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          leading: CloseButton(),
          title: Text("Edit Profile"),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
                    await _model.updateUserInfo(
                      user: user,
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
          isLoading: context.watch<Ui>().isLoading,
          child: ListView(
            children: [
              ImageUpdater(
                  url: user.dpUrl.toString(),
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
                        initialValue: user.name,
                        onSaved: (newValue) => user.name = newValue.toString(),
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
                        initialValue: user.phone,
                        onSaved: (newValue) => user.phone = newValue,
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
                        initialValue: user.email,
                        onSaved: (newValue) => user.email = newValue,
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
                        initialValue: user.address,
                        onSaved: (newValue) => user.address = newValue,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      Divider(color: Colors.transparent),
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          DateTime? _joinedDate = await showDatePicker(
                            context: context,
                            initialDate: user.joinedDate != null
                                ? DateTime.now()
                                : user.joinedDate!,
                            firstDate: DateTime(2021),
                            lastDate: DateTime.now(),
                          );
                          if (_joinedDate != null) {
                            user.joinedDate = _joinedDate;
                            joinedDateController.text =
                                Formatter.fromDateTime(_joinedDate);
                            print(_joinedDate);
                          }
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today_rounded),
                          labelText: "Joined Date",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        controller: joinedDateController,
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
