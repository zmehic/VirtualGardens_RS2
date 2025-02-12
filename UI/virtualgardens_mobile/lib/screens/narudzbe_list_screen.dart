import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';
import 'package:virtualgardens_mobile/providers/narudzbe_provider.dart';
import 'package:virtualgardens_mobile/screens/narudzbe_details_screen.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late NarudzbaProvider _narudzbaProvider;
  SearchResult<Narudzba>? result;
  bool isLoading = true;

  final _scaffoldKeyOrdersList = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _narudzbaProvider = context.read<NarudzbaProvider>();
    fetchUserOrders();
  }

  Future fetchUserOrders() async {
    final currentUserId = AuthProvider.korisnikId;
    var filter = {'korisnikId': currentUserId, 'isDeleted': false};
    result = await _narudzbaProvider.get(filter: filter);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader(
        isLoading: isLoading,
        child: Scaffold(
          key: _scaffoldKeyOrdersList,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[Container()],
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Moje narudžbe",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Colors.green.shade900,
                unselectedLabelColor: Colors.green.shade100,
                indicatorColor: Colors.green.shade900,
                tabs: const [
                  Tab(text: "Kreirane"),
                  Tab(text: "U procesu"),
                  Tab(text: "Završene"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrdersView("created"),
                    _buildOrdersView("inprogress"),
                    _buildOrdersView("finished"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      "Moje Narudžbe",
    );
  }

  Widget _buildOrdersView(String state) {
    final orders =
        result?.result.where((order) => order.stateMachine == state).toList() ??
            [];

    return Stack(
      children: [
        ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
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
                  "Stanje: ${state == 'created' ? "Kreirana" : state == 'finished' ? "Završena" : "U procesu"}",
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state == 'created')
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await buildDeleteAlert(context, "Narudžba",
                              "Narudžba", _narudzbaProvider, order.narudzbaId);
                          result!.result.remove(order);
                          setState(() {});
                        },
                      ),
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_forward, color: Colors.green),
                      onPressed: () async {
                        bool? response = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NarudzbaUserDetailsScreen(
                              narudzba: order,
                            ),
                          ),
                        );

                        if (response == true) {
                          fetchUserOrders();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (state == 'created')
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                var request = {
                  'brojNarudzbe': null,
                  'ukupnaCijena': 0,
                  'korisnikId': AuthProvider.korisnikId,
                  'nalogId': null
                };
                var order = await _narudzbaProvider.insert(request);
                result!.result.add(order);

                setState(() {
                  isLoading = false;
                });
                if (mounted) {
                  await buildSuccessAlert(
                      context,
                      "Narudžba je uspješno kreirana!",
                      "Kliknite na narudžbu da biste vidjeli detalje i dodali proizvode.",
                      isDoublePop: false);
                }
              },
              child: const Text(
                "Kreiraj novu narudžbu",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
      ],
    );
  }
}
