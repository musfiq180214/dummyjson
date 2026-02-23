import 'dart:developer';

import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/custom_dialog.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/loader.dart';
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
              Text(context.t.sign_in, style: AppTextStyles.headingL),
              AppSpacing.verticalSpaceXXL,

              // Phone Input
              Text(context.t.please_enter_username),
              AppSpacing.verticalSpaceS,
              UserNameInputField(
                controller: _usernameController,
                hintText: context.t.enter_username,
              ),

              // PIN Input
              AppSpacing.verticalSpaceL,
              Text(context.t.please_enter_pass),
              AppSpacing.verticalSpaceS,
              //PinputField(pinController: _pinController, length: 4),
              PassInputField(controller: _passController),
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
                        // final user = ref.watch(userProvider);
                        state.whenOrNull(
                          data: (_) async {
                            log(ref.read(accessTokenProvider).toString());
                            log(ref.read(refreshTokenProvider).toString());
                            await ref
                                .read(loginProvider.notifier)
                                .login(username: username, pass: pass);
                            AppNavigator.navigatorKey.currentState!
                                .pushNamedAndRemoveUntil(
                                  RouteNames.landing,
                                  (route) => false,
                                );
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
                      text: context.t.sign_in,
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
                        text: context.t.new_to_app,
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
                                context.t.register,
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
                        Navigator.pushNamed(
                          context,
                          RouteNames.guestHome,
                          arguments: true,
                        );
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
