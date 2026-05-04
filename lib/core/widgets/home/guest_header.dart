import 'package:flutter/material.dart';
import 'package:menesha/core/widgets/common/app_logo.dart';

/// Fixed top header for the Guest (unauthenticated) screens.
/// WHITE background, logo + optional action widgets on the right.
class GuestHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const GuestHeader({
    super.key,
    this.actions,
  });

  /// Optional widgets shown on the right side of the header (e.g. buttons).
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const AppLogo(
                  size: 30,
                  showLabel: true,
                  darkBackground: false,
                ),
                const Spacer(),
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
