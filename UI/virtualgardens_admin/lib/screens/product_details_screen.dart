import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/jedinice_mjere.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/jedinice_mjere_provider.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  Proizvod? product;
  ProductDetailsScreen({super.key, this.product});

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    productProvider = context.read<ProductProvider>();
    jediniceMjereProvider = context.read<JediniceMjereProvider>();
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    super.initState();

    _initialValue = {
      'naziv': widget.product?.naziv,
      'opis': widget.product?.opis,
      'vrstaProizvodaId': widget.product?.vrstaProizvodaId.toString(),
      'jedinicaMjereId': widget.product?.jedinicaMjereId.toString(),
      'dostupnaKolicina': widget.product?.dostupnaKolicina.toString(),
      'cijena': widget.product?.cijena.toString()
    };

    InitForm();
  }

  Future InitForm() async {
    jediniceMjereResult = await jediniceMjereProvider.get();
    vrsteProizvodaResult = await vrsteProizvodaProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        Column(
          children: [isLoading ? Container() : _buildForm(), _saveRow()],
        ),
        "Detalji");
  }

  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                          decoration: InputDecoration(labelText: "Naziv"),
                          name: "naziv",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          })),
                  SizedBox(width: 10),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Opis"),
                    name: "opis",
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown(
                      name: "vrstaProizvodaId",
                      decoration: InputDecoration(labelText: "Vrsta proizvoda"),
                      items: vrsteProizvodaResult?.result
                              .map((item) => DropdownMenuItem(
                                  value: item.vrstaProizvodaId.toString(),
                                  child: Text(item.naziv ?? "")))
                              .toList() ??
                          [],
                    ),
                  ),
                  Expanded(
                    child: FormBuilderDropdown(
                      name: "jedinicaMjereId",
                      decoration: InputDecoration(labelText: "Jedinica mjere"),
                      items: jediniceMjereResult?.result
                              .map((item) => DropdownMenuItem(
                                  value: item.jedinicaMjereId.toString(),
                                  child: Text(item.naziv ?? "")))
                              .toList() ??
                          [],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Dostupna količina"),
                    name: "dostupnaKolicina",
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Cijena"),
                    name: "cijena",
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: FormBuilderField(
                    name: "imageId",
                    builder: (field) {
                      return InputDecorator(
                        decoration:
                            InputDecoration(labelText: "Choose an input image"),
                        child: ListTile(
                          leading: Icon(Icons.image),
                          title: Text("Select an image"),
                          trailing: Icon(Icons.file_upload),
                          onTap: getImage,
                        ),
                      );
                    },
                  ))
                ],
              )
            ],
          ),
        ));
  }

  Widget _saveRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.saveAndValidate() == true) {
                  debugPrint(_formKey.currentState?.value.toString());

                  var request = Map.from(_formKey.currentState!.value);
                  request['slika'] = _base64Image;
                  request['slikaThumb'] = _base64Image;

                  if (widget.product == null) {
                    productProvider.insert(request);
                  } else {
                    productProvider.update(
                        widget.product!.proizvodId!, request);
                  }
                }
              },
              child: Text("Sačuvaj"))
        ],
      ),
    );
  }

  File? _image;
  String? _base64Image;

  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }
}
