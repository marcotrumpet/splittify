import 'package:app/app_router.dart';
import 'package:app/common/user_model.dart';
import 'package:app/firebase_options.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: ui.SignInScreen(
        providers: [
          ui.EmailAuthProvider(),
          if (!kIsWeb)
            GoogleProvider(
              iOSPreferPlist: true,
              clientId: Platform.isIOS
                  ? DefaultFirebaseOptions.currentPlatform.iosClientId!
                  : DefaultFirebaseOptions.currentPlatform.androidClientId!,
            ),
        ],
        actions: [
          ui.AuthStateChangeAction<ui.SignedIn>(
            (context, state) async {
              if (auth.FirebaseAuth.instance.currentUser != null) {
                final docs = await FirebaseFirestore.instance
                    .collection('users')
                    .withConverter<UserModel>(
                      fromFirestore: (snapshot, _) =>
                          UserModel.fromJson(snapshot.data()!),
                      toFirestore: (user, _) => user.toJson(),
                    )
                    .get();

                final idx = docs.docs.indexWhere((doc) {
                  return doc.data().email ==
                      (auth.FirebaseAuth.instance.currentUser!.email ?? '');
                });

                if (idx == -1) {
                  await FirebaseFirestore.instance.collection('users').add(
                        UserModel(
                          email: auth.FirebaseAuth.instance.currentUser!.email!,
                          name: auth.FirebaseAuth.instance.currentUser!
                                  .displayName ??
                              auth.FirebaseAuth.instance.currentUser!.email!,
                        ).toJson(),
                      );
                }

                // ignore: use_build_context_synchronously
                await context.router.navigate(const HomeRoute());
              }
            },
          ),
        ],
      ),
    );
  }
}
