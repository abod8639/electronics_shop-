import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/base_app_bar.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/app_guard.dart';
import 'package:electronics_shop/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:electronics_shop/features/checkout/presentation/widgets/checkout_steps.dart';

const String _checkoutTitle = 'SECURE_CHECKOUT_PROTOCOL';
const String _nextButtonText = 'NEXT_PROTOCOL';
const String _placeOrderButtonText = 'AUTHORIZE_TRANSACTION';
const String _backButtonText = 'PREVIOUS';
const double _controlsPadding = 24.0;
const double _controlsSpacing = 12.0;
const double _controlsVerticalPadding = 14.0;

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutControllerProvider);
    final checkoutNotifier = ref.watch(checkoutControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: baseAppBar(
        context,
         _checkoutTitle,
        // context: context,
        // title: _checkoutTitle,
      ),
      body: Stack(
        children: [
          const BackGrid(accentColor: AppColors.cyan),
          checkoutState.isProcessing
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.cyan),
                      SizedBox(height: 16),
                      Text(
                        "PROCESSING_TRANSACTION...",
                        style: TextStyle(
                          color: AppColors.cyan,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : Theme(
                  data: theme.copyWith(
                    colorScheme: theme.colorScheme.copyWith(
                      primary: AppColors.cyan,
                      secondary: AppColors.magenta,
                    ),
                    canvasColor: Colors.transparent,
                  ),
                  child: Stepper(
                    elevation: 0,
                    type: StepperType.horizontal,
                    currentStep: checkoutState.currentStep,
                    onStepContinue: () {
                      AppGuard.runSafe(ref, () async {
                        if (checkoutState.currentStep == 2) {
                          await checkoutNotifier.placeOrder(context);
                        } else {
                          checkoutNotifier.nextStep();
                        }
                      });
                    },
                    onStepCancel: checkoutNotifier.previousStep,
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: _controlsPadding),
                        child: Row(
                          children: [
                            if (checkoutState.currentStep > 0) ...[
                              _buildActionButton(
                                label: _backButtonText,
                                isPrimary: false,
                                onTap: details.onStepCancel,
                              ),
                              const SizedBox(width: _controlsSpacing),
                            ],
                            _buildActionButton(
                              label: checkoutState.currentStep == 2
                                  ? _placeOrderButtonText
                                  : _nextButtonText,
                              isPrimary: true,
                              onTap: details.onStepContinue,
                            ),
                          ],
                        ),
                      );
                    },
                    steps: [
                      buildAddressStep(ref, 'ADDRESS_ID'),
                      buildPaymentStep(ref, 'CREDIT_LINK'),
                      buildReviewStep(ref, 'SUMMARY'),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isPrimary,
    VoidCallback? onTap,
  }) {
    final color = isPrimary ? AppColors.cyan : AppColors.magenta;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            ClipPath(
              clipper: CyberpunkShapeClipper(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: _controlsVerticalPadding,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  border: Border.all(color: color, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                      color: color,
                      letterSpacing: 2,
                      fontSize: 12,
                      shadows: [
                        Shadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(width: 4, height: 4, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

