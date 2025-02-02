import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/zaposlenici.dart';
import 'package:virtualgardens_admin/providers/zaposlenici_provider.dart';
import 'package:virtualgardens_admin/screens/zaposlenici_details_screen.dart';

class ZaposleniciListScreen extends StatefulWidget {
  const ZaposleniciListScreen({super.key});

  @override
  State<ZaposleniciListScreen> createState() => _ZaposleniciListScreenState();
}

class _ZaposleniciListScreenState extends State<ZaposleniciListScreen> {
  late ZaposleniciDataSource dataSource;
  late ZaposlenikProvider _zaposlenikProvider;

  SearchResult<Zaposlenik>? result;

  bool isLoading = true;

  bool? jeAktivan;

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
    dataSource = ZaposleniciDataSource(
      provider: _zaposlenikProvider,
      context: context,
    );
    super.initState();
    initScreen();
  }

  Future initScreen() async {
    var filter = {'isDeleted': false};

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
              "Zaposlenici",
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
      "Zaposlenici",
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
              controller: _imeEditingController,
              decoration: const InputDecoration(labelText: "Ime", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    value,
                    _prezimeEditingController.text,
                    _brojTelefonaEditingController.text,
                    _adresaEditingController.text,
                    _gradEditingController.text,
                    _drzavaEditingController.text);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _prezimeEditingController,
              decoration:
                  const InputDecoration(labelText: "Prezime", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    _imeEditingController.text,
                    value,
                    _brojTelefonaEditingController.text,
                    _adresaEditingController.text,
                    _gradEditingController.text,
                    _drzavaEditingController.text);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _brojTelefonaEditingController,
              decoration: const InputDecoration(
                  labelText: "Broj telefona", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    _imeEditingController.text,
                    _prezimeEditingController.text,
                    value,
                    _adresaEditingController.text,
                    _gradEditingController.text,
                    _drzavaEditingController.text);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _adresaEditingController,
              decoration:
                  const InputDecoration(labelText: "Adresa", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    _imeEditingController.text,
                    _prezimeEditingController.text,
                    _brojTelefonaEditingController.text,
                    value,
                    _gradEditingController.text,
                    _drzavaEditingController.text);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _gradEditingController,
              decoration:
                  const InputDecoration(labelText: "Grad", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    _imeEditingController.text,
                    _prezimeEditingController.text,
                    _brojTelefonaEditingController.text,
                    _adresaEditingController.text,
                    value,
                    _drzavaEditingController.text);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _drzavaEditingController,
              decoration:
                  const InputDecoration(labelText: "Država", filled: true),
              onChanged: (value) {
                dataSource.filterServerSide(
                    _imeEditingController.text,
                    _prezimeEditingController.text,
                    _brojTelefonaEditingController.text,
                    _adresaEditingController.text,
                    _gradEditingController.text,
                    value);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  bool response = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              const ZaposleniciDetailsScreen()));
                  if (response == true) {
                    dataSource.filterServerSide(
                        _imeEditingController.text,
                        _prezimeEditingController.text,
                        _brojTelefonaEditingController.text,
                        _adresaEditingController.text,
                        _gradEditingController.text,
                        _drzavaEditingController.text);
                  }
                },
                child: const Text("Dodaj")),
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
          child: SingleChildScrollView(
              child: AdvancedPaginatedDataTable(
            source: dataSource,
            showCheckboxColumn: false,
            rowsPerPage: 10,
            columns: const [
              DataColumn(
                  label: Text(
                "Ime",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Prezime",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Broj telefona",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Adresa",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Grad",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Država",
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

class ZaposleniciDataSource extends AdvancedDataTableSource<Zaposlenik> {
  List<Zaposlenik>? data = [];
  final ZaposlenikProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String? _ime;
  String? _prezime;
  String? _telefon;
  String? _adresa;
  String? _grad;
  String? _drzava;
  dynamic filter;
  BuildContext context;
  ZaposleniciDataSource({required this.provider, required this.context});

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
                        ZaposleniciDetailsScreen(zaposlenik: item))));
            if (response == true) {
              filterServerSide(
                  _ime, _prezime, _telefon, _adresa, _grad, _drzava);
            }
          }
        },
        cells: [
          DataCell(Text(item!.ime,
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.prezime,
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.brojTelefona ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.adresa ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.grad ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.drzava ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(ElevatedButton(
            onPressed: () async {
              if (context.mounted) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: "Potvrda brisanja",
                  text: "Jeste li sigurni da želite obrisati zaposlenika?",
                  confirmBtnText: "U redu",
                  onConfirmBtnTap: () async {
                    await provider.delete(item.zaposlenikId);
                    if (context.mounted) {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Uspješno ste obrisali zaposlenika",
                        confirmBtnText: "U redu",
                        text: "Zaposlenik je obrisan",
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      filterServerSide(
                          _ime, _prezime, _telefon, _adresa, _grad, _drzava);
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

  void filterServerSide(ime, prezime, brojTelefona, adresa, grad, drzava) {
    _ime = ime;
    _prezime = prezime;
    _telefon = brojTelefona;
    _adresa = adresa;
    _grad = grad;
    _drzava = drzava;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Zaposlenik>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'ImeGTE': _ime,
      'PrezimeGTE': _prezime,
      'BrojTelefona': _telefon,
      'AdresaGTE': _adresa,
      'GradGTE': _grad,
      'DrzavaGTE': _drzava,
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
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: e.toString().split(': ')[1]);
      }
    }

    return RemoteDataSourceDetails(count, data!);
  }
}
