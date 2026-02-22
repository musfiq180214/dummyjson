import 'dart:developer';
import 'dart:io';

import 'package:dummyjson/core/provider/bottom_nav_bar_provider.dart';
import 'package:dummyjson/core/service/app_update_service.dart';
import 'package:dummyjson/core/service/internet_service.dart';
import 'package:dummyjson/core/service/location_tracking_service.dart';
import 'package:dummyjson/core/service/permission_service.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:dummyjson/features/landing/providers/landing_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  // final List<Widget> _guestLandingScreens = [
  //   GuestHomeScreen(),
  //   HajjGuidanceScreen(
  //     tittle: 'মক্কা সম্পর্কে জানুন',
  //     type: 'explore_mecca',
  //     cangoBack: false,
  //   ),
  //   GuidanceScreen(),
  //   HealthScreen(cangoBack: false),
  //   // AuthScreen(cangoBack: false,)
  // ];
  // final List<Widget> _screens = [
  //   HomeScreen(),
  //   HajjGuidanceScreen(
  //     tittle: 'মক্কা সম্পর্কে জানুন',
  //     type: 'explore_mecca',
  //     cangoBack: false,
  //   ),
  //   GuidanceScreen(),
  //   HealthScreen(cangoBack: false),
  //   ProfileScreen(canGoback: false),
  // ];

  // final List<Widget> _familyScreens = [
  //   HomeScreen(),
  //   FamilyProfile(cangoBack: false),
  //   GuidanceScreen(),
  //   HealthScreen(cangoBack: false),
  //   ProfileScreen(canGoback: false),
  // ];

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
        body: LandingScreen1(),
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
              label: 'Home',
            ),
            // userType == UserType.familyMember
            //     ? BottomNavigationBarItem(
            //         icon: Icon(Icons.switch_account, color: Colors.black),
            //         label: 'Follow',
            //       )
            //     : BottomNavigationBarItem(
            //         icon: Icon(Icons.search, color: Colors.black),
            //         label: 'Discover',
            //       ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined, color: Colors.black),
              label: 'Guidance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety_outlined, color: Colors.black),
              label: 'Health',
            ),
            // if (userType != UserType.guest)
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.person_outlined, color: Colors.black),
            //     label: 'Profile',
            //   ),
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

class LandingScreen1 extends ConsumerWidget {
  const LandingScreen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) async {
              if (value == 'logout') {
                await _handleLogout(context, ref);
              } else if (value == 'others') {
                _handleOthers();
              }
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
              PopupMenuItem<String>(value: 'others', child: Text('Others')),
            ],
          ),
        ],
      ),
      body: const Center(child: Text("Welcome")),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(secureStorageProvider).deleteAll();
    AppLogger.i("Logging Out");

    // Example: Navigate to login screen
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _handleOthers() {
    AppLogger.i("Others clicked");
  }
}
