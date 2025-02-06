import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
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

  String? _base64Image;
  dynamic image;

  final GlobalKey<ScaffoldState> _scaffoldProductDetails =
      GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    productProvider = context.read<ProductProvider>();
    jediniceMjereProvider = context.read<JediniceMjereProvider>();
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    super.initState();
    initForm();
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

    jediniceMjereResult = await jediniceMjereProvider.get();
    vrsteProizvodaResult = await vrsteProizvodaProvider.get();

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
            key: _scaffoldProductDetails,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              actions: <Widget>[
                widget.product != null
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
                    : Container(),
              ],
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                widget.product != null
                    ? "Detalji o proizvodu"
                    : "Dodaj proizvod",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
            ),
            backgroundColor: const Color.fromRGBO(103, 122, 105, 1),
            body: _buildMain(),
          ),
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
                    label: "Naziv",
                    name: "naziv",
                    isRequired: true,
                    minLength: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildFormBuilderTextField(
                    label: "Opis",
                    name: "opis",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
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
            const SizedBox(height: 15),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
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
                                RegExp(r'^\d*\.?\d*')),
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
            const SizedBox(
              height: 15,
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
                                      await productProvider.insert(request);
                                      if (mounted) {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          title: "Proizvod je dodan",
                                          confirmBtnText: "U redu",
                                          text:
                                              "Uspješno ste dodali novi proizvod",
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop(true);
                                          },
                                        );
                                      }
                                    } else {
                                      await productProvider.update(
                                          widget.product!.proizvodId!, request);
                                      if (mounted) {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          title: "Proizvod je ažuriran",
                                          confirmBtnText: "U redu",
                                          text:
                                              "Uspješno ste ažurirali podatke o proizvodu",
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop(true);
                                          },
                                        );
                                      }
                                    }
                                  } on Exception catch (e) {
                                    if (mounted) {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          title:
                                              "Greška prilikom ažuriranja ili dodavanja",
                                          text: (e.toString().split(': '))[1],
                                          confirmBtnText: "U redu");
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
