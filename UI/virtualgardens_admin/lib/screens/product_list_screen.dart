import 'dart:async';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
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
  late ProductDataSource dataSource;
  int rowsPerPage = 8;

  SearchResult<Proizvod>? result;
  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;

  bool isLoading = true;
  int? selectedVrstaProizvoda;
  final TextEditingController ftsEditingController = TextEditingController();
  final TextEditingController cijenaOdEditingController =
      TextEditingController();
  final TextEditingController cijenaDoEditingController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    provider = context.read<ProductProvider>();
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    dataSource = ProductDataSource(
      provider: provider,
      context: context,
    );
    super.initState();

    selectedVrstaProizvoda = 0;
    initForm(selectedVrstaProizvoda);
  }

  Future initForm(int? vrstaProizvodaId) async {
    var filter = {'isDeleted': false};
    vrsteProizvodaResult = await vrsteProizvodaProvider.get(filter: filter);
    vrsteProizvodaResult?.result
        .insert(0, VrstaProizvoda(vrstaProizvodaId: 0, naziv: "Svi"));

    selectedVrstaProizvoda ??= vrsteProizvodaResult?.result[0].vrstaProizvodaId;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader2(
        isList: true,
        title: "Lista proizvoda",
        actions: <Widget>[Container()],
        isLoading: isLoading,
        child: Column(
          children: [
            _buildSearch(),
            _buildResultView(),
          ],
        ),
      ),
      "Lista proizvoda",
    );
  }

  Widget _buildSearch() {
    return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(12.0),
        color: const Color.fromRGBO(32, 76, 56, 1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: TextField(
              controller: ftsEditingController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: const InputDecoration(
                filled: true,
                labelText: "Naziv",
              ),
              onChanged: (value) {
                dataSource.filterServerSide(
                    value,
                    cijenaOdEditingController.text,
                    cijenaDoEditingController.text,
                    selectedVrstaProizvoda);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: cijenaOdEditingController,
              decoration:
                  const InputDecoration(labelText: "Cijena od:", filled: true),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                LengthLimitingTextInputFormatter(8),
              ],
              onChanged: (value) {
                dataSource.filterServerSide(ftsEditingController.text, value,
                    cijenaDoEditingController.text, selectedVrstaProizvoda);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: cijenaDoEditingController,
              decoration:
                  const InputDecoration(labelText: "Cijena do:", filled: true),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                LengthLimitingTextInputFormatter(8),
              ],
              onChanged: (value) {
                dataSource.filterServerSide(
                    ftsEditingController.text,
                    cijenaOdEditingController.text,
                    value,
                    selectedVrstaProizvoda);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(child: _buildDropdown()),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(const Size(150, 50))),
                onPressed: () async {
                  bool? response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              const ProductDetailsScreen())));
                  if (response == true) {
                    dataSource.filterServerSide(
                        ftsEditingController.text,
                        cijenaOdEditingController.text,
                        cijenaDoEditingController.text,
                        selectedVrstaProizvoda);
                  }
                },
                child: const Text("Dodaj")),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(150, 50))),
              onPressed: () async {
                bool result = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const UlaziListScreen())) ??
                    false;
                if (result == true) {
                  dataSource.filterServerSide(
                      ftsEditingController.text,
                      cijenaOdEditingController.text,
                      cijenaDoEditingController.text,
                      selectedVrstaProizvoda);
                }
              },
              child: const Text("Ulazi"),
            ),
          ],
        ));
  }

  Widget _buildResultView() {
    return buildResultView(AdvancedPaginatedDataTable(
      showCheckboxColumn: false,
      rowsPerPage: 10,
      columns: const [
        DataColumn(
            label: Text(
          "Naziv",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Cijena",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Količina",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Jed.",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Slika",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
          label: Text(
            "Akcija",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ],
      source: dataSource,
      addEmptyRows: false,
    ));
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: "$selectedVrstaProizvoda",
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(235, 241, 224, 1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        items: vrsteProizvodaResult?.result
                .map((item) => DropdownMenuItem(
                      value: item.vrstaProizvodaId.toString(),
                      child: Text(item.naziv ?? "",
                          style: const TextStyle(color: Colors.black)),
                    ))
                .toList() ??
            [],
        onChanged: (value) async {
          if (value != null) {
            selectedVrstaProizvoda = int.tryParse(value.toString());
            dataSource.filterServerSide(
                ftsEditingController.text,
                cijenaOdEditingController.text,
                cijenaDoEditingController.text,
                selectedVrstaProizvoda);

            setState(() {});
          }
        },
      ),
    );
  }
}

class ProductDataSource extends AdvancedDataTableSource<Proizvod> {
  List<Proizvod>? data = [];
  final ProductProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String _nazivGTE = "";
  String? _cijenaFrom;
  String? _cijenaTo;
  int _selectedVrstaProizvoda = 0;
  dynamic filter;
  BuildContext context;
  ProductDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data!.length) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        onSelectChanged: (selected) async {
          if (selected == true) {
            bool? response = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        ProductDetailsScreen(product: item))));
            if (response == true) {
              filterServerSide(
                  _nazivGTE, _cijenaFrom, _cijenaTo, _selectedVrstaProizvoda);
            }
          }
        },
        cells: [
          DataCell(Text(item!.naziv ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text("${formatNumber(item.cijena)} KM",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.dostupnaKolicina.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.jedinicaMjere!.skracenica!,
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(item.slika != null
              ? SizedBox(
                  width: 100,
                  height: 100,
                  child: imageFromString(item.slika!),
                )
              : const Text("")),
          DataCell(ElevatedButton(
            onPressed: () async {
              if (context.mounted) {
                await buildDeleteAlert(context, item.naziv ?? "",
                    item.naziv ?? "", provider, item.proizvodId!);
                filterServerSide(
                    _nazivGTE, _cijenaFrom, _cijenaTo, _selectedVrstaProizvoda);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.all(8),
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )),
        ]);
  }

  void filterServerSide(naziv, cijenaFrom, cijenaTo, selectedVrstaProizvoda) {
    _nazivGTE = naziv;
    _cijenaFrom = cijenaFrom;
    _cijenaTo = cijenaTo;
    _selectedVrstaProizvoda = selectedVrstaProizvoda;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Proizvod>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'NazivGTE': _nazivGTE,
      'CijenaFrom': _cijenaFrom,
      'CijenaTo': _cijenaTo,
      'IncludeTables': "JedinicaMjere",
      'VrstaProizvodaId':
          _selectedVrstaProizvoda == 0 ? null : _selectedVrstaProizvoda,
      'isDeleted': false,
      'Page': page,
      'PageSize': pageSize
    };

    try {
      var result = await provider.get(filter: filter);
      data = result.result;
      count = result.count;

      notifyListeners();
    } on Exception catch (e) {
      if (context.mounted) {
        await buildErrorAlert(context, "Greška", e.toString(), e);
      }
    }

    return RemoteDataSourceDetails(count, data!);
  }
}
