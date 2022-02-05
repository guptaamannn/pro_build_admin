import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/locator.dart';
import 'package:pro_build_attendance/ui/widgets/image_avatar.dart';

import '../../core/viewModel/user_model.dart';

class CustomSearchDelegate extends SearchDelegate<User?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  TextInputType? get keyboardType => TextInputType.name;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  void close(BuildContext context, User? result) {
    super.close(context, result);
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than three letters.",
            ),
          )
        ],
      );
    }
    final model = locator<UserModel>();
    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        FutureBuilder(
          future: model.searchUser(query, 'name'),
          builder: (context, AsyncSnapshot<Iterable<User>> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data!.toList().length == 0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "No Results Found.",
                  ),
                ],
              );
            } else {
              var results = snapshot.data!.toList();
              return Container(
                height: 400,
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    User result = results[index];
                    return ListTile(
                      leading: ImageAvatar(
                          imageUrl: result.dpUrl, name: result.name),
                      title: Text(result.name!),
                      subtitle: Text(result.phone!),
                      onTap: () {
                        close(context, result);
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column(
      mainAxisSize: MainAxisSize.min,
    );
  }
}
