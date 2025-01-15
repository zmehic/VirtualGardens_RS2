import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/proizvodi_setovi.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/narudzbe_provider.dart';
import 'package:virtualgardens_mobile/providers/product_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';
import 'package:virtualgardens_mobile/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_mobile/screens/narudzbe_details_screen.dart';

class ProizvodiSetDTO {
  int? proizvodId;
  int? setId;
  int? kolicina;

  ProizvodiSetDTO({
    this.proizvodId,
    this.setId,
    this.kolicina,
  });

  // Convert this object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'proizvodId': proizvodId,
      'setId': setId,
      'kolicina': kolicina,
    };
  }
}

class AddProductSetScreen extends StatefulWidget {
  final Narudzba? narudzba;
  const AddProductSetScreen({super.key, this.narudzba});

  @override
  State<AddProductSetScreen> createState() => _AddProductSetScreentate();
}

class _AddProductSetScreentate extends State<AddProductSetScreen> {
  late ProductProvider _productProvider;
  late VrsteProizvodaProvider _vrsteProizvodaProvider;
  late SetoviProvider _setoviProvider;
  SearchResult<Proizvod>? result;
  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;
  List<ProizvodiSetDTO>? productList = [];
  bool isLoading = true;
  int brojac = 2;
  int? selectedProductIndex;
  Proizvod? selectedProduct;
  TextEditingController quantityController =
      TextEditingController(); // Controller for the quantity field

  @override
  void initState() {
    _productProvider = context.read<ProductProvider>();
    _vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    _setoviProvider = context.read<SetoviProvider>();
    super.initState();
    setupPage();
  }

  Future setupPage() async {
    setState(() {
      isLoading = true;
    });
    await fetchVrsteProizvoda();
    if (vrsteProizvodaResult != null &&
        vrsteProizvodaResult!.result.isNotEmpty == true) {
      await fetchProducts(
          vrsteProizvodaResult!.result[brojac].vrstaProizvodaId!);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future fetchVrsteProizvoda() async {
    var filter = {'isDeleted': false};

    vrsteProizvodaResult = await _vrsteProizvodaProvider.get(filter: filter);
  }

  Future fetchProducts(int vrstaProizvodaId) async {
    final currentUserId = AuthProvider.korisnikId;

    var filter = {
      'vrstaProizvodaId': vrstaProizvodaId,
      'isDeleted': false,
      'dostupnaKolicinaFrom': 1
    };

    result = await _productProvider.get(filter: filter);
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
      "Novi set",
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
              "Novi set",
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
          final product = result!.result[index];

          // Determine if the card is selected
          bool isSelected = selectedProductIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedProductIndex = isSelected ? null : index;
                selectedProduct = isSelected ? null : product;
              });
            },
            child: Card(
              color: isSelected
                  ? Colors.green.shade300
                  : Colors.green.shade100, // Highlight the selected card
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product.slika != null
                        ? imageFromString(product.slika!)
                        : Image.asset('assets/images/user.png')),
                title: Text(
                  product.naziv ?? "N/A",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cijena: ${product.cijena ?? 0} KM"),
                    Text(
                        "Količina: ${product.dostupnaKolicina ?? 0} ${product.jedinicaMjere?.skracenica ?? ""}"),
                  ],
                ),
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
      child: selectedProductIndex != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Quantity Field (only visible when a product is selected)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText:
                            "Kol - ${selectedProduct != null ? selectedProduct!.jedinicaMjere?.skracenica! : ""}",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        var vrijednost = int.tryParse(value.toString());
                        if (vrijednost != null) {
                          if (vrijednost > selectedProduct!.dostupnaKolicina!) {
                            quantityController.text =
                                selectedProduct!.dostupnaKolicina.toString();
                          }
                        }
                      },
                    ),
                  ),
                ),
                // "Dalje" Button
                brojac > 0
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (quantityController.text.isEmpty) {
                            // Show an error if the field is empty
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Polje Količina mora biti popunjeno!'),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          productList!.add(ProizvodiSetDTO(
                              proizvodId: selectedProduct!.proizvodId,
                              kolicina: int.tryParse(quantityController.text),
                              setId: null));
                          selectedProduct = null;
                          selectedProductIndex = null;
                          quantityController.clear();
                          brojac--;
                          await fetchProducts(vrsteProizvodaResult!
                              .result[brojac].vrstaProizvodaId!);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Text(
                          "Dalje",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (quantityController.text.isEmpty) {
                            // Show an error if the field is empty
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Polje Količina mora biti popunjeno!'),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          productList!.add(ProizvodiSetDTO(
                              proizvodId: selectedProduct!.proizvodId,
                              kolicina: int.tryParse(quantityController.text),
                              setId: null));
                          selectedProduct = null;
                          selectedProductIndex = null;
                          quantityController.clear();
                          var request = {
                            "cijena": 0,
                            "popust": 0,
                            "narudzbaId": widget.narudzba!.narudzbaId,
                            "cijenaSaPopustom": null,
                            "proizvodiSets":
                                productList?.map((e) => e.toJson()).toList()
                          };
                          await _setoviProvider.insert(request);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NarudzbaUserDetailsScreen(
                                narudzba: widget.narudzba,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Završi",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
              ],
            )
          : Container(),
    );
  }
}
