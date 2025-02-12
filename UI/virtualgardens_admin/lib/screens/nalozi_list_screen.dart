import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
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
      FullScreenLoader2(
        isList: true,
        title: "Nalozi",
        actions: <Widget>[Container()],
        isLoading: isLoading,
        child: Column(
          children: [
            _buildSearch(),
            _buildResultView(),
          ],
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
                  const InputDecoration(labelText: "Broj naloga", filled: true),
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              onChanged: (value) {
                dataSource.filterServerSide(
                    value, datumOdString, datumDoString, selectedStanje);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            _buildDatePicker(_datumOdEditingController, "Datum od:", true),
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
            _buildDatePicker(_datumDoEditingController, "Datum do:", false),
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
            _buildDropdown(),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  bool? response = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const NaloziDetailsScreen()));

                  if (response == true) {
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
    return buildResultView(AdvancedPaginatedDataTable(
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
    ));
  }

  Widget _buildDatePicker(
      TextEditingController controller, String s, bool isOd) {
    return Expanded(
        child: TextField(
      controller: controller,
      decoration: InputDecoration(labelText: s, filled: true),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime.now());
        if (pickedDate != null) {
          isOd == true
              ? datumOdString = pickedDate.toIso8601String()
              : datumDoString = pickedDate.toIso8601String();
          controller.text = formatDateString(pickedDate.toIso8601String());
          dataSource.filterServerSide(_ftsEditingController.text, datumOdString,
              datumDoString, selectedStanje);
        }
      },
    ));
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
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
            bool? response = await Navigator.of(context).push(MaterialPageRoute(
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
                await buildDeleteAlert(context, item.brojNaloga,
                    item.brojNaloga, provider, item.nalogId);
                filterServerSide(_nazivGTE, _datumOd, _datumDo, _state);
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
        await buildErrorAlert(context, "Greška", e.toString(), e);
      }
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
