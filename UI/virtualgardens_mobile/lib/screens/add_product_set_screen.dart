import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_mobile/providers/product_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_provider.dart';
import 'package:virtualgardens_mobile/providers/vrste_proizvoda_provider.dart';

class ProizvodiSetDTO {
  int? proizvodId;
  int? setId;
  int? kolicina;

  ProizvodiSetDTO({
    this.proizvodId,
    this.setId,
    this.kolicina,
  });

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

  Map<String, dynamic> _initialValue = {};
  Map<String, dynamic> _initialSearchValue = {};

  SearchResult<Proizvod>? result;
  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;
  final ScrollController _scrollControllerAddProduct = ScrollController();

  List<ProizvodiSetDTO>? productList = [];
  bool isLoading = true;
  int brojac = 2;
  int? selectedProductIndex;
  Proizvod? selectedProduct;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int productsPerPage = 3;

  List<Proizvod>? recommendedProducts = [];

  TextEditingController quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _addProductFormKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _productSearchFormKey =
      GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    _setoviProvider = context.read<SetoviProvider>();

    initForm();

    _scrollControllerAddProduct.addListener(() {
      if (_scrollControllerAddProduct.position.pixels ==
              _scrollControllerAddProduct.position.maxScrollExtent &&
          !isLoadingMore &&
          hasMoreData) {
        _loadMoreProducts();
      }
    });
  }

  Future initForm() async {
    _initialValue = {
      'kolicina': "0",
    };

    _initialSearchValue = {
      'naziv': "",
    };

    await fetchVrsteProizvoda();
    if (vrsteProizvodaResult != null &&
        vrsteProizvodaResult!.result.isNotEmpty == true) {
      await fetchProducts(
          vrstaProizvodaId:
              vrsteProizvodaResult!.result[brojac].vrstaProizvodaId!,
          reset: true);
    }
  }

  Future fetchVrsteProizvoda() async {
    var filter = {'isDeleted': false};

    vrsteProizvodaResult = await _vrsteProizvodaProvider.get(filter: filter);
  }

  Future fetchProducts(
      {int? vrstaProizvodaId,
      String searchQuery = "",
      bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      hasMoreData = true;
      result = null;
      isLoading = true;
    }
    setState(() {
      isLoadingMore = !reset;
    });
    var filter = {
      'NazivGTE': _productSearchFormKey.currentState?.fields['naziv']?.value
              .toString() ??
          "",
      'IncludeTables': "JedinicaMjere",
      'isDeleted': false,
      'Page': currentPage,
      'PageSize': productsPerPage,
      'vrstaProizvodaId': vrstaProizvodaId,
      'dostupnaKolicinaFrom': 1
    };

    var newResult = await _productProvider.get(filter: filter);
    if (newResult.result.isNotEmpty &&
        recommendedProducts != null &&
        recommendedProducts!.isNotEmpty) {
      Proizvod? desiredElement;
      for (int i = 0; i < newResult.result.length; i++) {
        for (int j = 0; j < recommendedProducts!.length; j++) {
          if (recommendedProducts![j].vrstaProizvodaId ==
              newResult.result[i].vrstaProizvodaId) {
            desiredElement = recommendedProducts![j];
            debugPrint("Match found: $desiredElement");
            break;
          }
        }
        if (desiredElement != null) break;
      }
      if (reset) {
        debugPrint("Reset is true");
        if (desiredElement != null) {
          for (int i = 0; i < newResult.result.length; i++) {
            if (newResult.result[i].proizvodId == desiredElement.proizvodId) {
              newResult.result.removeAt(i);
              debugPrint("Element removed at index: $i");
              break;
            }
          }
          newResult.result.insert(0, desiredElement);
          debugPrint("Updated list with reset: ${newResult.result}");
        }
      } else {
        debugPrint("Reset is false");
        if (desiredElement != null) {
          for (int i = 0; i < newResult.result.length; i++) {
            if (newResult.result[i].proizvodId == desiredElement.proizvodId) {
              newResult.result.removeAt(i);
              debugPrint("Element removed at index: $i");
              break;
            }
          }
        }
      }
    }

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
    await fetchProducts(
        vrstaProizvodaId:
            vrsteProizvodaResult!.result[brojac].vrstaProizvodaId!,
        reset: false);
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
              _buildSearchBar(),
              _buildResultView(),
              _buildCreateOrderButton(),
            ],
          ),
        ),
      ),
      "Novi set",
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilder(
        key: _productSearchFormKey,
        initialValue: _initialSearchValue,
        child: Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: 'naziv',
                maxLength: 100,
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
                fetchProducts(
                    searchQuery: _productSearchFormKey
                            .currentState?.fields['naziv']?.value
                            .toString() ??
                        "",
                    vrstaProizvodaId:
                        vrsteProizvodaResult!.result[brojac].vrstaProizvodaId!,
                    reset: true);
              },
              child: const Text("Pretraga"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: result != null
          ? ListView.builder(
              controller: _scrollControllerAddProduct,
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
                                      element.proizvodId ==
                                      product.proizvodId) ==
                                  true
                              ? Colors.yellow.shade300
                              : Colors.white,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
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
                                      ? const Row(
                                          children: [
                                            Text("Preporučen proizvod"),
                                            SizedBox(width: 8),
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
            )
          : Container(),
    );
  }

  Widget _buildCreateOrderButton() {
    return FormBuilder(
      key: _addProductFormKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: selectedProductIndex != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: SizedBox(
                        width: 100,
                        child: FormBuilderTextField(
                          name: "kolicina",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText:
                                "Kol - ${selectedProduct != null ? selectedProduct!.jedinicaMjere?.skracenica! : ""}",
                            border: const OutlineInputBorder(),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.min(1,
                                errorText:
                                    "Morate odabrati količinu veću ili jednaku 1"),
                            FormBuilderValidators.required(
                                errorText: "Količina je obavezna!"),
                            FormBuilderValidators.max(
                                int.tryParse(selectedProduct?.dostupnaKolicina
                                        ?.toString() ??
                                    "0")!,
                                errorText:
                                    "Količina ne može biti veća od dostupne količine")
                          ]),
                        ),
                      ),
                    ),
                  ),
                  brojac > 0
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(32, 76, 56, 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (_addProductFormKey.currentState
                                    ?.saveAndValidate() ==
                                true) {
                              setState(() {
                                isLoading = true;
                              });
                              productList!.add(ProizvodiSetDTO(
                                  proizvodId: selectedProduct!.proizvodId,
                                  kolicina: int.tryParse(int.tryParse(
                                          _addProductFormKey.currentState
                                              ?.fields['kolicina']?.value)
                                      .toString()),
                                  setId: null));
                              if (brojac == 2 && selectedProduct != null) {
                                recommendedProducts = await _productProvider
                                    .recommend(selectedProduct!.proizvodId!);
                              }
                              selectedProduct = null;
                              selectedProductIndex = null;
                              brojac--;
                              _productSearchFormKey.currentState
                                  ?.setInternalFieldValue('naziv', "");
                              await fetchProducts(
                                  vrstaProizvodaId: vrsteProizvodaResult!
                                      .result[brojac].vrstaProizvodaId!,
                                  reset: true);

                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: const Text(
                            "Dalje",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(32, 76, 56, 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (_addProductFormKey.currentState
                                    ?.saveAndValidate() ==
                                true) {
                              setState(() {
                                isLoading = true;
                              });
                              productList!.add(ProizvodiSetDTO(
                                  proizvodId: selectedProduct!.proizvodId,
                                  kolicina: int.tryParse(int.tryParse(
                                          _addProductFormKey.currentState
                                              ?.fields['kolicina']?.value)
                                      .toString()),
                                  setId: null));
                              selectedProduct = null;
                              selectedProductIndex = null;

                              var request = {
                                "cijena": 0,
                                "popust": 0,
                                "narudzbaId": widget.narudzba!.narudzbaId,
                                "cijenaSaPopustom": null,
                                "proizvodiSets":
                                    productList?.map((e) => e.toJson()).toList()
                              };
                              await _setoviProvider.insert(request);
                              if (mounted) {
                                Navigator.of(context).pop(true);
                              }
                            }
                          },
                          child: const Text(
                            "Završi",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                ],
              )
            : Container(),
      ),
    );
  }
}
