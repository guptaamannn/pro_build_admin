import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:pro_build_attendance/views/user/user_view_model.dart';
import 'package:pro_build_attendance/widgets/image_avatar.dart';
import 'package:pro_build_attendance/widgets/info_widget.dart';

class UserView extends StatelessWidget {
  final String userId;

  UserView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserViewModel model = UserViewModel(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model.editUser(userId),
        child: Icon(Icons.edit_outlined),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      body: StreamBuilder<User>(
        stream: model.getUserStream(userId),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }
          if (snapshot.data == null || !snapshot.hasData) {
            return Center(child: Text("No Data"));
          }
          User user = snapshot.data!;
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
                      tag: user.id,
                      child: ImageAvatar(
                        imageUrl: user.dpUrl,
                        name: user.name,
                        radius: 50,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name,
                              softWrap: true,
                              style: Theme.of(context).textTheme.headline5),
                          Text(user.id,
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () {
                      model.callUser(user.phone.toString());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.message_rounded),
                    onPressed: () => model.messageUser(user.phone.toString()),
                  ),
                  IconButton(
                    icon: Icon(Icons.mail),
                    onPressed: () => model.mailUser(user),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_money_rounded),
                    onPressed: () => model.addPayments(user),
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile Details",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Card(
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Info(
                                      type: "Phone",
                                      data: user.phone.toString()),
                                ),
                                Expanded(
                                  child: Info(
                                      type: "E-mail",
                                      data: user.email.toString()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Info(
                                      type: "Address",
                                      data: user.address.toString()),
                                ),
                                Expanded(
                                  child: Info(
                                    type: "Joined-date",
                                    data:
                                        Formatter.fromDateTime(user.joinedDate),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Info(
                                        type: "Expiration-date",
                                        data:
                                            Formatter.fromDateTime(user.eDate),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          DateTime? newDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2021, 02, 01),
                                            lastDate: DateTime(2029, 01, 01),
                                          );
                                          if (newDate != null) {
                                            model.updateEDate(user, newDate);
                                          }
                                        },
                                        child: Text("Update"),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: FutureBuilder<int>(
                                    future: model.useAfterEnd(user),
                                    initialData: 0,
                                    builder: (context,
                                            AsyncSnapshot<int> snapshot) =>
                                        Info(
                                            type: "After Subscription",
                                            data:
                                                "${snapshot.data.toString()} days"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
