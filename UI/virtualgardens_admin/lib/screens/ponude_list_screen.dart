import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/ponuda.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/ponude_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/screens/ponude_details_screen.dart';

class PonudeListScreen extends StatefulWidget {
  const PonudeListScreen({super.key});

  @override
  State<PonudeListScreen> createState() => _PonudeListScreenState();
}

class _PonudeListScreenState extends State<PonudeListScreen> {
  late PonudeProvider _ponudeProvider;

  late PonudeDataSource dataSource;
  SearchResult<Ponuda>? result;
  Map<String, dynamic> stateMachineValues = {
    "all": "Svi",
    "created": "Kreirana",
    "active": "Aktivna",
    "finished": "Završena"
  };

  bool isLoading = true;
  String? stateMachineName;
  String? stateMachine;
  bool? jeObrisan;

  late RangeValues selectedRange;

  String datumOdString = "";
  String datumDoString = "";

  final TextEditingController _ftsEditingController = TextEditingController();

  final TextEditingController _popustEditingController =
      TextEditingController();
  final TextEditingController _datumOdEditingController =
      TextEditingController();
  final TextEditingController _datumDoEditingController =
      TextEditingController();

  @override
  void initState() {
    _ponudeProvider = context.read<PonudeProvider>();
    selectedRange = const RangeValues(0, 100);
    dataSource = PonudeDataSource(
      provider: _ponudeProvider,
      context: context,
    );
    initScreen();
    super.initState();
  }

  Future initScreen() async {
    var filter = {
      'isDeleted': jeObrisan,
    };

    result = await _ponudeProvider.get(filter: filter);

    _datumOdEditingController.text = "";
    _ftsEditingController.text = "";
    _datumDoEditingController.text = "";
    _popustEditingController.text = "";

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader2(
        isLoading: isLoading,
        isList: true,
        title: "Ponude",
        actions: <Widget>[Container()],
        child: Column(
          children: [
            _buildSearch(),
            _buildResultView(),
          ],
        ),
      ),
      "Ponude",
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
                LengthLimitingTextInputFormatter(50),
              ],
              decoration:
                  const InputDecoration(labelText: "Naziv", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    value,
                    datumOdString,
                    datumDoString,
                    selectedRange.start.toInt(),
                    selectedRange.end.toInt(),
                    stateMachine);
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
                      _ftsEditingController.text,
                      datumOdString,
                      datumDoString,
                      selectedRange.start.toInt(),
                      selectedRange.end.toInt(),
                      stateMachine);
                }
              },
            )),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _datumOdEditingController.clear();
                datumOdString = "";
                dataSource.filterServerSide(
                    _ftsEditingController.text,
                    datumOdString,
                    datumDoString,
                    selectedRange.start.toInt(),
                    selectedRange.end.toInt(),
                    stateMachine);
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
                      _ftsEditingController.text,
                      datumOdString,
                      datumDoString,
                      selectedRange.start.toInt(),
                      selectedRange.end.toInt(),
                      stateMachine);
                }
              },
            )),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _datumDoEditingController.clear();
                datumDoString = "";
                dataSource.filterServerSide(
                    _ftsEditingController.text,
                    datumOdString,
                    datumDoString,
                    selectedRange.start.toInt(),
                    selectedRange.end.toInt(),
                    stateMachine);
              },
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Popust:", style: TextStyle(color: Colors.white)),
            RangeSlider(
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              values: selectedRange,
              min: 0,
              max: 100,
              divisions: 100,
              labels: RangeLabels(selectedRange.start.round().toString(),
                  selectedRange.end.round().toString()),
              onChangeEnd: (values) {
                selectedRange = RangeValues(values.start.round().toDouble(),
                    values.end.round().toDouble());
                dataSource.filterServerSide(
                    _ftsEditingController.text,
                    datumOdString,
                    datumDoString,
                    selectedRange.start.toInt(),
                    selectedRange.end.toInt(),
                    stateMachine);
                setState(() {});
              },
              onChanged: (value) {
                selectedRange = value;
                setState(() {});
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    value: stateMachine ?? stateMachineValues.entries.first.key,
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                    ),
                    items: stateMachineValues.entries
                        .map((item) => DropdownMenuItem(
                              value: item.key,
                              child: Text(item.value ?? "",
                                  style: const TextStyle(color: Colors.black)),
                            ))
                        .toList(),
                    onChanged: (value) async {
                      if (value != null) {
                        stateMachine = value;
                        dataSource.filterServerSide(
                            _ftsEditingController.text,
                            datumOdString,
                            datumDoString,
                            selectedRange.start.toInt(),
                            selectedRange.end.toInt(),
                            stateMachine == "all" ? null : stateMachine);
                        setState(() {});
                      } else {}
                    },
                  ),
                )),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  bool? response = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PonudeDetailsScreen()));

                  if (response == true) {
                    dataSource.filterServerSide(
                        _ftsEditingController.text,
                        datumOdString,
                        datumDoString,
                        selectedRange.start.toInt(),
                        selectedRange.end.toInt(),
                        stateMachine);

                    setState(() {});
                  }
                },
                child: const Text("Dodaj")),
          ],
        ));
  }

  Widget _buildResultView() {
    return buildResultView(AdvancedPaginatedDataTable(
      showCheckboxColumn: false,
      rowsPerPage: 10,
      source: dataSource,
      columns: const [
        DataColumn(
            label: Text(
          "Naziv ponude",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Datum",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Status",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Popust",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Akcija",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ))
      ],
      addEmptyRows: false,
    ));
  }
}

class PonudeDataSource extends AdvancedDataTableSource<Ponuda> {
  List<Ponuda>? data = [];
  final PonudeProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String? _nazivGTE;
  String? _datumOd;
  String? _datumDo;
  int? _popustOd;
  int? _popustDo;
  String? _stateMachine;

  dynamic filter;
  BuildContext context;
  PonudeDataSource({required this.provider, required this.context});

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
                builder: (context) => PonudeDetailsScreen(
                      ponuda: item,
                    )));

            if (response == true) {
              filterServerSide(_nazivGTE, _datumOd, _datumDo, _popustOd,
                  _popustDo, _stateMachine);
            }
          }
        },
        cells: [
          DataCell(Text(item!.naziv,
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(formatDateString(item.datumKreiranja.toIso8601String()),
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(
              item.stateMachine == "created"
                  ? "Kreirana"
                  : item.stateMachine == "active"
                      ? "Aktivna"
                      : item.stateMachine == "finished"
                          ? "Završena"
                          : "Greška",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text("${item.popust} %",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(ElevatedButton(
            onPressed: () async {
              if (context.mounted) {
                await buildDeleteAlert(
                    context, item.naziv, item.naziv, provider, item.ponudaId);
                filterServerSide(_nazivGTE, _datumOd, _datumDo, _popustOd,
                    _popustDo, _stateMachine);
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
    popustOd,
    popustDo,
    stateMachine,
  ) {
    _nazivGTE = naziv;
    _datumOd = datumOd;
    _datumDo = datumDo;
    _popustOd = popustOd;
    _popustDo = popustDo;

    _stateMachine = stateMachine;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Ponuda>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'NazivContains': _nazivGTE,
      'PopustFrom': _popustOd,
      'PopustTo': _popustDo,
      'DatumFrom': _datumOd,
      'DatumTo': _datumDo,
      'isDeleted': false,
      'StateMachine': _stateMachine,
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
