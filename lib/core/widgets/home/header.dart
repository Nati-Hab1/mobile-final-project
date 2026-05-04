import 'package:flutter/material.dart';

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
  Size get preferredSize =>
      const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/Menesha.jpg',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
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
