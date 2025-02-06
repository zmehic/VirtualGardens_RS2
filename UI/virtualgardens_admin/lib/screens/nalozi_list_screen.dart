import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/nalozi.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/nalozi_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/screens/nalozi_details_screen.dart';

class NaloziListScreen extends StatefulWidget {
  const NaloziListScreen({super.key});

  @override
  State<NaloziListScreen> createState() => _NaloziListScreenState();
}

class _NaloziListScreenState extends State<NaloziListScreen> {
  late NaloziProvider _naloziProvider;
  late NaloziDataSource dataSource;
  SearchResult<Nalog>? result;

  Map<int, String> stanjeNaloga = {0: "Svi", 1: "Završen", 2: "Aktivan"};
  int? selectedStanje;

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
    dataSource = NaloziDataSource(
      provider: _naloziProvider,
      context: context,
    );
    initScreen();
    super.initState();
  }

  Future initScreen() async {
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
        isLoading: isLoading,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[Container()],
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: const Text(
              "Nalozi",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          ),
          backgroundColor: const Color.fromRGBO(103, 122, 105, 1),
          body: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            color: const Color.fromRGBO(235, 241, 224, 1),
            child: Column(
              children: [
                _buildSearch(),
                _buildResultView(),
              ],
            ),
          ),
        ),
      ),
      "Nalozi",
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
              decoration:
                  const InputDecoration(labelText: "Naziv", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    value, datumOdString, datumDoString, selectedStanje);
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
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  datumOdString = pickedDate.toIso8601String();
                  _datumOdEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                  dataSource.filterServerSide(_ftsEditingController.text,
                      datumOdString, datumDoString, selectedStanje);
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
                dataSource.filterServerSide(_ftsEditingController.text,
                    datumOdString, datumDoString, selectedStanje);
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
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  pickedDate = DateTime(pickedDate.year, pickedDate.month,
                      pickedDate.day, 23, 59, 59);
                  datumDoString = pickedDate.toIso8601String();
                  _datumDoEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                  dataSource.filterServerSide(_ftsEditingController.text,
                      datumOdString, datumDoString, selectedStanje);
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
                dataSource.filterServerSide(_ftsEditingController.text,
                    datumOdString, datumDoString, selectedStanje);
              },
            ),
            const SizedBox(
              width: 8,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                value: selectedStanje != null
                    ? selectedStanje.toString()
                    : stanjeNaloga.entries.first.key.toString(),
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                ),
                items: stanjeNaloga.entries
                    .map((item) => DropdownMenuItem(
                          value: item.key.toString(),
                          child: Text(item.value,
                              style: const TextStyle(color: Colors.black)),
                        ))
                    .toList(),
                onChanged: (value) async {
                  if (value != null) {
                    selectedStanje = int.tryParse(value.toString())!;
                    setState(() {});
                    dataSource.filterServerSide(_ftsEditingController.text,
                        datumOdString, datumDoString, selectedStanje);
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  bool response = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => NaloziDetailsScreen()));

                  if (response) {
                    dataSource.filterServerSide(_ftsEditingController.text,
                        datumOdString, datumDoString, selectedStanje);
                    setState(() {});
                  }
                },
                child: const Text("Dodaj")),
          ],
        ));
  }

  Widget _buildResultView() {
    return Expanded(
      child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(32, 76, 56, 1),
          ),
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          child: SingleChildScrollView(
              child: AdvancedPaginatedDataTable(
            showCheckboxColumn: false,
            rowsPerPage: 10,
            source: dataSource,
            addEmptyRows: false,
            columns: const [
              DataColumn(
                  label: Text(
                "Broj naloga",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Datum",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Zaposlenik",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                label: Text(
                  "Akcija",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ))),
    );
  }
}

class NaloziDataSource extends AdvancedDataTableSource<Nalog> {
  List<Nalog>? data = [];
  final NaloziProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String? _nazivGTE;
  String? _datumOd;
  String? _datumDo;
  bool? _state;

  dynamic filter;
  BuildContext context;
  NaloziDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data!.length) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        onSelectChanged: (selected) async {
          if (selected == true) {
            bool response = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NaloziDetailsScreen(
                      nalog: item,
                    )));

            if (response == true) {
              filterServerSide(_nazivGTE, _datumOd, _datumDo, _state);
            }
          }
        },
        cells: [
          DataCell(Text(item!.brojNaloga,
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(formatDateString(item.datumKreiranja.toIso8601String()),
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text("${item.zaposlenik?.ime} ${item.zaposlenik?.prezime}",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(ElevatedButton(
            onPressed: () async {
              if (context.mounted) {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    title: "Potvrda brisanja",
                    text: "Jeste li sigurni da želite obrisati nalog?",
                    confirmBtnText: "U redu",
                    onConfirmBtnTap: () async {
                      try {
                        await provider.delete(item.nalogId);
                        if (context.mounted) {
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            title: "Uspješno ste obrisali nalog",
                            confirmBtnText: "U redu",
                            text: "Nalog je obrisan",
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }

                        filterServerSide(_nazivGTE, _datumOd, _datumDo, _state);
                      } on Exception catch (e) {
                        if (context.mounted) {
                          await QuickAlert.show(
                              title: "Greška",
                              confirmBtnText: "U redu",
                              context: context,
                              type: QuickAlertType.error,
                              text: e.toString().split(': ')[1],
                              onConfirmBtnTap: Navigator.of(context).pop);
                        }
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    });
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

  void filterServerSide(
    naziv,
    datumOd,
    datumDo,
    state,
  ) {
    _nazivGTE = naziv;
    _datumOd = datumOd;
    _datumDo = datumDo;
    _state = state == 0 || state == null
        ? null
        : state == 1
            ? true
            : false;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Nalog>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'BrojNalogaGTE': _nazivGTE,
      'DatumKreiranjaFrom': _datumOd,
      'DatumKreiranjaTo': _datumDo,
      'isDeleted': false,
      'IncludeTables': "Zaposlenik,Narudzbes",
      'Zavrsen': _state,
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
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: e.toString().split(': ')[1]);
      }
    }

    return RemoteDataSourceDetails(count, data!);
  }
}
