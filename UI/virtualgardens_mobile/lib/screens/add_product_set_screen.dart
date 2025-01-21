import 'dart:async';
import 'dart:convert';

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

  List<Proizvod>? recommendedProducts = [];

  TextEditingController quantityController =
      TextEditingController(); // Controller for the quantity field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    if (result != null && result!.result.isNotEmpty) {
      Proizvod? desiredElement = null;
      for (int i = 0; i < result!.result.length; i++) {
        if (recommendedProducts!
            .any((e) => e.proizvodId == result!.result[i].proizvodId)) {
          desiredElement = result!.result[i];
          break;
        }
      }
      if (desiredElement != null && result != null) {
        result!.result.remove(desiredElement);
        result!.result.insert(0, desiredElement);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader(
        isLoading: isLoading,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop(); // Go back to the previous screen
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[Container()],
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Novi set",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          ),
          body: Column(
            children: [
              _buildResultView(),
              _buildCreateOrderButton(),
            ],
          ),
        ),
      ),
      "Novi set",
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

          return Padding(
            padding: index + 1 == result!.result.length
                ? const EdgeInsets.only(top: 8.0, bottom: 100.0)
                : const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedProductIndex = isSelected ? null : index;
                  selectedProduct = isSelected ? null : product;
                });
              },
              child: Card(
                color: isSelected
                    ? Colors.green.shade300
                    : recommendedProducts!.any((element) =>
                                element.proizvodId == product.proizvodId) ==
                            true
                        ? Colors.yellow.shade300
                        : Colors.white,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
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
                            const SizedBox(height: 8),
                            recommendedProducts!.any((element) =>
                                        element.proizvodId ==
                                        product.proizvodId) ==
                                    true
                                ? Row(
                                    children: [
                                      Text("Preporučen proizvod"),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    ],
                                  )
                                : Container()
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
                        border: const OutlineInputBorder(),
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
                          if (brojac == 2 && selectedProduct != null) {
                            recommendedProducts = await _productProvider
                                .recommend(selectedProduct!.proizvodId!);
                          }
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
