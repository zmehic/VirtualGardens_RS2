import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi.dart';
import 'package:virtualgardens_admin/providers/ulazi_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/screens/ulazi_details_screen.dart';

class UlaziListScreen extends StatefulWidget {
  const UlaziListScreen({super.key});

  @override
  State<UlaziListScreen> createState() => _UlaziListScreenState();
}

class _UlaziListScreenState extends State<UlaziListScreen> {
  late UlaziProvider _ulaziProvider;

  SearchResult<Ulaz>? result;

  bool isLoading = true;

  String datumOdString = "";
  String datumDoString = "";

  final TextEditingController _ftsEditingController = TextEditingController();
  final TextEditingController _datumOdEditingController =
      TextEditingController();
  final TextEditingController _datumDoEditingController =
      TextEditingController();

  @override
  void initState() {
    _ulaziProvider = context.read<UlaziProvider>();
    super.initState();
    initScreen();
  }

  Future initScreen() async {
    var filter = {'isDeleted': false, 'IncludeTables': "Korisnik"};

    result = await _ulaziProvider.get(filter: filter);

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
      "Ulazi",
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
            Text("Ulazi",
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
            ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  var filter = {
                    'BrojUlazaGTE': _ftsEditingController.text,
                    'DatumUlazaFrom': datumOdString,
                    'DatumUlazaTo': datumDoString,
                    'isDeleted': false,
                    'IncludeTables': "Korisnik"
                  };
                  result = await _ulaziProvider.get(filter: filter);
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
                      builder: (context) => UlaziDetailsScreen()));
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
                  "Broj ulaza",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Datum",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Korisnik",
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
                                                            UlaziDetailsScreen(
                                                                ulaz: e)))
                                          }
                                      },
                                  cells: [
                                    DataCell(Text(e.brojUlaza,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        formatDateString(
                                            e.datumUlaza.toIso8601String()),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        "${e.korisnik.ime} ${e.korisnik.prezime}",
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
