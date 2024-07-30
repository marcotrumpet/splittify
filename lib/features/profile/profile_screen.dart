import 'package:app/app_router.dart';
import 'package:app/common/user_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ui.ProfileScreen(
      appBar: kIsWeb
          ? null
          : AppBar(
              title: const Text('Profilo'),
            ),
      actions: [
        ui.SignedOutAction((context) {
          context.router.navigate(const LoginRoute());
        }),
        ui.DisplayNameChangedAction(
          (context, oldName, newName) async {
            try {
              final docs = await FirebaseFirestore.instance
                  .collection('users')
                  .withConverter<UserModel>(
                    fromFirestore: (snapshot, _) =>
                        UserModel.fromJson(snapshot.data()!),
                    toFirestore: (user, _) => user.toJson(),
                  )
                  .get();

              for (final doc in docs.docs) {
                final el = doc.data();
                if (el.email ==
                    (FirebaseAuth.instance.currentUser!.email ?? '')) {
                  await doc.reference.set(
                    UserModel(name: newName, email: el.email),
                  );
                }
              }
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        ),
      ],
    );
  }
}
