import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/zaposlenici.dart';
import 'package:virtualgardens_admin/providers/zaposlenici_provider.dart';
import 'package:virtualgardens_admin/screens/home_screen.dart';
import 'package:virtualgardens_admin/screens/ulazi_details_screen.dart';
import 'package:virtualgardens_admin/screens/zaposlenici_details_screen.dart';

class ZaposleniciListScreen extends StatefulWidget {
  const ZaposleniciListScreen({super.key});

  @override
  State<ZaposleniciListScreen> createState() => _ZaposleniciListScreenState();
}

class _ZaposleniciListScreenState extends State<ZaposleniciListScreen> {
  late ZaposlenikProvider _zaposlenikProvider;

  SearchResult<Zaposlenik>? result;

  bool isLoading = true;

  bool jeAktivan = true;

  final TextEditingController _imeEditingController = TextEditingController();
  final TextEditingController _prezimeEditingController =
      TextEditingController();
  final TextEditingController _brojTelefonaEditingController =
      TextEditingController();
  final TextEditingController _adresaEditingController =
      TextEditingController();
  final TextEditingController _gradEditingController = TextEditingController();
  final TextEditingController _drzavaEditingController =
      TextEditingController();

  @override
  void initState() {
    _zaposlenikProvider = context.read<ZaposlenikProvider>();
    super.initState();
    initScreen();
  }

  Future initScreen() async {
    var filter = {'isDeleted': false, 'JeAktivan': jeAktivan};

    result = await _zaposlenikProvider.get(filter: filter);

    _imeEditingController.text = "";
    _prezimeEditingController.text = "";
    _brojTelefonaEditingController.text = "";
    _adresaEditingController.text = "";
    _gradEditingController.text = "";
    _drzavaEditingController.text = "";

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
            Icon(size: 45, color: Colors.white, Icons.work),
            SizedBox(
              width: 10,
            ),
            Text("Zaposlenici",
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
              controller: _imeEditingController,
              decoration: const InputDecoration(labelText: "Ime"),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _prezimeEditingController,
              decoration: const InputDecoration(labelText: "Prezime"),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _brojTelefonaEditingController,
              decoration: const InputDecoration(labelText: "Broj telefona"),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _adresaEditingController,
              decoration: const InputDecoration(labelText: "Adresa"),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _gradEditingController,
              decoration: const InputDecoration(labelText: "Grad"),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _drzavaEditingController,
              decoration: const InputDecoration(labelText: "Država"),
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
                initialSelection: true,
                enableFilter: false,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: true, label: "Aktivan"),
                  DropdownMenuEntry(value: false, label: "Neaktivan"),
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
                    jeAktivan = value;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Vrijednost može biti 'Aktivan' ili 'Neaktivan'"),
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
            ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  var filter = {
                    'ImeGTE': _imeEditingController.text,
                    'PrezimeGTE': _prezimeEditingController.text,
                    'BrojTelefona': _brojTelefonaEditingController.text,
                    'AdresaGTE': _adresaEditingController.text,
                    'GradGTE': _gradEditingController.text,
                    'DrzavaGTE': _drzavaEditingController.text,
                    'isDeleted': false,
                    'JeAktivan': jeAktivan
                  };
                  result = await _zaposlenikProvider.get(filter: filter);
                  setState(() {});
                },
                child: const Text("Pretraga")),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ZaposleniciDetailsScreen()));
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
                  "Ime",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Prezime",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Broj telefona",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Adresa",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Grad",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Država",
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
                                                        ZaposleniciDetailsScreen(
                                                          zaposlenik: e,
                                                        )))
                                          }
                                      },
                                  cells: [
                                    DataCell(Text(e.ime,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.prezime,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.brojTelefona ?? "",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.adresa ?? "",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.grad ?? "",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.drzava ?? "",
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
