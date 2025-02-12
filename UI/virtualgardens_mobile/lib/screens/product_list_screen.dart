import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_mobile/providers/product_provider.dart';
import 'package:virtualgardens_mobile/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_mobile/screens/product_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider provider;
  late VrsteProizvodaProvider vrsteProizvodaProvider;

  Map<String, dynamic> _initialValue = {};

  final ScrollController _scrollController = ScrollController();

  SearchResult<Proizvod>? result;
  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;

  double _cijenaOd = 0;
  double _cijenaDo = 10;
  String? sortBy;
  bool isAscending = true;
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int productsPerPage = 4;
  int? selectedVrstaProizvoda;

  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _productListFormKey =
      GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    provider = context.read<ProductProvider>();
    initForm();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore &&
          hasMoreData) {
        _loadMoreProducts();
      }
    });
  }

  Future initForm() async {
    _initialValue = {
      'naziv': "",
    };

    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    selectedVrstaProizvoda = 0;
    _fetchProducts(vrstaProizvodaId: selectedVrstaProizvoda, reset: true);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchProducts(
      {String searchQuery = "",
      int? vrstaProizvodaId,
      bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      hasMoreData = true;
      result = null;
      isLoading = false;
    }

    setState(() {
      isLoadingMore = !reset;
    });
    var filter = {
      'NazivGTE':
          _productListFormKey.currentState?.fields['naziv']?.value.toString() ??
              "",
      'CijenaFrom': _cijenaOd,
      'CijenaTo': _cijenaDo,
      'OrderBy': sortBy,
      'SortDirection': isAscending ? "ASC" : "DESC",
      'VrstaProizvodaId':
          selectedVrstaProizvoda == 0 ? "" : selectedVrstaProizvoda,
      'IncludeTables': "JedinicaMjere",
      'isDeleted': false,
      'Page': currentPage,
      'PageSize': productsPerPage,
    };

    if (reset) {
      var filter = {
        'isDeleted': false,
      };
      vrsteProizvodaResult = await vrsteProizvodaProvider.get(filter: filter);
      vrsteProizvodaResult?.result
          .insert(0, VrstaProizvoda(vrstaProizvodaId: 0, naziv: "Svi"));
    }

    var newResult = await provider.get(filter: filter);

    setState(() {
      if (newResult.result.isEmpty) {
        hasMoreData = false;
      } else {
        if (reset) {
          result = newResult;
        } else {
          result?.result.addAll(newResult.result);
        }
      }
      if (reset) isLoading = false;
      isLoadingMore = false;
    });
  }

  Future<void> _loadMoreProducts() async {
    if (!hasMoreData || isLoading || isLoadingMore) return;

    currentPage++;
    await _fetchProducts(reset: false);
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
                    Navigator.of(context).pop();
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
                  _buildFilterAndSortButtons(),
                ],
              ),
            )),
        "Proizvodi");
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilder(
        key: _productListFormKey,
        initialValue: _initialValue,
        child: Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                controller: _searchController,
                name: 'naziv',
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: "Pretraži proizvode",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromRGBO(235, 241, 224, 1),
                ),
                onChanged: (value) {
                  _fetchProducts(
                      searchQuery: _productListFormKey
                              .currentState?.fields['naziv']?.value
                              .toString() ??
                          "",
                      vrstaProizvodaId: selectedVrstaProizvoda,
                      reset: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
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
                    _fetchProducts(reset: true);
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
              const Text("Cijena:"),
              Expanded(
                child: RangeSlider(
                  min: 0,
                  max: 30,
                  values: RangeValues(_cijenaOd, _cijenaDo),
                  divisions: 30,
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSortListTile(
                    isAscendingList: isAscending,
                    sortByField: "Naziv",
                    label: "Po nazivu"),
                _buildSortListTile(
                    isAscendingList: isAscending,
                    sortByField: "Cijena",
                    label: "Po cijeni"),
                _buildSortListTile(
                    isAscendingList: isAscending,
                    sortByField: "DostupnaKolicina",
                    label: "Po količini"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25),
                        ),
                        onPressed: () async {
                          _fetchProducts(reset: true);
                          _scaffoldKey.currentState?.closeEndDrawer();
                        },
                        child: const Text("Sortiraj",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25),
                        ),
                        onPressed: () async {
                          sortBy = null;
                          isAscending = true;
                          _fetchProducts(reset: true);
                          _scaffoldKey.currentState?.closeEndDrawer();
                          setState(() {});
                        },
                        child: const Text("Ukloni",
                            style: TextStyle(color: Colors.white)),
                      ),
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
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: result!.result.length + (isLoadingMore ? 1 : 0),
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
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsScreen(product: product),
                  ),
                );
              },
              child: _buildProductCard(product)),
        );
      },
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
            backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          ),
        ],
      ),
    );
  }

  _buildSortListTile(
      {bool isAscendingList = false,
      String? sortByField,
      String label = "Nasumično"}) {
    return ListTile(
      leading: const Icon(Icons.sort),
      trailing: sortBy != null && sortBy == sortByField
          ? isAscendingList
              ? const Icon(Icons.arrow_upward)
              : const Icon(Icons.arrow_downward)
          : const Icon(Icons.horizontal_rule),
      title: Text(label),
      onTap: () {
        setState(() {
          sortBy = sortByField;
          isAscending = !isAscendingList;
        });
      },
    );
  }

  Widget _buildProductCard(Proizvod product) {
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
    );
  }
}
