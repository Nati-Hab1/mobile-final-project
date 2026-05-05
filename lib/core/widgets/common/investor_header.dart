import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class InvestorHeader extends StatelessWidget implements PreferredSizeWidget {
  const InvestorHeader({
    super.key,
    this.additionalActions,
  });

  /// Allows you to add extra widgets before the profile/menu if needed.
  final List<Widget>? additionalActions;

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Image(
                    image: AssetImage('assets/images/Menesha.jpg'),
                    width: 30,
                    height: 30,
                  ),
                const Spacer(),
                if (additionalActions != null) ...additionalActions!,
                
              // 3. Profile Image Action
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // Circular clipping
                  child: Image.asset(
                    'assets/images/profile.png',
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 5),

              // 4. Menu Action
              GestureDetector(
                onTap: () => context.go('/investor_sider'),
                child: const Icon(
                  Icons.menu, 
                  color: Color.fromARGB(255, 48, 57, 89),
                  size: 27,
                ),
              ),
              
              const SizedBox(width: 3),
            ],
          ),
        ),
      ),
     ),
    );
  }
}