import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/screens/narudzbe_details_screen.dart';

class NarduzbeListScreen extends StatefulWidget {
  const NarduzbeListScreen({super.key});

  @override
  State<NarduzbeListScreen> createState() => _NarudzbeListScreenState();
}

class _NarudzbeListScreenState extends State<NarduzbeListScreen> {
  late NarudzbeDataSource _dataSource;
  late NarudzbaProvider _narudzbaProvider;

  SearchResult<Narudzba>? result;
  late Map<int, String> korisnici = {};

  bool isLoading = true;

  bool? jeOtkazan;
  bool? jePlacen;
  String? created = "";
  int? korisnik;

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
    korisnici[0] = "Svi kupci";
    _narudzbaProvider = context.read<NarudzbaProvider>();
    initScreen();
    _dataSource =
        NarudzbeDataSource(provider: _narudzbaProvider, context: context);

    super.initState();
  }

  Future initScreen() async {
    var filter = {
      'isDeleted': false,
      'IncludeTables': "Korisnik",
      'Placeno': jePlacen
    };

    result = await _narudzbaProvider.get(filter: filter);

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
      FullScreenLoader2(
        isList: true,
        title: "Narudžbe",
        actions: <Widget>[Container()],
        isLoading: isLoading,
        child: Column(
          children: [
            _buildSearch(),
            Expanded(
              child: Row(
                children: [_buildResultView(), _buildSearchDropdowns()],
              ),
            ),
          ],
        ),
      ),
      "Narudzbe",
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
              controller: _brojNarudzbeEditingController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              decoration: const InputDecoration(
                  labelText: "Broj narudzbe", filled: true),
              onChanged: (value) {
                _dataSource.filterServerSide(
                    value,
                    jeOtkazan,
                    datumOdString,
                    datumDoString,
                    jePlacen,
                    created,
                    _cijenaOdEditingController.text,
                    _cijenaDoEditingController.text,
                    korisnik);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            _buildDatePicker(_datumOdEditingController, "Datum od:", true),
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
                _datumOdEditingController.clear();
                _datumDoEditingController.clear();
                datumDoString = "";
                datumOdString = "";
                _dataSource.filterServerSide(
                    _brojNarudzbeEditingController.text,
                    jeOtkazan,
                    datumOdString,
                    datumDoString,
                    jePlacen,
                    created,
                    _cijenaOdEditingController.text,
                    _cijenaDoEditingController.text,
                    korisnik);
              },
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _cijenaOdEditingController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                LengthLimitingTextInputFormatter(8),
              ],
              decoration:
                  const InputDecoration(labelText: "Cijena od", filled: true),
              onChanged: (value) {
                _dataSource.filterServerSide(
                    _brojNarudzbeEditingController.text,
                    jeOtkazan,
                    datumOdString,
                    datumDoString,
                    jePlacen,
                    created,
                    _cijenaOdEditingController.text,
                    _cijenaDoEditingController.text,
                    korisnik);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _cijenaDoEditingController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                LengthLimitingTextInputFormatter(8),
              ],
              decoration:
                  const InputDecoration(labelText: "Cijena do", filled: true),
              onChanged: (value) {
                _dataSource.filterServerSide(
                    _brojNarudzbeEditingController.text,
                    jeOtkazan,
                    datumOdString,
                    datumDoString,
                    jePlacen,
                    created,
                    _cijenaOdEditingController.text,
                    _cijenaDoEditingController.text,
                    korisnik);
              },
            )),
            const SizedBox(
              width: 8,
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
          _dataSource.filterServerSide(
              _brojNarudzbeEditingController.text,
              jeOtkazan,
              datumOdString,
              datumDoString,
              jePlacen,
              created,
              _cijenaOdEditingController.text,
              _cijenaDoEditingController.text,
              korisnik);
        }
      },
    ));
  }

  Widget _buildResultView() {
    return buildResultView(AdvancedPaginatedDataTable(
      source: _dataSource,
      addEmptyRows: false,
      rowsPerPage: 10,
      showCheckboxColumn: false,
      columns: const [
        DataColumn(
            label: Text(
          "Broj nardužbe",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Otkazana",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Plaćeno",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Datum",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Cijena",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Kupac",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Akcija",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
      ],
    ));
  }

  Widget _buildSearchDropdowns() {
    return Column(
      children: [
        Expanded(
          child: Row(children: [
            Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    value: jeOtkazan == null
                        ? 0.toString()
                        : jeOtkazan == true
                            ? 1.toString()
                            : 2.toString(),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 0.toString(),
                          child: const Text("Svi statusi",
                              style: TextStyle(color: Colors.black))),
                      DropdownMenuItem(
                          value: 1.toString(),
                          child: const Text("Otkazano",
                              style: TextStyle(color: Colors.black))),
                      DropdownMenuItem(
                          value: 2.toString(),
                          child: const Text("Neotkazano",
                              style: TextStyle(color: Colors.black))),
                    ],
                    onChanged: (value) async {
                      if (value != null) {
                        jeOtkazan = int.tryParse(value) == 0
                            ? null
                            : int.tryParse(value) == 1
                                ? true
                                : false;
                        _dataSource.filterServerSide(
                            _brojNarudzbeEditingController.text,
                            jeOtkazan,
                            datumOdString,
                            datumDoString,
                            jePlacen,
                            created,
                            _cijenaOdEditingController.text,
                            _cijenaDoEditingController.text,
                            korisnik);
                        setState(() {});
                      }
                    },
                  ),
                )),
          ]),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    value: jePlacen == null
                        ? 0.toString()
                        : jePlacen == true
                            ? 1.toString()
                            : 2.toString(),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 0.toString(),
                          child: const Text("Sva plaćanja",
                              style: TextStyle(color: Colors.black))),
                      DropdownMenuItem(
                          value: 1.toString(),
                          child: const Text("Plaćeno",
                              style: TextStyle(color: Colors.black))),
                      DropdownMenuItem(
                          value: 2.toString(),
                          child: const Text("Neplaćeno",
                              style: TextStyle(color: Colors.black))),
                    ],
                    onChanged: (value) async {
                      if (value != null) {
                        jePlacen = int.tryParse(value) == 0
                            ? null
                            : int.tryParse(value) == 1
                                ? true
                                : false;
                        _dataSource.filterServerSide(
                            _brojNarudzbeEditingController.text,
                            jeOtkazan,
                            datumOdString,
                            datumDoString,
                            jePlacen,
                            created,
                            _cijenaOdEditingController.text,
                            _cijenaDoEditingController.text,
                            korisnik);
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      value: created,
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "",
                            child: Text("Sve narudžbe",
                                style: TextStyle(color: Colors.black))),
                        DropdownMenuItem(
                            value: "created",
                            child: Text("Kreirana",
                                style: TextStyle(color: Colors.black))),
                        DropdownMenuItem(
                            value: "inprogress",
                            child: Text("U procesu",
                                style: TextStyle(color: Colors.black))),
                        DropdownMenuItem(
                            value: "finished",
                            child: Text("Završena",
                                style: TextStyle(color: Colors.black))),
                      ],
                      onChanged: (value) async {
                        if (value != null) {
                          created = value;
                          _dataSource.filterServerSide(
                              _brojNarudzbeEditingController.text,
                              jeOtkazan,
                              datumOdString,
                              datumDoString,
                              jePlacen,
                              created,
                              _cijenaOdEditingController.text,
                              _cijenaDoEditingController.text,
                              korisnik);
                          setState(() {});
                        }
                      },
                    ),
                  )),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      value: korisnik != null
                          ? korisnik.toString()
                          : korisnici.entries.first.key.toString(),
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                      items: korisnici.entries
                          .map((item) => DropdownMenuItem(
                                value: item.key.toString(),
                                child: Text(item.value,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ))
                          .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          korisnik = int.tryParse(value) == 0
                              ? null
                              : int.tryParse(value.toString());
                          _dataSource.filterServerSide(
                              _brojNarudzbeEditingController.text,
                              jeOtkazan,
                              datumOdString,
                              datumDoString,
                              jePlacen,
                              created,
                              _cijenaOdEditingController.text,
                              _cijenaDoEditingController.text,
                              korisnik);
                          setState(() {});
                        }
                      },
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class NarudzbeDataSource extends AdvancedDataTableSource<Narudzba> {
  List<Narudzba>? data = [];
  final NarudzbaProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String? _brojGTE;
  bool? _jeOtkazana;
  String? _datumOd;
  String? _datumDo;
  bool? _jePlacena;
  String? _stateMachine;
  String? _cijenaFrom;
  String? _cijenaTo;
  int? _korisnikId;
  dynamic filter;
  BuildContext context;
  NarudzbeDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data!.length) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        onSelectChanged: (selected) async {
          if (selected == true) {
            var response = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        NarudzbeDetailsScreen(narudzba: item))));
            if (response == true) {
              filterServerSide(
                  _brojGTE,
                  _jeOtkazana,
                  _datumOd,
                  _datumDo,
                  _jePlacena,
                  _stateMachine,
                  _cijenaFrom,
                  _cijenaTo,
                  _korisnikId);
            }
          }
        },
        cells: [
          DataCell(Text(item!.brojNarudzbe,
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(
              item.otkazana == true
                  ? "Da"
                  : item.otkazana == false
                      ? "Ne"
                      : "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(
              item.placeno == true
                  ? "Da"
                  : item.placeno == false
                      ? "Ne"
                      : "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(formatDateString(item.datum.toIso8601String()),
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.ukupnaCijena.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.korisnik!.korisnickoIme,
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(ElevatedButton(
            onPressed: () async {
              if (context.mounted) {
                await buildDeleteAlert(context, item.brojNarudzbe,
                    item.brojNarudzbe, provider, item.narudzbaId);
              }

              filterServerSide(
                  _brojGTE,
                  _jeOtkazana,
                  _datumOd,
                  _datumDo,
                  _jePlacena,
                  _stateMachine,
                  _cijenaFrom,
                  _cijenaTo,
                  _korisnikId);
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

  void filterServerSide(brojGTE, jeOtkazan, datumOd, datumDo, jePlacen,
      stateMachine, cijenaOd, cijenaDo, korisnikId) {
    _brojGTE = brojGTE;
    _jeOtkazana = jeOtkazan;
    _datumOd = datumOd;
    _datumDo = datumDo;
    _jePlacena = jePlacen;
    _stateMachine = stateMachine;
    _cijenaFrom = cijenaOd;
    _cijenaTo = cijenaDo;
    _korisnikId = korisnikId;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Narudzba>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'BrojNarudzbeGTE': _brojGTE,
      'Otkazana': _jeOtkazana,
      'DatumFrom': _datumOd,
      'DatumTo': _datumDo,
      'Placeno': _jePlacena,
      'StateMachine': _stateMachine,
      'UkupnaCijenaFrom': _cijenaFrom,
      'UkupnaCijenaTo': _cijenaTo,
      'KorisnikId': _korisnikId,
      'isDeleted': false,
      'IncludeTables': "Korisnik",
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
