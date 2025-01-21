import 'package:flutter/material.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/screens/home_screen.dart';
import 'package:virtualgardens_mobile/screens/narudzbe_list_screen.dart';
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                AuthProvider.korisnikId = 0;
                AuthProvider.username = "";
                AuthProvider.password = "";
              },
              icon: Icon(
                Icons.logout,
                size: 36,
                color: Colors.red.shade900,
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Home"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              title: const Text("Profil"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: const Text("Proizvodi"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProductListScreen()));
              },
            ),
            ListTile(
              title: const Text("Narudžbe"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const UserOrdersScreen()));
              },
            ),
          ],
        ),
      ),
      body: widget.child,
      backgroundColor: const Color.fromRGBO(103, 122, 105, 1),
    );
  }
}
