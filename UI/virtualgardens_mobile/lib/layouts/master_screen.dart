import 'package:flutter/material.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_mobile/screens/home_screen.dart';
import 'package:virtualgardens_mobile/screens/product_list_screen.dart';
import 'package:virtualgardens_mobile/screens/profile_screen.dart';

// ignore: must_be_immutable
class MasterScreen extends StatefulWidget {
  MasterScreen(this.child, this.title, {super.key});
  String title;
  Widget child;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown.shade100,
        title: Image.asset(
          'assets/images/logo.png',
          height: 60,
          width: 60,
        ),
      ),
      drawer: _buildDrawer(),
      body: widget.child,
      backgroundColor: const Color.fromRGBO(103, 122, 105, 1),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(32, 76, 56, 1),
            ),
            accountName: Text(
              AuthProvider.username ?? "Guest User",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: const Text(
              "Kupac",
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  label: "Početna stranica",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  label: "Profil",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_bag,
                  label: "Proizvodi",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ProductListScreen()),
                    );
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onPressed: () {
                AuthProvider.korisnikId = 0;
                AuthProvider.username = "";
                AuthProvider.password = "";
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Odjavi se",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown.shade700),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
