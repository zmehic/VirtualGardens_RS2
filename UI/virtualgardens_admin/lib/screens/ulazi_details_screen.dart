import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi.dart';
import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/ulazi_proizvodi_provider.dart';
import 'package:virtualgardens_admin/providers/ulazi_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/screens/ulazi_list_screen.dart';

// ignore: must_be_immutable
class UlaziDetailsScreen extends StatefulWidget {
  Ulaz? ulaz;
  UlaziDetailsScreen({super.key, this.ulaz});

  @override
  State<UlaziDetailsScreen> createState() => _UlaziDetailsScreenState();
}

class _UlaziDetailsScreenState extends State<UlaziDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey2 = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};
  Map<String, dynamic> _initialValue2 = {};

  late UlaziProvider _ulaziProvider;
  late UlaziProizvodiProvider _ulaziProizvodiProvider;
  late ProductProvider _proizvodiProvider;

  SearchResult<UlazProizvod>? ulaziProizvodiResult;
  SearchResult<Proizvod>? proizvodiResult;

  bool isLoading = true;
  bool isLoadingSave = false;

  final TextEditingController _datumUlazaController = TextEditingController();

  final Map<int, TextEditingController> _controllers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _ulaziProvider = context.read<UlaziProvider>();
    _ulaziProizvodiProvider = context.read<UlaziProizvodiProvider>();
    _proizvodiProvider = context.read<ProductProvider>();

    super.initState();

    _initialValue = {
      'ulazId': widget.ulaz?.ulazId,
      'brojUlaza': widget.ulaz?.brojUlaza,
      'datumUlaza': widget.ulaz?.datumUlaza.toIso8601String(),
      'korisnikId': widget.ulaz?.korisnikId,
    };

    _initialValue2 = {
      'ulazId': widget.ulaz?.ulazId,
      'proizvoidId': null,
      'kolicina': null
    };

    _datumUlazaController.text = widget.ulaz != null
        ? formatDateString(widget.ulaz!.datumUlaza.toIso8601String())
        : "";

    initForm();
  }

  Future initForm() async {
    var filter = {
      'UlazId': widget.ulaz?.ulazId,
      'IsDeleted': false,
      'IncludeTables': "Proizvod"
    };

    if (widget.ulaz != null) {
      ulaziProizvodiResult = await _ulaziProizvodiProvider.get(filter: filter);
      if (ulaziProizvodiResult != null) {
        for (var product in ulaziProizvodiResult!.result) {
          _controllers[product.ulaziProizvodiId] =
              TextEditingController(text: product.kolicina.toString());
        }
      }

      var filter2 = {'IsDeleted': false, 'IncludeTables': "JedinicaMjere"};

      proizvodiResult = await _proizvodiProvider.get(filter: filter2);
    }
    setState(() {
      isLoading = false;
      isLoadingSave = false;
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
            const Icon(size: 45, color: Colors.white, Icons.edit_note_rounded),
            const SizedBox(
              width: 10,
            ),
            widget.ulaz == null
                ? const Text("Novi ulaz",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arial",
                        color: Colors.white))
                : const Text("Detalji o ulazu",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arial",
                        color: Colors.white))
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
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                widget.ulaz != null
                    ? Expanded(
                        child: Container(
                          color: const Color.fromRGBO(235, 241, 224, 1),
                          child: Column(children: [
                            _buildUlaziProizvodiForm(),
                            Expanded(
                              child: _buildResultView(),
                            )
                          ]),
                        ),
                      )
                    : Container(),
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
                        decoration:
                            const InputDecoration(labelText: "Broj ulaza"),
                        name: "brojUlaza",
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
                      controller: _datumUlazaController,
                      decoration:
                          const InputDecoration(labelText: "Datum ulaza"),
                      name: "datumUlaza",
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose some value';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          _datumUlazaController.text =
                              formatDateString(pickedDate.toIso8601String());
                          _initialValue['datumUlaza'] =
                              pickedDate.toIso8601String();
                        }
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  widget.ulaz != null
                      ? Expanded(
                          child: FormBuilderDropdown(
                              enabled: false,
                              name: "korisnikId",
                              decoration:
                                  const InputDecoration(labelText: "Korisnik"),
                              items: [
                                DropdownMenuItem(
                                    value: widget.ulaz?.korisnikId,
                                    child: Text(
                                        "${widget.ulaz?.korisnik.ime} ${widget.ulaz?.korisnik.prezime}"))
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return 'Please choose some value';
                                }
                                return null;
                              }))
                      : Container(),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                var key = request.entries.elementAt(1).key;
                                request[key] = _initialValue['datumUlaza'];
                                request['korisnikId'] = AuthProvider.korisnikId;
                                isLoadingSave = true;
                                setState(() {});
                                try {
                                  if (widget.ulaz == null) {
                                    await _ulaziProvider.insert(request);
                                  } else {
                                    await _ulaziProvider.update(
                                        widget.ulaz!.ulazId, request);
                                  }

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UlaziListScreen()));
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
                        const SizedBox(
                          width: 20,
                        ),
                        widget.ulaz != null
                            ? SizedBox(
                                width: 60,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    isLoadingSave = true;
                                    setState(() {});
                                    if (widget.ulaz == null) {
                                    } else {
                                      await _ulaziProvider
                                          .delete(widget.ulaz!.ulazId);
                                    }

                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UlaziListScreen()));
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

  Widget _buildResultView() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: SingleChildScrollView(
            child: DataTable(
                columns: const [
              DataColumn(
                  label: Text(
                "Proizvod",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Količina",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
              DataColumn(
                label: Text(
                  "Obriši",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
                rows: ulaziProizvodiResult?.result
                        .map((e) => DataRow(cells: [
                              DataCell(Text(e.proizvod!.naziv!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18))),
                              DataCell(TextField(
                                controller: _controllers[e.ulaziProizvodiId],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                onSubmitted: (value) async {
                                  if (value.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Molimo unesite neku vrijednost veću od 0!"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    _controllers[e.ulaziProizvodiId]?.text =
                                        e.kolicina.toString();
                                  } else {
                                    int? intValue = int.tryParse(value);
                                    if (intValue == null || intValue <= 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Molimo unesite neku vrijednost veću od 0!"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      var request = {
                                        'ulazId': e.ulazId,
                                        'proizvodId': e.proizvodId,
                                        'kolicina': intValue
                                      };
                                      try {
                                        await _ulaziProizvodiProvider.update(
                                            e.ulaziProizvodiId, request);
                                      } on Exception catch (e) {
                                        debugPrint(e.toString());
                                      }
                                      setState(() {});
                                    }
                                  }
                                },
                              )),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    try {
                                      await _ulaziProizvodiProvider
                                          .delete(e.ulaziProizvodiId);
                                    } on Exception catch (e) {
                                      debugPrint(e.toString());
                                    }
                                    initForm();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ]))
                        .toList()
                        .cast<DataRow>() ??
                    [])));
  }

  _buildUlaziProizvodiForm() {
    return FormBuilder(
      key: _formKey2,
      initialValue: _initialValue2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: FormBuilderDropdown(
                name: "proizvodId",
                decoration: const InputDecoration(labelText: "Proizvod"),
                items: proizvodiResult?.result
                        .map((item) => DropdownMenuItem(
                              value: item.proizvodId.toString(),
                              child: Text(
                                  "${item.naziv} (${item.jedinicaMjere?.skracenica})"),
                            ))
                        .toList() ??
                    [],
                validator: (value) {
                  if (value == null) {
                    return 'Please choose some value';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderTextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: "Kolicina"),
                  name: "kolicina",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some value';
                    }
                    return null;
                  }),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 45,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey2.currentState?.saveAndValidate() == true) {
                    debugPrint(_formKey.currentState?.value.toString());

                    var request = Map.from(_formKey2.currentState!.value);
                    request['ulazId'] = widget.ulaz?.ulazId;
                    isLoadingSave = true;
                    setState(() {});
                    try {
                      if (widget.ulaz == null) {
                      } else {
                        await _ulaziProizvodiProvider.insert(request);
                      }

                      _formKey2.currentState?.reset();
                      initForm();
                      setState(() {});
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                }, // Define this function to handle the save action
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(), // Makes the button circular
                  padding: const EdgeInsets.all(
                      8), // Adjust padding for icon size // Background color
                ),

                child: isLoadingSave
                    ? const CircularProgressIndicator()
                    : const Icon(
                        Icons.add,
                        color: Colors.white,
                      ), // Save icon inside
              ),
            )
          ],
        ),
      ),
    );
  }
}
