import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/core/viewModel/user_model.dart';
import 'package:pro_build_attendance/ui/views/user_view.dart';
import 'package:pro_build_attendance/ui/widgets/dumbbell_spinner.dart';
import 'package:pro_build_attendance/ui/widgets/image_avatar.dart';
import 'package:pro_build_attendance/ui/widgets/navigation_drawer.dart';
import 'package:pro_build_attendance/ui/widgets/sort_button.dart';

import 'package:provider/provider.dart';

class UsersView extends StatelessWidget {
  static const String id = '/users';
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(currentRoute: id),
      appBar: AppBar(
        title: Text("Users"),
        elevation: 0,
      ),
      body: UsersList(),
    );
  }
}

class UsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<UserModel>().getUsersStream(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went Wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: DumbbellSpinner(),
          );
        }

        return Scrollbar(
          interactive: true,
          showTrackOnHover: true,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Sort Users:'),
                actions: [
                  CustomSortButton(
                    title:
                        context.watch<UserModel>().getSortListBy.toUpperCase(),
                    isDescending:
                        context.watch<UserModel>().getIsSortByDescending,
                    onTap: () => context.read<UserModel>().setSortByDescending,
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.sort_rounded),
                    onSelected: (value) =>
                        context.read<UserModel>().setSortListBy(value),
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
                              builder: (context) => UserView(userId: _user.id!),
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
    bool isExpired = DateTime.now().isAfter(user.eDate!);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListTile(
          onTap: onTap,
          leading: ImageAvatar(
            imageUrl: user.dpUrl,
            name: user.name,
          ),
          title: Text(user.name!),
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
