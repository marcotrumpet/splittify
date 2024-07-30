import 'package:app/features/create_found_raise/found_raise_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart';

@RoutePage()
class MyCollectionScreen extends StatelessWidget {
  const MyCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('found_raise')
        .withConverter<FoundRaiseModel>(
          fromFirestore: (snapshot, _) =>
              FoundRaiseModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        )
        .orderBy('creationDate', descending: true)
        .where(
          'creatorEmail',
          isEqualTo: FirebaseAuth.instance.currentUser!.email,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FirestoreQueryBuilder<FoundRaiseModel>(
        query: query,
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          }

          return ListView.separated(
            itemCount: snapshot.docs.length,
            separatorBuilder: (context, index) =>
                const SizedBox.square(dimension: 16),
            itemBuilder: (context, index) {
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                snapshot.fetchMore();
              }

              final model = snapshot.docs[index].data();

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(model.recipientEmail),
                      Text(model.fee.toString()),
                      Text(model.goal.toString()),
                      Text(model.creatorEmail),
                      Text(
                        '${DateFormat.yMMMMd(Platform.localeName).format(
                          DateTime.parse(model.creationDate),
                        )} - ${DateFormat.Hm(Platform.localeName).format(
                          DateTime.parse(model.creationDate),
                        )}',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
