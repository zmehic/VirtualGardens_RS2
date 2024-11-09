import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_admin/screens/product_details_screen.dart';
import 'package:virtualgardens_admin/screens/ulazi_list_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider provider;
  late VrsteProizvodaProvider vrsteProizvodaProvider;

  SearchResult<Proizvod>? result;
  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;

  bool isLoading = true;
  int? selectedVrstaProizvoda;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<ProductProvider>();
  }

  @override
  void initState() {
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    super.initState();
    selectedVrstaProizvoda = 0;
    initScreen(selectedVrstaProizvoda);
  }

  Future initScreen(int? vrstaProizvodaId) async {
    var filter = {
      'VrstaProizvodaId': vrstaProizvodaId == 0 ? "" : vrstaProizvodaId,
      'IncludeTables': "JedinicaMjere",
      'isDeleted': false
    };
    vrsteProizvodaResult = await vrsteProizvodaProvider.get();
    vrsteProizvodaResult?.result
        .insert(0, VrstaProizvoda(vrstaProizvodaId: 0, naziv: "Svi"));

    if (vrstaProizvodaId != 0) {
      result = await provider.get(filter: filter);
    } else {
      result = await provider.get(filter: filter);
    }
    selectedVrstaProizvoda ??= vrsteProizvodaResult?.result[0].vrstaProizvodaId;
    _cijenaDoEditingController.text = "";
    _ftsEditingController.text = "";
    _cijenaOdEditingController.text = "";
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
      "Lista proizvoda",
    );
  }

  final TextEditingController _ftsEditingController = TextEditingController();
  final TextEditingController _cijenaOdEditingController =
      TextEditingController();
  final TextEditingController _cijenaDoEditingController =
      TextEditingController();

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
              controller: _cijenaOdEditingController,
              decoration: const InputDecoration(labelText: "Cijena od:"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _cijenaDoEditingController,
              decoration: const InputDecoration(labelText: "Cijena do:"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            )),
            ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  var filter = {
                    'NazivGTE': _ftsEditingController.text,
                    'CijenaFrom': _cijenaOdEditingController.text,
                    'CijenaTo': _cijenaDoEditingController.text,
                    'VrstaProizvodaId': selectedVrstaProizvoda == 0
                        ? ""
                        : selectedVrstaProizvoda,
                    'IncludeTables': "JedinicaMjere",
                    'isDeleted': false
                  };
                  result = await provider.get(filter: filter);
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
                      builder: (context) => ProductDetailsScreen()));
                },
                child: const Text("Dodaj")),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const UlaziListScreen()));
              },
              child: const Text("Ulazi"),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                isLoading = true;
                setState(() {});
                await provider.recalculatequantiy();
                initScreen(selectedVrstaProizvoda);
                setState(() {});
              },
              child: const Icon(
                Icons.calculate,
                color: Colors.green,
              ),
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
                      "ID",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    numeric: true),
                DataColumn(
                    label: Text(
                  "Naziv",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Cijena",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Količina",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Jed.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
                DataColumn(
                    label: Text(
                  "Slika",
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
                                                            ProductDetailsScreen(
                                                                product: e)))
                                          }
                                      },
                                  cells: [
                                    DataCell(Text(e.proizvodId.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.naziv ?? "",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(
                                        "${formatNumber(e.cijena)} KM",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.dostupnaKolicina.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(Text(e.jedinicaMjere!.skracenica!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                                    DataCell(e.slika != null
                                        ? SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: imageFromString(e.slika!),
                                          )
                                        : const Text(""))
                                  ]))
                          .toList()
                          .cast<DataRow>() ??
                      []))),
    );
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
            const Icon(
                size: 45, color: Colors.white, Icons.store_mall_directory),
            const SizedBox(
              width: 10,
            ),
            const Text("Skladište",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arial",
                    color: Colors.white)),
            const SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400)),
              child: DropdownMenu(
                initialSelection: selectedVrstaProizvoda.toString(),
                dropdownMenuEntries: vrsteProizvodaResult?.result
                        .map((item) => DropdownMenuEntry(
                            value: item.vrstaProizvodaId.toString(),
                            label: item.naziv ?? ""))
                        .toList() ??
                    [],
                menuStyle: MenuStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(4),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300)))),
                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                onSelected: (value) {
                  if (value != null) {
                    selectedVrstaProizvoda = int.tryParse(value.toString());
                    isLoading = true;
                    setState(() {});
                    initScreen(selectedVrstaProizvoda);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Molimo odaberite neku od ponuđenih vrijednosti!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
