import 'package:flutter/material.dart';

class StartupAppbar extends StatelessWidget implements PreferredSizeWidget {
  const StartupAppbar({super.key});
  @override
  Widget build(BuildContext context) {
    return (AppBar(
      title: Image.asset('assets/images/Menesha.jpg', height: 40),
      backgroundColor: Colors.white,
      toolbarHeight: 40,
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 15,
            child: Icon(Icons.person, color: Colors.blue, size: 20),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 2),
        IconButton(
          icon: Icon(Icons.menu, color: Colors.black, size: 30),
          onPressed: () {
            // context.goNamed(pathName);
          },
        ),
        const SizedBox(width: 5),
      ],
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
