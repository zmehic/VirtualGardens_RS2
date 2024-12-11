import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/providers/narudzbe_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';
import 'package:virtualgardens_mobile/screens/narudzbe_details_screen.dart';

class NarduzbeListScreen extends StatefulWidget {
  const NarduzbeListScreen({super.key});

  @override
  State<NarduzbeListScreen> createState() => _NarudzbeListScreenState();
}

class _NarudzbeListScreenState extends State<NarduzbeListScreen> {
  late NarudzbaProvider _narudzbaProvider;

  SearchResult<Narudzba>? result;
  late Map<int, String> korisnici = {};

  bool isLoading = true;

  bool? jeOtkazan = null;
  bool? jePlacen = null;
  String? created = null;
  int? korisnik = null;

  String datumOdString = "";
  String datumDoString = "";

  final TextEditingController _brojNarudzbeEditingController =
      TextEditingController();
  final TextEditingController _datumOdEditingController =
      TextEditingController();
  final TextEditingController _datumDoEditingController =
      TextEditingController();
  final TextEditingController _cijenaOdEditingController =
      TextEditingController();
  final TextEditingController _cijenaDoEditingController =
      TextEditingController();

  @override
  void initState() {
    _narudzbaProvider = context.read<NarudzbaProvider>();
    super.initState();
    initScreen();
  }

  Future initScreen() async {
    var filter = {
      'isDeleted': jeOtkazan,
      'IncludeTables': "Korisnik",
      'Placeno': jePlacen
    };

    result = await _narudzbaProvider.get(filter: filter);

    korisnici[0] = "Svi";

    if (result != null) {
      for (var element in result!.result) {
        if (korisnici.keys.contains(element.korisnikId) == false) {
          korisnici[element.korisnikId] =
              "${element.korisnik?.ime} ${element.korisnik?.prezime}";
        }
      }
    }

    _brojNarudzbeEditingController.text = "";
    _datumOdEditingController.text = "";
    _datumDoEditingController.text = "";

    _cijenaOdEditingController.text = "";
    _cijenaDoEditingController.text = "";

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader(
        isLoading: isLoading, // Your loading state
        child: Container(
          margin:
              const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
          color: const Color.fromRGBO(235, 241, 224, 1),
          child: Column(
            children: [
              _buildBanner(),
              _buildSearch(),
              _buildResultView(),
            ],
          ),
        ),
      ),
      "Narudzbe",
    );
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
            Icon(size: 45, color: Colors.white, Icons.shopping_cart),
            SizedBox(
              width: 10,
            ),
            Text("Narudžbe",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arial",
                    color: Colors.white)),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _brojNarudzbeEditingController,
              decoration: const InputDecoration(labelText: "Broj narudzbe"),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _datumOdEditingController,
              decoration: const InputDecoration(labelText: "Datum od:"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  datumOdString = pickedDate.toIso8601String();
                  _datumOdEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                }
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _datumDoEditingController,
              decoration: const InputDecoration(labelText: "Datum do:"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  datumDoString = pickedDate.toIso8601String();
                  _datumDoEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                }
              },
            )),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _datumOdEditingController.clear();
                _datumDoEditingController.clear();
                datumDoString = "";
                datumOdString = "";
              },
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _cijenaOdEditingController,
              decoration: const InputDecoration(labelText: "Cijena od"),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _cijenaDoEditingController,
              decoration: const InputDecoration(labelText: "Cijena do"),
            )),
            const SizedBox(
              width: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400)),
              child: DropdownMenu(
                initialSelection: 0,
                enableFilter: false,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 0, label: "Svi"),
                  DropdownMenuEntry(value: 1, label: "Otkazano"),
                  DropdownMenuEntry(value: 2, label: "Neotkazano"),
                ],
                menuStyle: MenuStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(4),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300)))),
                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                onSelected: (value) {
                  if (value != null) {
                    if (value == 0) {
                      jeOtkazan = null;
                    } else if (value == 1) {
                      jeOtkazan = true;
                    } else {
                      jeOtkazan = false;
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Vrijednost može biti 'Otkazano' ili 'Neotkazano'"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400)),
              child: DropdownMenu(
                initialSelection: 0,
                enableFilter: false,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 0, label: "Svi"),
                  DropdownMenuEntry(value: 1, label: "Plaćeno"),
                  DropdownMenuEntry(value: 2, label: "Neplaćeno"),
                ],
                menuStyle: MenuStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(4),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300)))),
                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                onSelected: (value) {
                  if (value != null) {
                    if (value == 0) {
                      jePlacen = null;
                    } else if (value == 1) {
                      jePlacen = true;
                    } else {
                      jePlacen = false;
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Vrijednost može biti 'Plaćeno' ili 'Neplaćeno'"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400)),
              child: DropdownMenu(
                initialSelection: "",
                enableFilter: false,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: "", label: "Svi"),
                  DropdownMenuEntry(value: "created", label: "Kreirana"),
                  DropdownMenuEntry(value: "inprogress", label: "U procesu"),
                  DropdownMenuEntry(value: "finished", label: "Završena"),
                ],
                menuStyle: MenuStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(4),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300)))),
                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                onSelected: (value) {
                  if (value != null) {
                    created = value;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Vrijednost može biti 'Plaćeno' ili 'Neplaćeno'"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400)),
              child: DropdownMenu(
                initialSelection: 0,
                enableFilter: false,
                dropdownMenuEntries: korisnici.keys
                    .map((e) =>
                        DropdownMenuEntry(value: e, label: korisnici[e]!))
                    .toList(),
                menuStyle: MenuStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(4),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300)))),
                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                onSelected: (value) {
                  if (value != null) {
                    korisnik = int.tryParse(value.toString());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Odaberite validnu vrijednost"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400)),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  var filter = {
                    'BrojNarudzbeGTE': _brojNarudzbeEditingController.text,
                    'Otkazana': jeOtkazan,
                    'DatumFrom': datumOdString,
                    'DatumTo': datumDoString,
                    'Placeno': jePlacen,
                    'StateMachine': created,
                    'UkupnaCijenaFrom': _cijenaOdEditingController.text,
                    'UkupnaCijenaTo': _cijenaDoEditingController.text,
                    'KorisnikId': korisnik,
                    'isDeleted': false,
                    'IncludeTables': "Korisnik"
                  };
                  result = await _narudzbaProvider.get(filter: filter);
                  setState(() {});
                },
                child: const Text("Pretraga")),
            const SizedBox(
              width: 8,
            )
          ],
        ));
  }

  Widget _buildResultView() {
    return Expanded(
      child: Container(
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
                  "Broj nardužbe",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Otkazana",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Plaćeno",
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
                )),
                DataColumn(
                    label: Text(
                  "Kupac",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
              ],
                  rows: result?.result
                          .map((e) => DataRow(
                                  onSelectChanged: (selected) => {
                                        if (selected == true)
                                          {
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NarudzbeDetailsScreen(
                                                          narudzba: e,
                                                        )))
                                          }
                                      },
                                  cells: [
                                    DataCell(Text(e.brojNarudzbe,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        e.otkazana == true ? "Da" : "Ne",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        e.placeno == true ? "Da" : "Ne",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        formatDateString(
                                            e.datum.toIso8601String()),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.ukupnaCijena.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        "${e.korisnik?.ime} ${e.korisnik?.prezime}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                  ]))
                          .toList()
                          .cast<DataRow>() ??
                      []))),
    );
  }
}
