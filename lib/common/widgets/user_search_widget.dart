import 'dart:async';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:app/common/user_model.dart';
import 'package:flutter/material.dart';

const Duration debounceDuration = Duration(milliseconds: 500);

class UserSearchWidget extends StatefulWidget {
  const UserSearchWidget({
    required this.onUserSelected,
    super.key,
  });

  final void Function(UserModel) onUserSelected;

  @override
  State<UserSearchWidget> createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchWidget> {
  late String? _currentQuery;
  late final HitsSearcher hitSearcher;
  final searchController = SearchController();

  Stream<List<UserModel>> _search(String query) {
    _currentQuery = query;

    hitSearcher.query(_currentQuery!);

    final searchMetadata = hitSearcher.responses.map(
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

    return searchMetadata;
  }

  @override
  void initState() {
    super.initState();
    hitSearcher = HitsSearcher(
      applicationID: 'L52SONBEWP',
      apiKey: '8a8bdc393f20e051f37af065299ebbea',
      indexName: 'users_index',
      debounce: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      // builder: (BuildContext context, SearchController controller) {
      //   return OutlinedButton(
      //     onPressed: () {
      //       controller.openView();
      //     },
      //     child: const Text('Seleziona destinatario'),
      //   );
      // },
      barHintText: 'Cerca destinatario',
      barElevation: WidgetStateProperty.all(0),
      viewHeaderHeight: kToolbarHeight,
      searchController: searchController,
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        if (controller.text.isEmpty) return [];

        var child = <ListTile>[];
        await _search(controller.text).firstWhere(
          (event) {
            if (event.isEmpty) {
              return false;
            }
            child = List<ListTile>.generate(
              event.length,
              (int index) => ListTile(
                title: Text(event[index].name),
                subtitle: Text(event[index].email),
                onTap: () {
                  widget.onUserSelected(event[index]);
                  controller.closeView('');
                },
              ),
            );
            return true;
          },
        );

        return child;
      },
    );
  }
}
