import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/izazov.dart';
import 'package:virtualgardens_mobile/models/izazov_kategorija.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/models/statistika.dart';
import 'package:virtualgardens_mobile/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';
import 'package:virtualgardens_mobile/providers/izazov_provider.dart';
import 'package:virtualgardens_mobile/providers/product_provider.dart';
import 'package:virtualgardens_mobile/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_mobile/screens/frmPeerChallenges14072025.dart';
import 'package:virtualgardens_mobile/screens/product_details_screen.dart';

class ChallengesListScreen extends StatefulWidget {
  const ChallengesListScreen({super.key});

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {
  late IzazovProvider _izazovProvider;

  SearchResult<Izazov>? result;
  List<IzazovKategorija>? kategorije;
  List<Statistika>? statistika;

  DateTime? datum;
  int? selectedStatus;
  int? selectedTip;
  bool isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _datumController = TextEditingController();
  final GlobalKey<FormBuilderState> _productListFormKey =
      GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _izazovProvider = context.read<IzazovProvider>();
    initForm();
  }

  Future initForm() async {
    _fetchProducts();
    kategorije = await _izazovProvider.getKategorije();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    var filter = {
      'Status': selectedStatus,
      'Tip': selectedTip,
      'Datum': datum,
      'IncludeTables': "Izazov,Korisnik",
    };

    result = await _izazovProvider.get(filter: filter);
    statistika = await _izazovProvider.getStatistika(filter: filter);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader(
            isLoading: isLoading,
            child: Scaffold(
              key: _scaffoldKey,
              drawer: _buildDrawerFilter("Filter"),
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChallengesDetailsSceen(),
                        ),
                      );
                    },
                  ),
                ],
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Izazovi",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: _buildStatistikaList(),
                      ),
                      Expanded(
                        child: _buildProductList(),
                      ),
                    ],
                  ),
                  _buildFilterAndSortButtons(),
                ],
              ),
            )),
        "Izazovi");
  }

  Widget _buildDrawerFilter(String title) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(32, 76, 56, 1)),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSearch(),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                  ),
                  onPressed: () async {
                    _fetchProducts();
                    _scaffoldKey.currentState?.closeDrawer();
                  },
                  child: const Text(
                    "Filtriraj",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Datum:"),
              Expanded(
                  child: FormBuilderDateTimePicker(
                name: "datum",
                controller: _datumController,
                initialValue: datum,
                onChanged: (value) {
                  datum = value;
                  _datumController.text =
                      formatDateString(value?.toIso8601String());
                },
              )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Status:"),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400)),
                child: DropdownMenu(
                  initialSelection: selectedStatus.toString(),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 0, label: "Prihvacen"),
                    DropdownMenuEntry(value: 1, label: "U toku"),
                    DropdownMenuEntry(value: 2, label: "Zavrsen"),
                    DropdownMenuEntry(value: 3, label: "Odustao")
                  ],
                  menuStyle: MenuStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(4),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300)))),
                  textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                  onSelected: (value) {
                    if (value != null) {
                      selectedStatus = int.tryParse(value.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Molimo odaberite neku od ponuđenih vrijednosti!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Tip:"),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400)),
                child: DropdownMenu(
                  initialSelection: selectedStatus.toString(),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 0, label: "Fizicki"),
                    DropdownMenuEntry(value: 1, label: "Edukativni"),
                    DropdownMenuEntry(value: 2, label: "Drustveni"),
                  ],
                  menuStyle: MenuStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(4),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300)))),
                  textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                  onSelected: (value) {
                    if (value != null) {
                      selectedTip = int.tryParse(value.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Molimo odaberite neku od ponuđenih vrijednosti!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    if (result == null || result!.result.isEmpty) {
      return const Center(
        child: Text("Nema izazova za prikaz"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: result!.result.length,
      itemBuilder: (context, index) {
        if (index == result!.result.length) {
          return const Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          );
        }
        final product = result!.result[index];
        return Padding(
          padding: index + 1 == result!.result.length
              ? const EdgeInsets.only(top: 8.0, bottom: 70.0)
              : const EdgeInsets.symmetric(vertical: 8.0),
          child:
              GestureDetector(onTap: () {}, child: _buildProductCard(product)),
        );
      },
    );
  }

  Widget _buildStatistikaList() {
    if (statistika == null || statistika!.isEmpty) {
      return const Center(
        child: Text("Nema statistika za prikaz"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: statistika!.length,
      itemBuilder: (context, index) {
        if (index == statistika!.length) {
          return const Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          );
        }
        final product = statistika![index];
        return Padding(
          padding: index + 1 == result!.result.length
              ? const EdgeInsets.only(top: 8.0, bottom: 70.0)
              : const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
              onTap: () {}, child: _buildStatistikaCard(product)),
        );
      },
    );
  }

  Widget _buildStatistikaCard(Statistika product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Naziv: ${product.naziv} - ${product.broj}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndSortButtons() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: "filter",
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            label: const Text(
              "Filter",
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Izazov product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.izazov?.naziv ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tip: ${product.izazov?.tip == 0 ? "Fizicki" : product.izazov?.tip == 1 ? "Edukativni" : "Drustveni"}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Status: ${product.status == 0 ? "Prihvacen" : product.status == 1 ? "U toku" : product.status == 2 ? "Zavrsen" : "Odbijen"}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Napredak: ${product.brojPonavljanja}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Datum: ${formatDateString(product.datumPrihvatanja.toIso8601String())}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  product.status == 1
                      ? ElevatedButton(
                          onPressed: () async {
                            var id = product.id;
                            var request = {'peerIzazovId': id};
                            var response =
                                await _izazovProvider.end(request: request);

                            if (response == true) {
                              _fetchProducts();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(32, 76, 56, 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                          ),
                          child: const Icon(Icons.save, color: Colors.white),
                        )
                      : Container(),
                  product.status == 0
                      ? ElevatedButton(
                          onPressed: () async {
                            var id = product.id;
                            var request = {'peerIzazovId': id};
                            var response =
                                await _izazovProvider.begin(request: request);

                            if (response == true) {
                              _fetchProducts();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 131, 220, 7),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                          ),
                          child:
                              const Icon(Icons.straight, color: Colors.white),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
