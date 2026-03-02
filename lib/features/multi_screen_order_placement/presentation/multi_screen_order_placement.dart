import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/custom_dialog.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/loader.dart';
import 'package:dummyjson/core/widgets/button.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_response.dart';
import 'package:dummyjson/features/multi_screen_order_placement/presentation/order_confirmation.dart';
import 'package:dummyjson/features/multi_screen_order_placement/presentation/order_placement_step_1.dart';
import 'package:dummyjson/features/multi_screen_order_placement/presentation/order_placement_step_2.dart';
import 'package:dummyjson/features/multi_screen_order_placement/presentation/order_placement_step_3.dart';
import 'package:dummyjson/features/multi_screen_order_placement/presentation/order_placement_step_4.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/widgets/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MultiStepPreRegistrationScreen extends ConsumerStatefulWidget {
  const MultiStepPreRegistrationScreen({super.key});

  @override
  ConsumerState<MultiStepPreRegistrationScreen> createState() =>
      _MultiStepRegistrationScreenState();
}

class _MultiStepRegistrationScreenState
    extends ConsumerState<MultiStepPreRegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  Future<void> _nextStep() async {
    final notifier = ref.read(preRegistrationFormProvider.notifier);
    // Step validators in order
    final validators = [
      () => notifier.validateStep1(context),
      () => notifier.validateStep2(context),
      () => notifier.validateStep3(),
      () => notifier.validateStep4(),
    ];

    if (_currentStep < validators.length) {
      final (isValid, message) = await validators[_currentStep]();
      if (isValid) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        showCustomSnackBar(
          context,
          message: message ?? "Please fill all the fields with valid data",
          type: MessageType.error,
        );
      }
    } else {
      // Final submission
      final form = ref.watch(preRegistrationFormProvider);
      final regNotifier = ref.read(preRegProvider.notifier);
      regNotifier.preRegistration(form: form, edit: false, applicationID: "");
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        title: "Order Placement",
        canGoBack: true,
        onBackPress: () {
          ref.read(preRegistrationFormProvider.notifier).reset();
          AppNavigator.navigatorKey.currentState!.pop();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: StepIndicator(
              currentStep: _currentStep,
              totalSteps: 5,
              activeColor: primaryColor,
              inactiveColor: Colors.grey.shade300,
              circleRadius: 15,
              lineWidth: 3,
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Step1Form(),
                Step2Form(),
                Step3Form(),
                Step4Form(),
                Step5Preview(
                  onEditStep: (step) {
                    print("Edit Step: $step");
                    setState(() {
                      _currentStep = step - 1;
                    });
                    _pageController.jumpToPage(_currentStep);
                  },
                ),
              ],
            ),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              ref.listen<AsyncValue<PreRegResponse>>(preRegProvider, (
                previous,
                next,
              ) {
                next.whenOrNull(
                  error: (err, _) {
                    showCustomSnackBar(
                      context,
                      message: err.toString(),
                      type: MessageType.error,
                    );
                  },
                  data: (data) {
                    if (data.id != null) {
                      showCustomSnackBar(
                        context,
                        message: "Pre-Registration successful",
                        type: MessageType.success,
                      );
                      ref.invalidate(preRegistrationFormProvider);
                      AppNavigator.navigatorKey.currentState!
                          .pushNamedAndRemoveUntil(
                            RouteNames.orderSuccess,
                            (route) =>
                                route.settings.name == RouteNames.landing,
                          );
                    }
                  },
                  loading: () => showCustomSnackBar(
                    context,
                    message: "Form Submitting...",
                    type: MessageType.info,
                  ),
                );
              });

              final regState = ref.watch(preRegProvider);

              return regState.isLoading
                  ? loader()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: AppButton(
                                ontap: _prevStep,
                                text: "Back",
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                              ),
                            ),
                          if (_currentStep > 0) const SizedBox(width: 10),
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                ref.listen<AsyncValue<PreRegResponse?>>(
                                  preRegProvider,
                                  (previous, next) {
                                    next.whenOrNull(
                                      error: (err, _) {
                                        showCustomSnackBar(
                                          context,
                                          message: err.toString(),
                                          type: MessageType.error,
                                        );
                                      },
                                    );
                                  },
                                );

                                return AppButton(
                                  ontap: _nextStep,
                                  text: _currentStep == 4 ? "Submit" : "Next",
                                  backgroundColor: primaryColor,
                                  textColor: Colors.white,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
