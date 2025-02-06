import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
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
      'isDeleted': jeOtkazan,
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
              "Narudžbe",
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
                Expanded(
                  child: Row(
                    children: [_buildResultView(), _buildSearchDropdowns()],
                  ),
                ),
              ],
            ),
          ),
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
            )),
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
                  datumDoString = pickedDate.toIso8601String();
                  _datumDoEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
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
            )),
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
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
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
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
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

  Widget _buildResultView() {
    return Expanded(
      child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(32, 76, 56, 1),
            border: Border.all(color: Colors.white, width: 3),
          ),
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          child: SingleChildScrollView(
              child: AdvancedPaginatedDataTable(
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
          ))),
    );
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
            bool response = await Navigator.push(
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
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: "Potvrda brisanja",
                  text: "Jeste li sigurni da želite obrisati narudžbu?",
                  confirmBtnText: "U redu",
                  onConfirmBtnTap: () async {
                    try {
                      await provider.delete(item.narudzbaId);
                      if (context.mounted) {
                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: "Uspješno ste obrisali narudžbu",
                          confirmBtnText: "U redu",
                          text: "Narudžba je obrisana",
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    } on Exception {
                      if (context.mounted) {
                        await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: "Greška!",
                            text:
                                "Moguće je obrisati samo narudžbe koje su u stanju 'kreirana'",
                            confirmBtnText: "U redu");
                      }
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
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
                  },
                );
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
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: e.toString().split(': ')[1]);
      }
    }

    return RemoteDataSourceDetails(count, data!);
  }
}
