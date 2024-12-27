import 'dart:convert';
import 'package:flutter/material.dart';
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
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider provider;
  late VrsteProizvodaProvider vrsteProizvodaProvider;

  SearchResult<Proizvod>? result;
  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;

  bool isLoading = true;
  int? selectedVrstaProizvoda;

  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
      'NazivGTE': searchQuery,
      'isDeleted': false,
      'VrstaProizvodaId': vrstaProizvodaId == 0 ? "" : vrstaProizvodaId,
      'IncludeTables': "JedinicaMjere,VrstaProizvoda",
    };

    vrsteProizvodaResult = await vrsteProizvodaProvider.get();
    vrsteProizvodaResult?.result
        .insert(0, VrstaProizvoda(vrstaProizvodaId: 0, naziv: "Svi"));

    if (vrstaProizvodaId != 0) {
      result = await provider.get(filter: filter);
    } else {
      result = await provider.get(filter: filter);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader(
          isLoading: isLoading,
          child: Column(
            children: [
              _buildBanner(),
              _buildSearchBar(),
              Expanded(child: _buildProductGrid()),
            ],
          ),
        ),
        "Proizvodi");
  }

  Widget _buildBanner() {
    return Container(
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(size: 45, color: Colors.white, Icons.shopping_cart),
            const SizedBox(width: 10),
            const Text(
              "Proizvodi",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Arial",
                color: Colors.white,
              ),
            ),
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
                    isLoading = true;
                    setState(() {});
                    _fetchProducts(
                        vrstaProizvodaId: selectedVrstaProizvoda,
                        searchQuery: _searchController.text);
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
    );
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
                filled: true, // Enables the background color
                fillColor:
                    Color.fromRGBO(235, 241, 224, 1), // Light green color
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _fetchProducts(
                  searchQuery: _searchController.text,
                  vrstaProizvodaId: selectedVrstaProizvoda);
            },
            child: const Text("Pretraga"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (result == null || result!.result.isEmpty) {
      return const Center(
        child: Text("Nema proizvoda za prikaz"),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: result!.result.length,
      itemBuilder: (context, index) {
        final product = result!.result[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Column(
              children: [
                // Image section (45% of the card height)
                AspectRatio(
                  aspectRatio: 12 / 9, // Ensures a consistent aspect ratio
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: product.slika != null
                        ? Image.memory(
                            base64Decode(product.slika!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : const SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                ),
                // Text section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.naziv ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${product.cijena} KM / ${product.jedinicaMjere?.skracenica ?? ''}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            "Na stanju: ${product.dostupnaKolicina} ${product.jedinicaMjere?.skracenica}")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
