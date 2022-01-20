import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:pro_build_attendance/views/user/user_view.dart';
import 'package:pro_build_attendance/views/users/users_view_model.dart';
import 'package:pro_build_attendance/widgets/image_avatar.dart';
import 'package:pro_build_attendance/widgets/sort_button.dart';
import 'package:provider/provider.dart';

class UsersView extends StatelessWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: UsersList(),
    );
  }
}

class UsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UsersViewModel model = UsersViewModel(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: model.getUsersStream(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went Wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scrollbar(
          interactive: true,
          showTrackOnHover: true,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Sort Users:'),
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                actions: [
                  CustomSortButton(
                    title: context.watch<Ui>().getSortListBy.toUpperCase(),
                    isDescending: context.watch<Ui>().getIsSortByDescending,
                    onTap: () => context.read<Ui>().setSortByDescending,
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.sort_rounded),
                    onSelected: (value) =>
                        context.read<Ui>().setSortListBy(value),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        child: Text('Name'),
                        value: 'name',
                      ),
                      PopupMenuItem<String>(
                        child: Text('Joined Date'),
                        value: 'joinedDate',
                      ),
                      PopupMenuItem<String>(
                        child: Text('Expiry Date'),
                        value: 'eDate',
                      ),
                    ],
                  ),
                ],
                floating: true,
                automaticallyImplyLeading: false,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    User _user =
                        User.fromUsers(snapshot.data!.docs[index].data());
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: UsersListCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserView(userId: _user.id),
                            ),
                          );
                        },
                        user: _user,
                      ),
                    );
                  },
                  childCount: snapshot.data!.docs.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UsersListCard extends StatelessWidget {
  final void Function() onTap;
  final User user;

  const UsersListCard({Key? key, required this.onTap, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isExpired = DateTime.now().isAfter(user.eDate);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListTile(
          onTap: onTap,
          leading: ImageAvatar(
            imageUrl: user.dpUrl,
            name: user.name,
          ),
          title: Text(user.name),
          subtitle: Text("${user.phone}"),
          trailing: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color:
                  isExpired ? Colors.redAccent[100] : Colors.greenAccent[100],
            ),
            child: Text(
              Formatter.fromDateTime(user.eDate),
              style: TextStyle(color: Colors.black),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        Divider(),
      ],
    );
  }
}
