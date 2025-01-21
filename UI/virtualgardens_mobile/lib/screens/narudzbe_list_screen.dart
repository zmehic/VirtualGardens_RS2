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
    setState(() {
      isLoading = true;
    });

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
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Brisanje narudžbe"),
                                content: const Text(
                                    "Jeste li sigurni da želite obrisati ovu narudžbu?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Ne"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Da"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            setState(() {
                              isLoading = true;
                            });
                            await _narudzbaProvider.delete(order.narudzbaId);
                            await fetchUserOrders();
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_forward, color: Colors.green),
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
                await _narudzbaProvider.insert(request);
                await fetchUserOrders();
                setState(() {
                  isLoading = false;
                });
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
