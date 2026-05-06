import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartupSidebar extends StatelessWidget {
  const StartupSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 220,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 40),

                _item(context, "Home", Icons.home, "/home"),
                _item(context, "Dashboard", Icons.dashboard, "/startup/dashboard"),
                _item(context, "About Us", Icons.info, "/about_us"),
                _item(context, "Contact Us", Icons.contact_mail, "/contact_us"),
                _item(context, "Terms", Icons.description, "/terms"),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      context.pushNamed("deleteAccount");
                    },
                    child: const Text("Delete"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => context.go(route),
    );
  }
}