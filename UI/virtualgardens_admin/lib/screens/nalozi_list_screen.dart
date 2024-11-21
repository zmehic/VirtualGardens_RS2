import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/nalozi.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/nalozi_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/screens/home_screen.dart';
import 'package:virtualgardens_admin/screens/nalozi_details_screen.dart';
import 'package:virtualgardens_admin/screens/narudzbe_list_screen.dart';
import 'package:virtualgardens_admin/screens/ulazi_details_screen.dart';

class NaloziListScreen extends StatefulWidget {
  const NaloziListScreen({super.key});

  @override
  State<NaloziListScreen> createState() => _NaloziListScreenState();
}

class _NaloziListScreenState extends State<NaloziListScreen> {
  late NaloziProvider _naloziProvider;

  SearchResult<Nalog>? result;

  bool isLoading = true;
  bool? jeZavrsen;
  bool? jeObrisan;

  String datumOdString = "";
  String datumDoString = "";

  final TextEditingController _ftsEditingController = TextEditingController();
  final TextEditingController _datumOdEditingController =
      TextEditingController();
  final TextEditingController _datumDoEditingController =
      TextEditingController();

  @override
  void initState() {
    _naloziProvider = context.read<NaloziProvider>();
    super.initState();
    initScreen();
  }

  Future initScreen() async {
    var filter = {
      'isDeleted': jeObrisan,
      'IncludeTables': "Zaposlenik,Narudzbes"
    };

    result = await _naloziProvider.get(filter: filter);

    _datumOdEditingController.text = "";
    _ftsEditingController.text = "";
    _datumDoEditingController.text = "";

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
      "Nalozi",
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
            Icon(size: 45, color: Colors.white, Icons.edit_note_rounded),
            SizedBox(
              width: 10,
            ),
            Text("Nalozi",
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
              controller: _ftsEditingController,
              decoration: const InputDecoration(labelText: "Naziv"),
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
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _datumOdEditingController.clear();
                datumOdString = "";
              },
            ),
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
                  pickedDate = DateTime(pickedDate.year, pickedDate.month,
                      pickedDate.day, 23, 59, 59);
                  datumDoString = pickedDate.toIso8601String();
                  _datumDoEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                }
              },
            )),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _datumDoEditingController.clear();
                datumDoString = "";
              },
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
                initialSelection: jeZavrsen == true
                    ? 1
                    : jeZavrsen == false
                        ? 2
                        : 0,
                enableFilter: false,
                label: const Text("Završen"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 0, label: "Svi"),
                  DropdownMenuEntry(value: 1, label: "Da"),
                  DropdownMenuEntry(value: 2, label: "Ne"),
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
                      jeZavrsen = null;
                    } else if (value == 1) {
                      jeZavrsen = true;
                    } else {
                      jeZavrsen = false;
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Odaberite neku od ponuđenih"),
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
                label: const Text("Obrisan"),
                initialSelection: jeObrisan == true
                    ? 1
                    : jeObrisan == false
                        ? 2
                        : 0,
                enableFilter: false,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 0, label: "Svi"),
                  DropdownMenuEntry(value: 1, label: "Da"),
                  DropdownMenuEntry(value: 2, label: "Ne"),
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
                      jeObrisan = null;
                    } else if (value == 1) {
                      jeObrisan = true;
                    } else {
                      jeObrisan = false;
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Odaberite neku od ponuđenih vrijednosti"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  var filter = {
                    'BrojNalogaGTE': _ftsEditingController.text,
                    'DatumKreiranjaFrom': datumOdString,
                    'DatumKreiranjaTo': datumDoString,
                    'isDeleted': jeObrisan,
                    'IncludeTables': "Zaposlenik,Narudzbes",
                    'Zavrsen': jeZavrsen,
                  };
                  result = await _naloziProvider.get(filter: filter);
                  isLoading = false;
                  setState(() {});
                },
                child: const Text("Pretraga")),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => NaloziDetailsScreen()));
                },
                child: const Text("Dodaj")),
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
                  "Broj naloga",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Datum",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Zaposlenik",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
              ],
                  rows: result?.result
                          .map((e) => DataRow(
                                  onSelectChanged: (selected) => {
                                        if (selected == true)
                                          {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NaloziDetailsScreen(
                                                              nalog: e,
                                                            )))
                                          }
                                      },
                                  cells: [
                                    DataCell(Text(e.brojNaloga,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        formatDateString(
                                            e.datumKreiranja.toIso8601String()),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        "${e.zaposlenik?.ime} ${e.zaposlenik?.prezime}",
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
