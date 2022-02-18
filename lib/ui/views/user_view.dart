import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/model/invoice.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/core/viewModel/user_model.dart';
import 'package:pro_build_attendance/ui/views/payment_form.dart';
import 'package:pro_build_attendance/ui/views/user_edit_view.dart';
import 'package:pro_build_attendance/ui/widgets/dumbbell_spinner.dart';
import 'package:pro_build_attendance/ui/widgets/image_avatar.dart';
import 'package:pro_build_attendance/ui/widgets/info_widget.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  static const String id = '/user';
  final String userId;

  UserView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel model = context.read<UserModel>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded))
        ],
      ),
      body: StreamBuilder<User>(
        stream: model.getUserStream(userId),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: DumbbellSpinner());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }
          if (snapshot.data == null || !snapshot.hasData) {
            return Center(child: Text("No Data"));
          }
          User user = snapshot.data!;
          return ListView(
            // padding: EdgeInsets.symmetric(horizontal: 18),
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: user.id!,
                      child: CachedImageAvatar(
                        fileName: user.id!,
                        name: user.name,
                        radius: 50,
                        hasDp: user.dpUrl != null,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(user.name!,
                        softWrap: true,
                        style: Theme.of(context).textTheme.headline5),
                    Text(user.id!,
                        style: Theme.of(context).textTheme.subtitle1),
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
                    icon: Icon(Icons.payment_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => PaymentForm(user)));
                    },
                  ),
                ],
              ),
              Divider(),
              Stack(
                children: [
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
                                    type: "Phone", data: user.phone.toString()),
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
                                  data: Formatter.fromDateTime(user.joinedDate),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Info(
                                      type: "Expiration-date",
                                      data: Formatter.fromDateTime(user.eDate),
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
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () async {
                        User user = await model.editUser(userId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserEditView(user: user),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit_outlined),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              Text("Last Transaction",
                  style: Theme.of(context).textTheme.labelLarge),
              FutureBuilder<Invoice?>(
                  future: model.getLastTransaction(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return DumbbellSpinner();
                    }
                    if (snapshot.data == null || !snapshot.hasData) {
                      return Text("No transactions found.");
                    }
                    return ListTile(
                      leading: Text(
                          Formatter.dayAndMonth(snapshot.data!.orderDate!)),
                      title: Text(snapshot.data!.invoiceId!),
                      subtitle: Text(Formatter.fromDateTime(
                              snapshot.data!.order!.first.validFrom) +
                          " ▶︎ " +
                          Formatter.fromDateTime(
                              snapshot.data!.order!.first.validTill)),
                      trailing: Text("Rs " + snapshot.data!.totalAmount!),
                      // isThreeLine: true,
                    );
                  }),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("View all"),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
