import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:app/common/user_model.dart';
import 'package:flutter/material.dart';

class UserSearchDelegate extends SearchDelegate<List<UserModel>> {
  UserSearchDelegate({
    required String hintText,
    required this.onUserSelected,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  final void Function(UserModel) onUserSelected;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const CloseButtonIcon(),
        onPressed: () {
          query = '';
          // When pressed here the query will be cleared from the search bar.
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () => Navigator.of(context).pop(),
      // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productsSearcher = HitsSearcher(
      applicationID: const String.fromEnvironment('applicationID'),
      apiKey: const String.fromEnvironment('apiKey'),
      indexName: 'users_index',
    );

    final searchMetadata = productsSearcher.responses.map(
      (e) {
        final list = <UserModel>[];
        for (final hit in e.hits) {
          list.add(
            UserModel(
              name: hit['name'] as String,
              email: hit['email'] as String,
            ),
          );
        }
        return list;
      },
    );

    return StreamBuilder<List<UserModel>>(
      stream: searchMetadata,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final list = snapshot.data ?? [];

        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (context, index) =>
              const SizedBox.square(dimension: 16),
          itemBuilder: (context, index) {
            final model = list[index];

            return ListTile(
              title: Text(model.name),
              subtitle: Text(model.email),
              onTap: () {
                onUserSelected(model);
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
