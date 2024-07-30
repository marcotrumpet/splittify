// ignore_for_file: use_build_context_synchronously

import 'package:app/app_router.dart';
import 'package:app/common/common_values.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [
        MyCollectionRoute(),
        InvitedCollectionRoute(),
      ],
      builder: (context, child, _) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                onPressed: () {
                  context.router.push(const CreateFoundRaiseRoute());
                },
                child: const Text('Crea raccolta'),
              ),
              IconButton(
                onPressed: () async {
                  await context.router.push(const ProfileRoute());
                },
                icon: const Icon(Icons.person),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size(context.appWidth(), kToolbarHeight),
              child: BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                elevation: 0.5,
                items: const [
                  BottomNavigationBarItem(
                    label: 'Raccolte',
                    icon: Icon(Icons.collections_bookmark),
                  ),
                  BottomNavigationBarItem(
                    label: 'Inviti',
                    icon: Icon(
                      Icons.receipt,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: child,
        );
      },
    );
  }
}
