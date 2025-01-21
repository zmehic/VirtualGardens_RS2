import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_mobile/providers/product_provider.dart';
import 'package:virtualgardens_mobile/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_mobile/screens/product_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider provider;
  late VrsteProizvodaProvider vrsteProizvodaProvider;

  final TextEditingController _cijenaOdEditingController =
      TextEditingController();
  final TextEditingController _cijenaDoEditingController =
      TextEditingController();

  SearchResult<Proizvod>? result;
  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;

  double _cijenaOd = 0;
  double _cijenaDo = 1000;

  String? sortBy = null;
  bool isAscending = true;

  bool isLoading = true;
  int? selectedVrstaProizvoda;

  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    provider = context.read<ProductProvider>();
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    selectedVrstaProizvoda = 0;
    _fetchProducts(vrstaProizvodaId: selectedVrstaProizvoda);
  }

  Future<void> _fetchProducts(
      {String searchQuery = "", int? vrstaProizvodaId}) async {
    setState(() {
      isLoading = true;
    });
    var filter = {
      'NazivGTE': _searchController.text,
      'CijenaFrom': _cijenaOd,
      'CijenaTo': _cijenaDo,
      'OrderBy': sortBy,
      'SortDirection': isAscending ? "ASC" : "DESC",
      'VrstaProizvodaId':
          selectedVrstaProizvoda == 0 ? "" : selectedVrstaProizvoda,
      'IncludeTables': "JedinicaMjere",
      'isDeleted': false,
    };

    vrsteProizvodaResult = await vrsteProizvodaProvider.get();
    vrsteProizvodaResult?.result
        .insert(0, VrstaProizvoda(vrstaProizvodaId: 0, naziv: "Svi"));

    result = await provider.get(filter: filter);
    setState(() {
      isLoading = false;
    });
  }

  Future initScreen(int? vrstaProizvodaId) async {
    var filter = {
      'NazivGTE': _searchController.text,
      'CijenaFrom': _cijenaOd,
      'CijenaTo': _cijenaDo,
      'OrderBy': sortBy,
      'SortDirection': isAscending ? "ASC" : "DESC",
      'VrstaProizvodaId':
          selectedVrstaProizvoda == 0 ? "" : selectedVrstaProizvoda,
      'IncludeTables': "JedinicaMjere",
      'isDeleted': false,
    };
    vrsteProizvodaResult = await vrsteProizvodaProvider.get();
    vrsteProizvodaResult?.result
        .insert(0, VrstaProizvoda(vrstaProizvodaId: 0, naziv: "Svi"));

    if (vrstaProizvodaId != 0) {
      result = await provider.get(filter: filter);
    } else {
      result = await provider.get(filter: filter);
    }
    selectedVrstaProizvoda ??= vrsteProizvodaResult?.result[0].vrstaProizvodaId;
    _cijenaDoEditingController.text = "";
    _searchController.text = "";
    _cijenaOdEditingController.text = "";
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
              endDrawer: _buildDrawerSort("Sort"),
              drawer: _buildDrawerFilter("Filter"),
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Go back to the previous screen
                    Navigator.of(context).pop();
                  },
                ),
                actions: <Widget>[Container()],
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Proizvodi",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      _buildSearchBar(),
                      Expanded(
                        child: _buildProductList(),
                      ),
                    ],
                  ),
                  Positioned(
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
                          backgroundColor: Colors.green.shade700,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        FloatingActionButton.extended(
                          heroTag: "sort",
                          onPressed: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                          label: const Text(
                            "Sort",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.sort,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.green.shade700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        "Proizvodi");
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Pretraži proizvode",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromRGBO(235, 241, 224, 1),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _fetchProducts(
                searchQuery: _searchController.text,
                vrstaProizvodaId: selectedVrstaProizvoda,
              );
            },
            child: const Text("Pretraga"),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerFilter(String title) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green.shade700),
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
          // Your filter form inside the drawer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSearch(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    // Apply filter action here, for example:
                    var filter = {
                      'NazivGTE': _searchController.text,
                      'CijenaFrom': _cijenaOd,
                      'CijenaTo': _cijenaDo,
                      'OrderBy': sortBy,
                      'SortDirection': isAscending ? "ASC" : "DESC",
                      'VrstaProizvodaId': selectedVrstaProizvoda == 0
                          ? ""
                          : selectedVrstaProizvoda,
                      'IncludeTables': "JedinicaMjere",
                      'isDeleted': false,
                    };
                    // Apply the filter using your provider
                    result = await provider.get(filter: filter);
                    _scaffoldKey.currentState?.closeDrawer();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text("Apply Filters"),
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
              const Text("Cijena:"),
              Expanded(
                child: RangeSlider(
                  min: 0,
                  max: 1000, // Maximum price (adjust as needed)
                  values: RangeValues(_cijenaOd, _cijenaDo),
                  divisions: 200,
                  labels: RangeLabels(
                    "KM ${_cijenaOd.toStringAsFixed(0)}",
                    "KM ${_cijenaDo.toStringAsFixed(0)}",
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _cijenaOd = values.start;
                      _cijenaDo = values.end;
                    });
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
              const Text("Vrsta:"),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400)),
                child: DropdownMenu(
                  initialSelection: selectedVrstaProizvoda.toString(),
                  dropdownMenuEntries: vrsteProizvodaResult?.result
                          .map((item) => DropdownMenuEntry(
                              value: item.vrstaProizvodaId.toString(),
                              label: item.naziv ?? ""))
                          .toList() ??
                      [],
                  menuStyle: MenuStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(4),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300)))),
                  textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                  onSelected: (value) {
                    if (value != null) {
                      selectedVrstaProizvoda = int.tryParse(value.toString());
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

  Widget _buildDrawerSort(String title) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green.shade700),
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  leading: const Icon(Icons.sort),
                  trailing: sortBy != null && sortBy == "Naziv"
                      ? isAscending
                          ? const Icon(Icons.arrow_upward)
                          : const Icon(Icons.arrow_downward)
                      : const Icon(Icons.horizontal_rule),
                  title: const Text("Po nazivu"),
                  onTap: () {
                    setState(() {
                      sortBy = "Naziv"; // Set sorting by name
                      isAscending = !isAscending; // Toggle ascending/descending
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sort),
                  trailing: sortBy != null && sortBy == "Cijena"
                      ? isAscending
                          ? const Icon(Icons.arrow_upward)
                          : const Icon(Icons.arrow_downward)
                      : const Icon(Icons.horizontal_rule),
                  title: const Text("Po cijeni"),
                  onTap: () {
                    setState(() {
                      sortBy = "Cijena"; // Set sorting by price
                      isAscending = !isAscending; // Toggle ascending/descending
                    });
                  },
                ),
                // Add more sorting options if necessary, such as sorting in reverse order,
                ListTile(
                  leading: const Icon(Icons.sort),
                  trailing: sortBy != null && sortBy == "DostupnaKolicina"
                      ? isAscending
                          ? const Icon(Icons.arrow_upward)
                          : const Icon(Icons.arrow_downward)
                      : const Icon(Icons.horizontal_rule),
                  title: const Text("Po količini"),
                  onTap: () {
                    setState(() {
                      sortBy = "DostupnaKolicina"; // Set sorting by price
                      isAscending = !isAscending; // Toggle ascending/descending
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        // Apply filter action here, for example:
                        var filter = {
                          'NazivGTE': _searchController.text,
                          'CijenaFrom': _cijenaOd,
                          'CijenaTo': _cijenaDo,
                          'OrderBy': sortBy,
                          'SortDirection': isAscending ? "ASC" : "DESC",
                          'VrstaProizvodaId': selectedVrstaProizvoda == 0
                              ? ""
                              : selectedVrstaProizvoda,
                          'IncludeTables': "JedinicaMjere",
                          'isDeleted': false,
                        };
                        // Apply the filter using your provider
                        result = await provider.get(filter: filter);
                        _scaffoldKey.currentState?.closeEndDrawer();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: const Text("Sortiraj"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          sortBy = null;
                          isAscending = true;
                        });
                      },
                      child: const Text("Ukloni sortiranje"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (result == null || result!.result.isEmpty) {
      return const Center(
        child: Text("Nema proizvoda za prikaz"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: result!.result.length,
      itemBuilder: (context, index) {
        final product = result!.result[index];
        return Padding(
          padding: index + 1 == result!.result.length
              ? const EdgeInsets.only(top: 8.0, bottom: 100.0)
              : const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: product.slika != null
                          ? Image.memory(
                              base64Decode(product.slika!),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.naziv ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${product.cijena} KM / ${product.jedinicaMjere?.skracenica ?? ''}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Na stanju: ${product.dostupnaKolicina} ${product.jedinicaMjere?.skracenica ?? ''}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
