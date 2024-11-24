import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/jedinice_mjere.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/jedinice_mjere_provider.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_admin/screens/product_list_screen.dart';
import 'package:virtualgardens_admin/screens/recenzije_list_screen.dart';

// ignore: must_be_immutable
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
  bool isLoadingSave = false;
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

    initForm();
  }

  Future initForm() async {
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
            child: Container(
              margin: const EdgeInsets.only(
                  left: 40, right: 40, top: 20, bottom: 10),
              color: const Color.fromRGBO(235, 241, 224, 1),
              child: Column(
                children: [_buildBanner(), _buildMain()],
              ),
            )),
        "Detalji");
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(size: 45, color: Colors.white, Icons.sell_rounded),
            const SizedBox(
              width: 10,
            ),
            widget.product == null
                ? const Text("Novi proizvod",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arial",
                        color: Colors.white))
                : const Text("Detalji o proizvodu",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arial",
                        color: Colors.white)),
            const SizedBox(
              width: 10,
            ),
            widget.product == null
                ? Container()
                : IconButton(
                    icon: const Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RecenzijeListScreen(
                                proizvod: widget.product,
                              )));
                    },
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildMain() {
    return Expanded(
      child: Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(32, 76, 56, 1),
          ),
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(50),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(235, 241, 224, 1),
                                    width: 5)),
                            child: widget.product?.slika != null
                                ? imageFromString(_base64Image!)
                                : const Text(""),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color.fromRGBO(235, 241, 224, 1),
                    child: _buildNewForm(),
                  ),
                )
              ],
            ),
          )),
    );
  }

  File? _image;
  String? _base64Image;

  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);

      int fileSizeInBytes = await _image!.length();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMb > 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select an image up to 2 MB in size"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        _base64Image = base64Encode(await _image!.readAsBytes());
        setState(() {});
      }
    }
  }

  Widget _buildNewForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                        decoration: const InputDecoration(labelText: "Naziv"),
                        name: "naziv",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: const InputDecoration(labelText: "Opis"),
                      name: "opis",
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
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
                        validator: (value) {
                          if (value == null) {
                            return 'Please choose some value';
                          }
                          return null;
                        }),
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
                        validator: (value) {
                          if (value == null) {
                            return 'Please choose some value';
                          }
                          return null;
                        }),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly, // Allows only digits
                          ],
                          decoration: InputDecoration(
                              labelText:
                                  "Dostupna količina (${widget.product?.jedinicaMjere?.skracenica ?? ""})"),
                          name: "dostupnaKolicina",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field can not be empty';
                            }
                            return null;
                          })),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly, // Allows only digits
                          ],
                          decoration: InputDecoration(
                              labelText:
                                  "Cijena (KM/${widget.product?.jedinicaMjere?.skracenica ?? ""})"),
                          name: "cijena",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field can not be empty';
                            }
                            return null;
                          }))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  // Expanded widget for the image upload, taking up half of the width
                  Expanded(
                    child: FormBuilderField(
                      name: "imageId",
                      builder: (field) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                              labelText: "Choose an input image"),
                          child: ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text("Select an image"),
                            trailing: const Icon(Icons.file_upload),
                            onTap: getImage,
                          ),
                        );
                      },
                    ),
                  ),
                  // Expanded widget for the save button, taking up the other half of the width
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
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
                                isLoadingSave = true;
                                setState(() {});
                                try {
                                  if (widget.product == null) {
                                    await productProvider.insert(request);
                                  } else {
                                    await productProvider.update(
                                        widget.product!.proizvodId!, request);
                                  }

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProductListScreen()));
                                  // ignore: empty_catches
                                } on Exception {}
                              }
                            }, // Define this function to handle the save action
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape:
                                  const CircleBorder(), // Makes the button circular
                              padding: const EdgeInsets.all(
                                  8), // Adjust padding for icon size // Background color
                            ),

                            child: isLoadingSave
                                ? const CircularProgressIndicator()
                                : const Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ), // Save icon inside
                          ),
                        ),
                        widget.product != null
                            ? SizedBox(
                                width: 60,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    isLoadingSave = true;
                                    setState(() {});
                                    if (widget.product == null) {
                                    } else {
                                      await productProvider
                                          .delete(widget.product!.proizvodId!);
                                    }

                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProductListScreen()));
                                  }, // Define this function to handle the save action
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape:
                                        const CircleBorder(), // Makes the button circular
                                    padding: const EdgeInsets.all(
                                        8), // Adjust padding for icon size // Background color
                                  ),

                                  child: isLoadingSave
                                      ? const CircularProgressIndicator()
                                      : const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ), // Save icon inside
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
