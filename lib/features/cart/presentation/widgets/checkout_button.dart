import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/core/utils/functions/handle_checkout.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double _checkoutButtonPadding = 24.0;
const double _checkoutButtonVerticalPadding = 12.0;
const double _checkoutButtonFontSize = 16.0;

class CheckoutButton extends ConsumerWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final magentaColor = const Color(0xFFFF00F7);

    return Semantics(
      label: localizations.proceedToCheckout,
      button: true,
      child: GestureDetector(
        onTap: () => handleCheckout(ref),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: magentaColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: -2,
              ),
            ],
          ),
          child: ClipPath(
            clipper: CyberpunkShapeClipper(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: _checkoutButtonPadding,
                vertical: _checkoutButtonVerticalPadding,
              ),
              decoration: BoxDecoration(
                color: magentaColor,
                border: Border.all(color: Colors.white24, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations.checkout.toUpperCase(),
                    style: const TextStyle(
                      fontSize: _checkoutButtonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
