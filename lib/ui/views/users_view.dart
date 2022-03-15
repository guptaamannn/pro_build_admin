import 'package:flutter/material.dart';
import '/core/model/user.dart';
import '/core/viewModel/user_model.dart';
import '/ui/views/search_view.dart';
import '/ui/views/user_edit_view.dart';
import '/ui/views/user_view.dart';
import '/ui/widgets/bottom_navigation_bar.dart';
import '/ui/widgets/dumbbell_spinner.dart';
import '/ui/widgets/image_avatar.dart';

import 'package:provider/provider.dart';

class UsersView extends StatelessWidget {
  static const String id = '/users';
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawer(currentRoute: id),
      bottomNavigationBar:
          Hero(tag: "nav", child: CustomBottomNavigation(currentRoute: id)),
      appBar: AppBar(
        title: const Text("Pro Build"),
        actions: [
          IconButton(
              onPressed: () async {
                User? result = await showSearch<User?>(
                    context: context, delegate: CustomSearchDelegate());
                if (result != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserView(
                                userId: result.id!,
                              )));
                }
              },
              icon: const Icon(Icons.search_rounded))
        ],
        bottom: AppBar(
          title: const Text("Users"),
          automaticallyImplyLeading: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserEditView()));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<Iterable<User>>(
        stream: context.read<UserModel>().getUsersStream(),
        builder:
            (BuildContext context, AsyncSnapshot<Iterable<User>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went Wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: DumbbellSpinner(),
            );
          }

          return Scrollbar(
            interactive: true,
            showTrackOnHover: true,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      User _user = snapshot.data!.toList()[index];
                      return ListTile(
                        leading: Text(
                          index == 0
                              ? _user.name![0]
                              : _user.name![0] ==
                                      snapshot.data!
                                          .toList()[index - 1]
                                          .name![0]
                                  ? ""
                                  : _user.name![0],
                        ),
                        title: Row(children: [
                          CachedImageAvatar(
                            fileName: _user.id!,
                            name: _user.name,
                            key: Key(_user.id!),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_user.name!),
                              Text(
                                _user.phone!,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          )
                        ]),
                        minVerticalPadding: 12,
                        onTap: () {
                          Navigator.pushNamed(context, UserView.id,
                              arguments: _user.id);
                        },
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
