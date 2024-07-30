import 'package:app/common/route_guard.dart';
import 'package:app/features/create_found_raise/create_found_raise_screen.dart';
import 'package:app/features/home/home_screen.dart';
import 'package:app/features/home/invited_collection_screen.dart';
import 'package:app/features/home/my_collection_screen.dart';
import 'package:app/features/login/login_screen.dart';
import 'package:app/features/profile/profile_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          guards: [AuthGuard()],
          path: '/',
          children: [
            AutoRoute(
              page: MyCollectionRoute.page,
              guards: [AuthGuard()],
              path: 'my_collection',
            ),
            AutoRoute(
              page: InvitedCollectionRoute.page,
              guards: [AuthGuard()],
              path: 'invited_collection',
            ),
          ],
        ),
        AutoRoute(
          page: CreateFoundRaiseRoute.page,
          guards: [AuthGuard()],
          path: '/create_found_raise',
        ),
        AutoRoute(
          page: ProfileRoute.page,
          guards: [AuthGuard()],
          path: '/profile',
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
      ];
}
