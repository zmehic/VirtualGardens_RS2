import 'package:flutter/material.dart';
import 'package:virtualgardens_admin/providers/auth_provider.dart';
import 'package:virtualgardens_admin/screens/home_screen.dart';
import 'package:virtualgardens_admin/screens/nalozi_list_screen.dart';
import 'package:virtualgardens_admin/screens/narudzbe_list_screen.dart';
import 'package:virtualgardens_admin/screens/ponude_list_screen.dart';
import 'package:virtualgardens_admin/screens/product_details_screen.dart';
import 'package:virtualgardens_admin/screens/product_list_screen.dart';
import 'package:virtualgardens_admin/screens/profile_screen.dart';
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.question_answer,
              size: 36,
              color: Colors.green.shade900,
            ),
          ),
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
              title: Text("Home"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              title: Text("Profil"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: Text("Skladište"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ProductListScreen()));
              },
            ),
            ListTile(
              title: Text("Zaposlenici"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ZaposleniciListScreen()));
              },
            ),
            ListTile(
              title: Text("Narudžbe"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const NarduzbeListScreen()));
              },
            ),
            ListTile(
              title: Text("Nalozi"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const NaloziListScreen()));
              },
            ),
            ListTile(
              title: Text("Ponude"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const PonudeListScreen()));
              },
            ),
            ListTile(
              title: Text("Statistika"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen()));
              },
            )
          ],
        ),
      ),
      body: widget.child,
      backgroundColor: Color.fromRGBO(103, 122, 105, 1),
    );
  }
}
