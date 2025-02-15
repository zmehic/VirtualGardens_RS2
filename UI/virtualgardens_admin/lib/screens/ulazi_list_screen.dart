import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi.dart';
import 'package:virtualgardens_admin/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/ulazi_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/screens/ulazi_details_screen.dart';

class UlaziListScreen extends StatefulWidget {
  const UlaziListScreen({super.key});

  @override
  State<UlaziListScreen> createState() => _UlaziListScreenState();
}

class _UlaziListScreenState extends State<UlaziListScreen> {
  late UlazDataSource dataSource;
  int rowsPerPage = 8;
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
    dataSource = UlazDataSource(
      provider: _ulaziProvider,
      context: context,
    );
    super.initState();
    initForm();
  }

  Future initForm() async {
    _datumOdEditingController.text = "";
    _ftsEditingController.text = "";
    _datumDoEditingController.text = "";
    dataSource.filterServerSide(
        _ftsEditingController.text, datumOdString, datumDoString);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader2(
        isList: false,
        title: "Ulazi",
        actions: <Widget>[Container()],
        isLoading: isLoading,
        child: Column(
          children: [
            _buildSearch(),
            _buildResultView(),
          ],
        ),
      ),
      "Ulazi",
    );
  }

  Widget _buildSearch() {
    return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(12.0),
        color: const Color.fromRGBO(32, 76, 56, 1),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _ftsEditingController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              decoration:
                  const InputDecoration(labelText: "Broj ulaza", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    value, datumOdString, datumDoString);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _datumOdEditingController,
              decoration:
                  const InputDecoration(labelText: "Datum od:", filled: true),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now());
                if (pickedDate != null) {
                  datumOdString = pickedDate.toIso8601String();
                  _datumOdEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                  dataSource.filterServerSide(
                      _ftsEditingController.text, datumOdString, datumDoString);
                }
              },
            )),
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                _datumOdEditingController.clear();
                datumOdString = "";
                dataSource.filterServerSide(
                    _ftsEditingController.text, datumOdString, datumDoString);
              },
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _datumDoEditingController,
              decoration:
                  const InputDecoration(labelText: "Datum do:", filled: true),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now());
                if (pickedDate != null) {
                  pickedDate = DateTime(pickedDate.year, pickedDate.month,
                      pickedDate.day, 23, 59, 59);
                  datumDoString = pickedDate.toIso8601String();
                  _datumDoEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                  dataSource.filterServerSide(
                      _ftsEditingController.text, datumOdString, datumDoString);
                }
              },
            )),
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                _datumDoEditingController.clear();
                datumDoString = "";
                dataSource.filterServerSide(
                    _ftsEditingController.text, datumOdString, datumDoString);
              },
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  var request = {
                    'korisnikId': AuthProvider.korisnikId,
                  };
                  try {
                    var response = await _ulaziProvider.insert(request);
                    if (mounted) {
                      await buildSuccessAlert(
                          context,
                          "Uspješno ste dodali ulaz",
                          "Ulaz ${response.brojUlaza} je dodan",
                          isDoublePop: false);
                    }
                  } on Exception catch (e) {
                    if (mounted) {
                      await buildErrorAlert(context, "Greška", e.toString(), e);
                    }
                  }
                  dataSource.filterServerSide(
                      _ftsEditingController.text, datumOdString, datumDoString);
                  setState(() {});
                },
                child: const Text("Dodaj")),
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
          "Broj ulaza",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Datum",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Korisnik",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Akcija",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ))
      ],
      source: dataSource,
      addEmptyRows: false,
    ));
  }
}

class UlazDataSource extends AdvancedDataTableSource<Ulaz> {
  List<Ulaz>? data = [];
  final UlaziProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String _nazivGTE = "";
  String? _datumOd;
  String? _datumDo;
  dynamic filter;
  BuildContext context;
  UlazDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data!.length) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        onSelectChanged: (selected) async {
          if (selected == true) {
            bool? response = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UlaziDetailsScreen(ulaz: item)));
            if (response == true) {
              filterServerSide(_nazivGTE, _datumOd, _datumDo);
            }
          }
        },
        cells: [
          DataCell(Text(item!.brojUlaza,
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(formatDateString(item.datumUlaza.toIso8601String()),
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text("${item.korisnik.ime} ${item.korisnik.prezime}",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(ElevatedButton(
            onPressed: () async {
              if (context.mounted) {
                await buildDeleteAlert(context, item.brojUlaza, item.brojUlaza,
                    provider, item.ulazId);
                filterServerSide(_nazivGTE, _datumOd, _datumDo);
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

  void filterServerSide(naziv, datumOd, datumDo) {
    _nazivGTE = naziv;
    _datumOd = datumOd;
    _datumDo = datumDo;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Ulaz>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'BrojUlazaGTE': _nazivGTE,
      'DatumUlazaFrom': _datumOd,
      'DatumUlazaTo': _datumDo,
      'IncludeTables': "Korisnik",
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
