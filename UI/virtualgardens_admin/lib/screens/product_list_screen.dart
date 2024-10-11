import 'package:flutter/material.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        Column(
          children: [
            Text("Lista proizvoda placeholder"),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Nazad"))
          ],
        ),
        "Lista proizvoda");
  }
}
