import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '/core/model/user.dart';
import '/core/viewModel/user_model.dart';
import 'package:provider/provider.dart';

///Autocomplete search for users.
class SearchUser extends StatelessWidget {
  // final AttendanceViewModel model;
  final String searchUsing;
  final TextInputType? keyboardType;
  final Function(User) onSelected;

  const SearchUser({
    Key? key,
    required this.onSelected,
    required this.searchUsing,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<User>(
      direction: AxisDirection.up,
      suggestionsCallback: (query) async {
        if (query == "") {
          return const Iterable.empty();
        }

        Iterable<User> store;
        searchUsing == 'name'
            ? store = context
                .read<UserModel>()
                .getUsers
                .where((element) => element.name!.contains(query))
            : store = context
                .read<UserModel>()
                .getUsers
                .where((element) => element.phone!.contains(query));

        if (store.isNotEmpty) return store;
        return await context.read<UserModel>().searchUser(query, searchUsing);
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      noItemsFoundBuilder: (context) => Container(
          height: 50,
          alignment: Alignment.center,
          child: const Text("No Result!")),
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        keyboardType:
            searchUsing == 'name' ? TextInputType.text : TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Search User",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      itemBuilder: (context, User user) {
        return ListTile(
          leading: user.dpUrl != null || user.dpUrl == ""
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.dpUrl.toString(),
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) {
                      return CircularProgressIndicator(
                        value: progress.progress,
                      );
                    },
                  ),
                )
              : const CircleAvatar(
                  child: Icon(Icons.person),
                ),
          title: Text(user.name!),
        );
      },
      onSuggestionSelected: (User user) {
        onSelected(user);
      },
    );
  }
}
