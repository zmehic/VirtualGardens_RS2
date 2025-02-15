import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/jedinice_mjere.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/jedinice_mjere_provider.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_admin/screens/recenzije_list_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Proizvod? product;
  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late ProductProvider productProvider;
  late JediniceMjereProvider jediniceMjereProvider;
  late VrsteProizvodaProvider vrsteProizvodaProvider;

  SearchResult<JediniceMjere>? jediniceMjereResult;
  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;

  bool isLoading = true;
  List<Widget> actions = [];
  String? _base64Image;
  dynamic image;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    productProvider = context.read<ProductProvider>();
    jediniceMjereProvider = context.read<JediniceMjereProvider>();
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    initForm();
    super.initState();
  }

  bool checkIfJedinicaMjereExists(int jedinicaMjereId) {
    for (var i = 0; i < jediniceMjereResult!.result.length; i++) {
      if (jediniceMjereResult!.result[i].jedinicaMjereId == jedinicaMjereId) {
        return true;
      }
    }
    return false;
  }

  bool checkIfVrstaProizvodaExists(int vrstaProizvodaId) {
    for (var i = 0; i < vrsteProizvodaResult!.result.length; i++) {
      if (vrsteProizvodaResult!.result[i].vrstaProizvodaId ==
          vrstaProizvodaId) {
        return true;
      }
    }
    return false;
  }

  Future initForm() async {
    _initialValue = {
      'naziv': widget.product?.naziv,
      'opis': widget.product?.opis,
      'vrstaProizvodaId': widget.product?.vrstaProizvodaId.toString(),
      'jedinicaMjereId': widget.product?.jedinicaMjereId.toString(),
      'dostupnaKolicina': widget.product != null
          ? widget.product?.dostupnaKolicina.toString()
          : 0.toString(),
      'cijena': widget.product?.cijena.toString(),
    };

    _base64Image = widget.product?.slika;

    var filter = {
      'isDeleted': false,
    };
    jediniceMjereResult = await jediniceMjereProvider.get(filter: filter);
    vrsteProizvodaResult = await vrsteProizvodaProvider.get(filter: filter);
    if (widget.product != null) {
      _initialValue['jedinicaMjereId'] =
          checkIfJedinicaMjereExists(widget.product!.jedinicaMjereId!)
              ? widget.product!.jedinicaMjereId.toString()
              : null;

      _initialValue['vrstaProizvodaId'] =
          checkIfVrstaProizvodaExists(widget.product!.vrstaProizvodaId!)
              ? widget.product!.vrstaProizvodaId.toString()
              : null;
    }

    actions.add(widget.product != null
        ? Container(
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RecenzijeListScreen(
                            proizvod: widget.product,
                          )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade700,
                ),
                child: const Text(
                  "Recenzije",
                  style: TextStyle(color: Colors.white),
                )),
          )
        : Container());

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader2(
          isList: false,
          title:
              widget.product != null ? "Detalji o proizvodu" : "Dodaj proizvod",
          actions: actions,
          isLoading: isLoading,
          child: _buildMain(),
        ),
        "Detalji");
  }

  Widget _buildMain() {
    return Column(
      children: [
        Expanded(
          child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(103, 122, 105, 1),
              ),
              margin: const EdgeInsets.all(15),
              child: Container(
                margin: const EdgeInsets.all(30),
                child: Row(
                  children: [
                    _buildProductImage(),
                    _buildProductInformation(),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildProductImage() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.white,
                  width: 5,
                ),
              ),
              child: ClipRRect(
                child: Container(
                  color: const Color.fromRGBO(32, 76, 56, 1),
                  child: _base64Image != null
                      ? Image.memory(
                          base64Decode(_base64Image!),
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInformation() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(32, 76, 56, 1),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: _buildNewForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(235, 241, 224, 1),
            border: Border.all(color: Colors.brown.shade300, width: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                children: [
                  buildFormBuilderTextField(
                    maxLength: 100,
                    label: "Naziv",
                    name: "naziv",
                    isRequired: true,
                    minLength: 3,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildFormBuilderTextField(
                      label: "Opis", name: "opis", maxLength: 255),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown(
                        name: "vrstaProizvodaId",
                        decoration:
                            const InputDecoration(labelText: "Vrsta proizvoda"),
                        items: vrsteProizvodaResult?.result
                                .map((item) => DropdownMenuItem(
                                    value: item.vrstaProizvodaId.toString(),
                                    child: Text(item.naziv ?? "")))
                                .toList() ??
                            [],
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Vrsta proizvoda je obavezna."),
                        ])),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderDropdown(
                        name: "jedinicaMjereId",
                        decoration:
                            const InputDecoration(labelText: "Jedinica mjere"),
                        items: jediniceMjereResult?.result
                                .map((item) => DropdownMenuItem(
                                    value: item.jedinicaMjereId.toString(),
                                    child: Text(item.naziv ?? "")))
                                .toList() ??
                            [],
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Jedinica mjere je obavezna."),
                        ])),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          decoration: InputDecoration(
                              labelText:
                                  "Dostupna količina (${widget.product?.jedinicaMjere?.skracenica ?? ""})"),
                          name: "dostupnaKolicina",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Dostupna količina je obavezna."),
                          ]))),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: FormBuilderTextField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*')),
                            LengthLimitingTextInputFormatter(8),
                          ],
                          decoration: InputDecoration(
                              labelText:
                                  "Cijena (KM/${widget.product?.jedinicaMjere?.skracenica ?? ""})"),
                          name: "cijena",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Cijena je obavezna."),
                          ])))
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FormBuilderField(
                      name: "imageId",
                      builder: (field) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                              labelText: "Fotografija proizvoda"),
                          child: InkWell(
                            onTap: () async {
                              _base64Image = await chooseAnImage(context);
                              setState(() {});
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.image, size: 24),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                        "Odaberite fotografiju proizvoda (do 2 MB)"),
                                  ),
                                  Icon(Icons.file_upload),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.saveAndValidate() ==
                                    true) {
                                  debugPrint(
                                      _formKey.currentState?.value.toString());

                                  var request =
                                      Map.from(_formKey.currentState!.value);
                                  request['slika'] = _base64Image;
                                  request['slikaThumb'] = _base64Image;
                                  setState(() {});
                                  try {
                                    if (widget.product == null) {
                                      var response =
                                          await productProvider.insert(request);
                                      if (mounted) {
                                        await buildSuccessAlert(
                                            context,
                                            "Uspješno ste dodali proizvod",
                                            "Proizvod ${response.naziv} je dodan");
                                      }
                                    } else {
                                      var response =
                                          await productProvider.update(
                                              widget.product!.proizvodId!,
                                              request);
                                      if (mounted) {
                                        await buildSuccessAlert(
                                            context,
                                            "Uspješno ste ažurirali proizvod",
                                            "Proizvod ${response.naziv} je ažuriran");
                                      }
                                    }
                                  } on Exception catch (e) {
                                    if (mounted) {
                                      await buildErrorAlert(
                                          context, "Greška", e.toString(), e);
                                    }
                                    setState(() {});
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(8),
                              ),
                              child: const Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
