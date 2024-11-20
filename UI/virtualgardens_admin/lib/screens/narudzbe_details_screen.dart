import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/screens/narudzbe_list_screen.dart';
import 'package:virtualgardens_admin/screens/zaposlenici_list_screen.dart';
import 'package:virtualgardens_admin/models/set.dart';

// ignore: must_be_immutable
class NarudzbeDetailsScreen extends StatefulWidget {
  Narudzba? narudzba;
  NarudzbeDetailsScreen({super.key, this.narudzba});

  @override
  State<NarudzbeDetailsScreen> createState() => _NarudzbeDetailsScreenState();
}

class _NarudzbeDetailsScreenState extends State<NarudzbeDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};

  late NarudzbaProvider _narudzbaProvider;
  late SetoviProvider _setoviProvider;

  SearchResult<Set>? setoviResult;

  UlazProizvod? zaposlenik;

  String? korisnik;

  bool isLoading = true;
  bool isLoadingSave = false;

  final TextEditingController _datumNarudzbeController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _narudzbaProvider = context.read<NarudzbaProvider>();
    _setoviProvider = context.read<SetoviProvider>();

    super.initState();

    _initialValue = {
      "narudzbaId": widget.narudzba?.narudzbaId,
      "brojNarudzbe": widget.narudzba?.brojNarudzbe,
      "otkazana": widget.narudzba?.otkazana,
      "datum": widget.narudzba?.datum.toIso8601String(),
      "placeno": widget.narudzba?.placeno,
      "status": widget.narudzba?.status,
      "stateMachine": widget.narudzba?.stateMachine,
      "ukupnaCijena": widget.narudzba?.ukupnaCijena,
      "korisnikId": widget.narudzba?.korisnikId,
    };

    korisnik = "${widget.narudzba?.korisnik?.korisnickoIme}";
    _datumNarudzbeController.text = widget.narudzba != null
        ? formatDateString(widget.narudzba!.datum.toIso8601String())
        : "";

    initForm();
  }

  Future initForm() async {
    var filter = {
      'NarudzbaId': widget.narudzba?.narudzbaId,
      'isDeleted': false,
      'IncludeTables': "ProizvodiSets"
    };
    setoviResult = await _setoviProvider.get(filter: filter);
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
        "Detalji o narudžbi");
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(size: 45, color: Colors.white, Icons.edit_note_rounded),
            SizedBox(
              width: 10,
            ),
            Text("Detalji o narudžbi",
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
                Expanded(
                  child: Container(
                    color: const Color.fromRGBO(235, 241, 224, 1),
                    child: Column(children: [
                      Expanded(
                        child: _buildResultView(),
                      )
                    ]),
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

  Widget _buildResultView() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: setoviResult?.result.length,
              itemBuilder: (context, index) {
                final record = setoviResult?.result[index];
                return setoviResult != null &&
                        setoviResult?.result[index] != null &&
                        setoviResult?.result[index].proizvodiSets.length == 3
                    ? _buildExpansionTile(index)
                    : Container();
              },
            )
          ],
        )));
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
                      readOnly: true,
                      decoration:
                          const InputDecoration(labelText: "Broj narudžbe"),
                      name: "brojNarudzbe",
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
                  enabled: false,
                  name: "otkazana",
                  decoration: const InputDecoration(labelText: "Otkazana"),
                  initialValue: _initialValue['otkazana'] ?? true,
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
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  enabled: false,
                  name: "placeno",
                  decoration: const InputDecoration(labelText: "Plaćeno"),
                  initialValue: _initialValue['placeno'] ?? true,
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
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  enabled: false,
                  name: "stateMachine",
                  decoration: const InputDecoration(labelText: "Status"),
                  initialValue: _initialValue['stateMachine'] ?? true,
                  items: const [
                    DropdownMenuItem(value: "created", child: Text("Kreirana")),
                    DropdownMenuItem(
                        value: "inprogress", child: Text("U procesu")),
                    DropdownMenuItem(
                        value: "finished", child: Text("Završena")),
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
                      decoration:
                          const InputDecoration(labelText: "Datum narudžbe"),
                      readOnly: true,
                      controller: _datumNarudzbeController,
                      name: "datum",
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
                      decoration:
                          const InputDecoration(labelText: "Ukupna cijena"),
                      readOnly: true,
                      name: "ukupnaCijena",
                      initialValue: _initialValue['ukupnaCijena'].toString(),
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
                      decoration: const InputDecoration(labelText: "Kupac"),
                      readOnly: true,
                      name: "korisnickoIme",
                      initialValue: korisnik ?? "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }),
                ),
              ],
            ),
            const SizedBox(height: 15),
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
                        isLoadingSave = true;
                        setState(() {});
                        try {
                          await _narudzbaProvider.update(
                              widget.narudzba!.narudzbaId, request);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NarduzbeListScreen()));
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
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      isLoadingSave = true;
                      setState(() {});

                      await _narudzbaProvider
                          .delete(widget.narudzba!.narudzbaId);

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ZaposleniciListScreen()));
                    }, // Define this function to handle the save action
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(), // Makes the button circular
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        title: Text(
          "Set ${index + 1} - ${setoviResult?.result[index].cijenaSaPopustom} KM",
          style: TextStyle(color: Colors.black),
        ),
        textColor: Colors.white,
        children: [
          ListTile(
              title: Text(
                  "${setoviResult?.result[index].proizvodiSets[0].proizvod?.naziv ?? ""} x ${setoviResult?.result[index].proizvodiSets[0].kolicina ?? ""} ${setoviResult?.result[index].proizvodiSets[0].proizvod?.jedinicaMjere?.skracenica ?? ""} = ${(setoviResult?.result[index].proizvodiSets[0].kolicina ?? 0) * (setoviResult?.result[index].proizvodiSets[0].proizvod?.cijena ?? 0.0)} KM",
                  style: TextStyle(color: Colors.black))),
          ListTile(
              title: Text(
                  "${setoviResult?.result[index].proizvodiSets[1].proizvod?.naziv ?? ""} x ${setoviResult?.result[index].proizvodiSets[1].kolicina ?? ""} ${setoviResult?.result[index].proizvodiSets[1].proizvod?.jedinicaMjere?.skracenica ?? ""} = ${(setoviResult?.result[index].proizvodiSets[1].kolicina ?? 0) * (setoviResult?.result[index].proizvodiSets[1].proizvod?.cijena ?? 0.0)} KM",
                  style: TextStyle(color: Colors.black))),
          ListTile(
              title: Text(
                  "${setoviResult?.result[index].proizvodiSets[2].proizvod?.naziv ?? ""} x ${setoviResult?.result[index].proizvodiSets[2].kolicina ?? ""} ${setoviResult?.result[index].proizvodiSets[2].proizvod?.jedinicaMjere?.skracenica ?? ""} = ${(setoviResult?.result[index].proizvodiSets[2].kolicina ?? 0) * (setoviResult?.result[index].proizvodiSets[2].proizvod?.cijena ?? 0.0)} KM",
                  style: TextStyle(color: Colors.black)))
        ],
      ),
    );
  }
}
