import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/nalozi.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_mobile/models/zaposlenici.dart';
import 'package:virtualgardens_mobile/providers/nalozi_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';
import 'package:virtualgardens_mobile/providers/zaposlenici_provider.dart';
import 'package:virtualgardens_mobile/screens/zaposlenici_list_screen.dart';

// ignore: must_be_immutable
class ZaposleniciDetailsScreen extends StatefulWidget {
  Zaposlenik? zaposlenik;
  ZaposleniciDetailsScreen({super.key, this.zaposlenik});

  @override
  State<ZaposleniciDetailsScreen> createState() =>
      _ZaposleniciDetailsScreenState();
}

class _ZaposleniciDetailsScreenState extends State<ZaposleniciDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};

  late ZaposlenikProvider _zaposlenikProvider;
  late NaloziProvider _naloziProvider;

  UlazProizvod? zaposlenik;
  SearchResult<Nalog>? naloziResult;

  bool isLoading = true;
  bool isLoadingSave = false;

  final TextEditingController _datumRodjenjaController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _zaposlenikProvider = context.read<ZaposlenikProvider>();
    _naloziProvider = context.read<NaloziProvider>();

    super.initState();

    _initialValue = {
      "zaposlenikId": widget.zaposlenik?.zaposlenikId,
      "email": widget.zaposlenik?.email,
      "ime": widget.zaposlenik?.ime,
      "prezime": widget.zaposlenik?.prezime,
      "brojTelefona": widget.zaposlenik?.brojTelefona,
      "adresa": widget.zaposlenik?.adresa,
      "grad": widget.zaposlenik?.grad,
      "drzava": widget.zaposlenik?.drzava,
      "jeAktivan": widget.zaposlenik?.jeAktivan,
      "datumRodjenja": widget.zaposlenik?.datumRodjenja?.toIso8601String()
    };

    _datumRodjenjaController.text = widget.zaposlenik != null
        ? formatDateString(widget.zaposlenik!.datumRodjenja?.toIso8601String())
        : "";

    initForm();
  }

  Future initForm() async {
    var filter = {
      'ZaposlenikId': widget.zaposlenik?.zaposlenikId,
      'IsDeleted': false,
    };

    if (widget.zaposlenik != null) {
      naloziResult = await _naloziProvider.get(filter: filter);
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
        "Detalji o zaposleniku");
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
            widget.zaposlenik == null
                ? const Text("Novi zaposlenik",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arial",
                        color: Colors.white))
                : const Text("Detalji o zaposleniku",
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
                widget.zaposlenik != null
                    ? Expanded(
                        child: Container(
                          color: const Color.fromRGBO(235, 241, 224, 1),
                          child: Column(children: [
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
                      decoration: const InputDecoration(labelText: "Email"),
                      name: "email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "jeAktivan",
                  decoration: const InputDecoration(labelText: "Aktivan"),
                  initialValue: _initialValue['jeAktivan'] ?? true,
                  items: const [
                    DropdownMenuItem(value: true, child: Text("Da")),
                    DropdownMenuItem(value: false, child: Text("Ne")),
                  ],
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose some value';
                    }
                    return null;
                  },
                ))
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FormBuilderTextField(
                      decoration: const InputDecoration(labelText: "Ime"),
                      name: "ime",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                      decoration: const InputDecoration(labelText: "Prezime"),
                      name: "prezime",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    controller: _datumRodjenjaController,
                    decoration:
                        const InputDecoration(labelText: "Datum rođenja"),
                    name: "datumRodjenja",
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        _datumRodjenjaController.text =
                            formatDateString(pickedDate.toIso8601String());
                        _initialValue['datumRodjenja'] =
                            pickedDate.toIso8601String();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Broj telefona"),
                    name: "brojTelefona",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Adresa"),
                    name: "adresa",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Grad"),
                    name: "grad",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Država"),
                    name: "drzava",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            // Expanded widget for the save button, taking up the other half of the width

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() == true) {
                        debugPrint(_formKey.currentState?.value.toString());

                        var request = Map.from(_formKey.currentState!.value);
                        var key = request.entries.elementAt(4).key;
                        request[key] = _initialValue['datumRodjenja'];
                        isLoadingSave = true;
                        setState(() {});
                        try {
                          if (widget.zaposlenik == null) {
                            await _zaposlenikProvider.insert(request);
                          } else {
                            await _zaposlenikProvider.update(
                                widget.zaposlenik!.zaposlenikId, request);
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ZaposleniciListScreen()));
                          // ignore: empty_catches
                        } on Exception catch (e) {
                          isLoadingSave = false;
                          showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Ok"))
                                    ],
                                  ));
                          setState(() {});
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
                            Icons.save,
                            color: Colors.white,
                          ), // Save icon inside
                  ),
                ),
                widget.zaposlenik != null
                    ? const SizedBox(
                        width: 20,
                      )
                    : Container(),
                widget.zaposlenik != null
                    ? SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () async {
                            isLoadingSave = true;
                            setState(() {});
                            if (widget.zaposlenik == null) {
                            } else {
                              await _zaposlenikProvider
                                  .delete(widget.zaposlenik!.zaposlenikId);
                            }

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ZaposleniciListScreen()));
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
          ],
        ),
      ),
    );
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
                "Broj naloga",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Datum naloga",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
              DataColumn(
                label: Text(
                  "Završen",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
                rows: naloziResult?.result
                        .map((e) => DataRow(cells: [
                              DataCell(Text(e.brojNaloga,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18))),
                              DataCell(Text(
                                formatDateString(
                                    e.datumKreiranja.toIso8601String()),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                              DataCell(Text(
                                e.zavrsen == true ? "Da" : "Ne",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            ]))
                        .toList()
                        .cast<DataRow>() ??
                    [])));
  }
}
