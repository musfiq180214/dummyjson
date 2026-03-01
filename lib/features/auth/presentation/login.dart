import 'dart:developer';

import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/provider/secureStorageProvider.dart';
import 'package:dummyjson/core/provider/user_type_provider.dart';
import 'package:dummyjson/core/service/hive_service.dart';
import 'package:dummyjson/core/service/token_service.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/custom_dialog.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/loader.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/core/widgets/button.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/core/widgets/pass_input.dart';
import 'package:dummyjson/core/widgets/phone_input.dart';
import 'package:dummyjson/core/widgets/pin_input.dart';
import 'package:dummyjson/core/widgets/username_input.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final bool cangoBack;
  const LoginScreen({super.key, this.cangoBack = false});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final username = await ref
          .read(secureStorageProvider)
          .read(key: 'lastLoggedInUsername');
      log(username.toString());
      if (username != null) {
        _usernameController.text = username;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final loginController = ref.read(loginProvider.notifier);
    return Scaffold(
      appBar: GlobalAppBar(title: "", canGoBack: widget.cangoBack),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.paddingXL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sign In", style: AppTextStyles.headingL),
              AppSpacing.verticalSpaceXXL,

              // Phone Input
              Text("Please enter your username"),
              AppSpacing.verticalSpaceS,
              UserNameInputField(
                controller: _usernameController,
                hintText: "Enter username",
              ),

              // PIN Input
              AppSpacing.verticalSpaceL,
              Text("Please enter your password"),
              AppSpacing.verticalSpaceS,
              //PinputField(pinController: _pinController, length: 4),
              PassInputField(
                controller: _passController,
                hintText: "Enter password",
              ),
              AppSpacing.verticalSpaceXXL,

              // Login Button
              loginState.isLoading
                  ? loader()
                  : AppButton(
                      ontap: () async {
                        final username = _usernameController.text.trim();
                        final pass = _passController.text.trim();

                        await loginController.login(
                          username: username,
                          pass: pass,
                        );

                        final state = ref.watch(loginProvider);

                        state.whenOrNull(
                          data: (_) async {
                            // Use GoRouter navigation instead of Navigator

                            final accessToken = await ref
                                .read(accessTokenServiceProvider)
                                .getToken();
                            final refreshToken = await ref
                                .read(refreshTokenServiceProvider)
                                .getToken();

                            final onboardingComplete = ref
                                .read(hiveServiceProvider)
                                .isOnboardingComplete();

                            AppLogger.i("ACCESS TOKEN: $accessToken");
                            AppLogger.i("REFRESH TOKEN: $refreshToken");
                            AppLogger.i("ONBOARDING: $onboardingComplete");
                            // Set user type based on tokens
                            final userType =
                                (accessToken != null &&
                                    accessToken.isNotEmpty &&
                                    refreshToken != null &&
                                    refreshToken.isNotEmpty)
                                ? UserType.loggedIn
                                : UserType.guest;

                            ref.read(userTypeProvider.notifier).state =
                                userType;

                            if (userType == UserType.loggedIn) {
                              AppNavigator.goTo(RouteNames.landing);
                            }
                          },
                          error: (err, _) {
                            showCustomSnackBar(
                              context,
                              message: err.toString(),
                              type: MessageType.error,
                            );
                          },
                        );
                      },
                      backgroundColor: green,
                      textColor: Colors.white,
                      text: "Sign In",
                    ),

              AppSpacing.verticalSpaceXXL,

              // Register link
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "New to App",
                        style: AppTextStyles.bodyS.copyWith(
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "   "),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                showCustomSnackBar(
                                  context,
                                  message: "Not Designed Yet",
                                  type: MessageType.error,
                                );
                              },
                              child: Text(
                                "Register",
                                style: AppTextStyles.bodyS.copyWith(
                                  color: green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              if (widget.cangoBack == false) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    TextButton(
                      onPressed: () {
                        AppNavigator.goTo(RouteNames.landing);
                      },
                      child: Text(
                        "Continue As Guest",
                        style: TextStyle(color: primaryColorDark),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
