import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/nalozi.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/models/zaposlenici.dart';
import 'package:virtualgardens_admin/providers/nalozi_provider.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/providers/zaposlenici_provider.dart';
import 'package:virtualgardens_admin/screens/nalozi_list_screen.dart';

// ignore: must_be_immutable
class NaloziDetailsScreen extends StatefulWidget {
  Nalog? nalog;
  NaloziDetailsScreen({super.key, this.nalog});

  @override
  State<NaloziDetailsScreen> createState() => _NaloziDetailsScreenState();
}

class _NaloziDetailsScreenState extends State<NaloziDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey2 = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};
  Map<String, dynamic> _initialValue2 = {};

  late NaloziProvider _naloziProvider;
  late NarudzbaProvider _narudzbaProvider;
  late ZaposlenikProvider _zaposlenikProvider;

  SearchResult<UlazProizvod>? ulaziProizvodiResult;
  SearchResult<Narudzba>? narudzbaResult;
  SearchResult<Zaposlenik>? zaposleniciResult;

  bool isLoading = true;
  bool isLoadingSave = false;

  int? zaposlenikId = 0;
  int? narudzbaId;

  final TextEditingController _datumNalogaController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _naloziProvider = context.read<NaloziProvider>();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    _zaposlenikProvider = context.read<ZaposlenikProvider>();

    zaposlenikId = widget.nalog?.zaposlenikId;

    super.initState();

    _initialValue = {
      'nalogId': widget.nalog?.nalogId,
      'brojNaloga': widget.nalog?.brojNaloga,
      'datumNaloga': widget.nalog?.datumKreiranja.toIso8601String() ??
          formatDateString(DateTime.now().toIso8601String()),
      'zaposlenikId': widget.nalog?.zaposlenikId,
      'zavrsen': widget.nalog?.zavrsen
    };

    _datumNalogaController.text = widget.nalog != null
        ? formatDateString(widget.nalog!.datumKreiranja.toIso8601String())
        : formatDateString(DateTime.now().toIso8601String());

    initForm();
  }

  Future initForm() async {
    var filter = {
      'isDeleted': false,
    };

    zaposleniciResult = await _zaposlenikProvider.get(filter: filter);

    if (widget.nalog != null) {
      var filter2 = {
        'IsDeleted': false,
        'NalogId': 0,
        'Otkazana': false,
        'Placeno': true,
        'StateMachine': "created",
      };

      narudzbaResult = await _narudzbaProvider.get(filter: filter2);
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
            widget.nalog == null
                ? const Text("Novi nalog",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arial",
                        color: Colors.white))
                : const Text("Detalji o nalogu",
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
                widget.nalog != null
                    ? Expanded(
                        child: Container(
                          color: const Color.fromRGBO(235, 241, 224, 1),
                          child: Column(children: [
                            _buildNarudzbeForm(),
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
                            const InputDecoration(labelText: "Broj naloga"),
                        name: "brojNaloga",
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
                      enabled: false,
                      controller: _datumNalogaController,
                      decoration:
                          const InputDecoration(labelText: "Datum naloga"),
                      name: "datumNaloga",
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
                          _datumNalogaController.text =
                              formatDateString(pickedDate.toIso8601String());
                          _initialValue['datumNaloga'] =
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
                  Expanded(
                      child: FormBuilderDropdown(
                    enabled: true,
                    name: "zaposlenikId",
                    initialValue: widget.nalog?.zaposlenikId.toString(),
                    decoration: const InputDecoration(labelText: "Zaposlenik"),
                    items: zaposleniciResult?.result
                            .map((item) => DropdownMenuItem(
                                  value: item.zaposlenikId.toString(),
                                  child: Text("${item.ime} ${item.prezime}"),
                                ))
                            .toList() ??
                        [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please choose some value';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      zaposlenikId = int.tryParse(value.toString());
                    },
                  )),
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
                                request[key] = _initialValue['datumNaloga'];
                                request['zaposlenikId'] = zaposlenikId;
                                request['narudzbe'] = [];
                                isLoadingSave = true;
                                setState(() {});
                                try {
                                  if (widget.nalog == null) {
                                    await _naloziProvider.insert(request);
                                  } else {
                                    await _naloziProvider.update(
                                        widget.nalog!.nalogId, request);
                                  }

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NaloziListScreen()));
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
                        widget.nalog != null && widget.nalog!.narudzbes.isEmpty
                            ? SizedBox(
                                width: 60,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    isLoadingSave = true;
                                    setState(() {});
                                    if (widget.nalog == null) {
                                    } else {
                                      await _naloziProvider
                                          .delete(widget.nalog!.nalogId);
                                    }

                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NaloziListScreen()));
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
                "Narudzba",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Datum",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
              DataColumn(
                label: Text(
                  "Cijena",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              DataColumn(
                label: Text(
                  "Akcija",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
                rows: widget.nalog?.narudzbes
                        .map((e) => DataRow(cells: [
                              DataCell(Text(e.brojNarudzbe,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18))),
                              DataCell(Text(
                                  formatDateString(e.datum.toIso8601String()),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18))),
                              DataCell(Text(e.ukupnaCijena.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18))),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    Map<dynamic, dynamic> request = {};
                                    request['brojNarudzbe'] = e.brojNarudzbe;
                                    request['ukupnaCijena'] = e.ukupnaCijena;
                                    request['korisnikId'] = e.korisnikId;
                                    request['nalogId'] = null;
                                    try {
                                      await _narudzbaProvider.update(
                                          e.narudzbaId, request);
                                      widget.nalog?.narudzbes.removeWhere(
                                          (element) =>
                                              element.narudzbaId ==
                                              e.narudzbaId);
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

  _buildNarudzbeForm() {
    return FormBuilder(
      key: _formKey2,
      initialValue: _initialValue2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: FormBuilderDropdown(
                name: "narudzbaId",
                decoration: const InputDecoration(labelText: "Narudžba"),
                items: narudzbaResult?.result
                        .map((item) => DropdownMenuItem(
                              value: item.narudzbaId.toString(),
                              child: Text(item.brojNarudzbe),
                            ))
                        .toList() ??
                    [],
                validator: (value) {
                  if (value == null) {
                    return 'Please choose some value';
                  }
                  return null;
                },
                onChanged: (value) {
                  narudzbaId = int.tryParse(value.toString());
                },
              ),
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

                    Map<dynamic, dynamic> request = {};
                    var narudzba = narudzbaResult?.result
                        .where((element) => element.narudzbaId == narudzbaId)
                        .first;
                    request['brojNarudzbe'] = narudzba?.brojNarudzbe;
                    request['ukupnaCijena'] = narudzba?.ukupnaCijena;
                    request['korisnikId'] = narudzba?.korisnikId;
                    request['nalogId'] = widget.nalog?.nalogId;
                    isLoadingSave = true;
                    setState(() {});
                    try {
                      if (widget.nalog == null) {
                      } else {
                        await _narudzbaProvider.update(
                            narudzba!.narudzbaId, request);
                        widget.nalog!.narudzbes.add(Narudzba(
                            narudzbaId: narudzba.narudzbaId,
                            brojNarudzbe: narudzba.brojNarudzbe,
                            datum: narudzba.datum,
                            placeno: narudzba.placeno,
                            ukupnaCijena: narudzba.ukupnaCijena,
                            korisnikId: narudzba.korisnikId));
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
