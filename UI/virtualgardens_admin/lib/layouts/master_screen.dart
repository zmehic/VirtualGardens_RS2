import 'package:flutter/material.dart';
import 'package:virtualgardens_admin/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_admin/screens/home_screen.dart';
import 'package:virtualgardens_admin/screens/jedinice_mjere_list_screen.dart';
import 'package:virtualgardens_admin/screens/nalozi_list_screen.dart';
import 'package:virtualgardens_admin/screens/narudzbe_list_screen.dart';
import 'package:virtualgardens_admin/screens/ponude_list_screen.dart';
import 'package:virtualgardens_admin/screens/product_list_screen.dart';
import 'package:virtualgardens_admin/screens/profile_screen.dart';
import 'package:virtualgardens_admin/screens/statistics_screen.dart';
import 'package:virtualgardens_admin/screens/vrste_proizvoda_list_screen.dart';
import 'package:virtualgardens_admin/screens/zaposlenici_list_screen.dart';

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

  _buildDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(32, 76, 56, 1),
            ),
            accountName: Text(
              AuthProvider.username ?? "Admin User",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: const Text(
              "Administrator",
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
                  label: "Skladište",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ProductListScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.people,
                  label: "Zaposlenici",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ZaposleniciListScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_cart,
                  label: "Narudžbe",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const NarduzbeListScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.task,
                  label: "Nalozi",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const NaloziListScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.list_alt,
                  label: "Ponude",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PonudeListScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.auto_graph,
                  label: "Statistika",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const StatisticsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                    icon: Icons.height_sharp,
                    label: "Jedinice mjere",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const JediniceMjereListScreen()));
                    }),
                _buildDrawerItem(
                    icon: Icons.type_specimen,
                    label: "Vrste proizvoda",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const VrsteProizvodaListScreen()));
                    })
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
                Navigator.of(context).popUntil((route) => route.isFirst);
                AuthProvider.korisnikId = 0;
                AuthProvider.username = "";
                AuthProvider.password = "";
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
