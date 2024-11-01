import 'package:flutter/material.dart';
import 'package:virtualgardens_admin/providers/auth_provider.dart';
import 'package:virtualgardens_admin/screens/product_details_screen.dart';
import 'package:virtualgardens_admin/screens/product_list_screen.dart';
import 'package:virtualgardens_admin/screens/user_list_screen.dart';

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
              title: Text("Back"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Korisnici"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => UserListScreen()));
              },
            ),
            ListTile(
              title: Text("Proizvodi"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ProductListScreen()));
              },
            ),
            ListTile(
              title: Text("Detalji"),
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
