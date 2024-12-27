import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/narudzbe_provider.dart';
import 'package:virtualgardens_mobile/screens/narudzbe_details_screen.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  late NarudzbaProvider _narudzbaProvider;
  SearchResult<Narudzba>? result;
  bool isLoading = true;

  @override
  void initState() {
    _narudzbaProvider = context.read<NarudzbaProvider>();
    super.initState();
    fetchUserOrders();
  }

  Future fetchUserOrders() async {
    setState(() {
      isLoading = true;
    });

    // Assuming "currentUserId" is available via a provider or context.

    final currentUserId = AuthProvider.korisnikId;

    var filter = {'korisnikId': currentUserId, 'isDeleted': false};

    result = await _narudzbaProvider.get(filter: filter);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader(
        isLoading: isLoading,
        child: Container(
          color: const Color.fromRGBO(235, 241, 224, 1),
          child: Column(
            children: [
              _buildBanner(),
              _buildResultView(),
              _buildCreateOrderButton(),
            ],
          ),
        ),
      ),
      "Moje Narudžbe",
    );
  }

  Widget _buildBanner() {
    return Container(
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(size: 45, color: Colors.white, Icons.edit_note_rounded),
            SizedBox(width: 10),
            Text(
              "Moje narudžbe",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Arial",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: ListView.builder(
        itemCount: result?.result.length ?? 0,
        itemBuilder: (context, index) {
          final order = result!.result[index];
          return Card(
            color: Colors.green.shade100,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              title: Text(
                "Broj narudžbe: ${order.brojNarudzbe}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Stanje: ${order.stateMachine == 'created' ? "Zaprimljena" : order.stateMachine == 'finished' ? "Završena" : "U procesu"}",
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.green),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NarudzbaUserDetailsScreen(
                        narudzba: order,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreateOrderButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // Navigate to create order screen when implemented
        },
        child: const Text(
          "Kreiraj novu narudžbu",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
