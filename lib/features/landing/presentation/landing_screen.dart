import 'dart:developer';
import 'dart:io';

import 'package:dummyjson/core/provider/bottom_nav_bar_provider.dart';
import 'package:dummyjson/core/provider/user_type_provider.dart';
import 'package:dummyjson/core/service/app_update_service.dart';
import 'package:dummyjson/core/service/hive_service.dart';
import 'package:dummyjson/core/service/internet_service.dart';
import 'package:dummyjson/core/service/location_tracking_service.dart';
import 'package:dummyjson/core/service/permission_service.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:dummyjson/features/cart/presentation/cart_screen.dart';
import 'package:dummyjson/features/guest_home/presentation/guest_home_screen.dart';
import 'package:dummyjson/features/guest_others/presentation/guest_other_screen.dart';
import 'package:dummyjson/features/home/presentation/home_screen.dart';
import 'package:dummyjson/features/landing/providers/landing_provider.dart';
import 'package:dummyjson/features/product_search/presentation/product_search_screen.dart';
import 'package:dummyjson/features/profile/presentation/profile_screen.dart';
import 'package:dummyjson/features/product_list/presentation/product_list_screen.dart';
import 'package:dummyjson/features/social/presentation/social_feed_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  final List<Widget> _guestLandingScreens = [
    GuestHomeScreen(),
    GuestOtherScreen(),
  ];
  final List<Widget> _screens = [
    HomeScreen(),
    ProductListScreen(),
    ProductSearchScreen(),
    CartScreen(),
    SocialFeedScreen(),
  ];

  bool _hasRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!kDebugMode) {
        checkForUpdate();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkForUpdate() {
    if (Platform.isAndroid) {
      ref.read(appUpdateProvider.notifier).checkForUpdate();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasRequested) {
      _hasRequested = true;
      _requestPermissions();
    }
  }

  Future<bool> forceUpdate(AppUpdateNotifier appUpdateNotifier) async {
    var update = await appUpdateNotifier.performImmediateUpdate();
    return update;
  }

  Future<bool> minorUpdate(AppUpdateNotifier appUpdateNotifier) async {
    var update = await appUpdateNotifier.performMinorUpdate();
    return update;
  }

  Future<void> _requestPermissions() async {
    final notifier = ref.read(permissionNotifierProvider.notifier);
    await notifier.requestAll();
    if (notifier.isGranted(AppPermission.location)) {
      await ref.read(locationServiceProvider).start();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userType = ref.watch(userTypeProvider);
    final userType = ref.read(userTypeProvider);

    AppLogger.i("LANDING USER TYPE: $userType");

    var index = ref.watch(bottomNavIndexProvider);

    if (Platform.isAndroid) {
      InternetHandler(context: context, ref: ref).init();
    }
    if (Platform.isAndroid) {
      final appUpdateState = ref.watch(appUpdateProvider);
      final appUpdateNotifier = ref.read(appUpdateProvider.notifier);

      if (appUpdateState.updateAvailable) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (appUpdateState.isMajorUpdate) {
            final result = await forceUpdate(appUpdateNotifier);
            if (!result) {
              exit(0);
            }
          } else {
            log("minor update");
            final result = await minorUpdate(appUpdateNotifier);
          }
        });
      }
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        showExitPopup(context);
      },
      child: Scaffold(
        body: userType == UserType.guest
            ? _guestLandingScreens[index]
            : _screens[index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(color: Colors.black),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (index) =>
              ref.read(bottomNavIndexProvider.notifier).state = index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black),
              label: context.t.home,
            ),

            userType == UserType.guest
                ? BottomNavigationBarItem(
                    icon: Icon(Icons.switch_account, color: Colors.black),
                    label: context.t.guest,
                  )
                : BottomNavigationBarItem(
                    icon: const Icon(Icons.list, color: Colors.black),
                    label: context.t.product_list,
                  ),

            if (userType == UserType.loggedIn) ...[
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.black),
                label: context.t.product_search,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, color: Colors.black),
                label: context.t.cart,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.social_distance, color: Colors.black),
                label: "Social Feed",
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Do you want to exit?"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            AppLogger.i('yes selected');
                          }
                          exit(0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
