import 'dart:async';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/jedinice_mjere.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/jedinice_mjere_provider.dart';
import 'package:virtualgardens_admin/screens/jedinice_mjere_details_screen.dart';

class JediniceMjereListScreen extends StatefulWidget {
  const JediniceMjereListScreen({super.key});

  @override
  State<JediniceMjereListScreen> createState() =>
      _JediniceMjereListScreenState();
}

class _JediniceMjereListScreenState extends State<JediniceMjereListScreen> {
  late JediniceMjereProvider provider;
  late JediniceMjereDataSource dataSource;
  int rowsPerPage = 8;

  SearchResult<JediniceMjere>? result;

  bool isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldKeyProfile =
      GlobalKey<ScaffoldState>();

  final TextEditingController ftsEditingController = TextEditingController();
  final TextEditingController skraceniceEditingController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    provider = context.read<JediniceMjereProvider>();
    dataSource = JediniceMjereDataSource(
      provider: provider,
      context: context,
    );
    super.initState();
    initForm();
  }

  Future initForm() async {
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
          key: _scaffoldKeyProfile,
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
              "Jedinice mjere",
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
      "Jedinice mjere",
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
              decoration: const InputDecoration(
                filled: true,
                labelText: "Naziv",
              ),
              onChanged: (value) {
                dataSource.filterServerSide(
                    value, skraceniceEditingController.text);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: ftsEditingController,
              decoration: const InputDecoration(
                filled: true,
                labelText: "Skraćenica",
              ),
              onChanged: (value) {
                dataSource.filterServerSide(ftsEditingController.text, value);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(const Size(150, 50))),
                onPressed: () async {
                  var response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              const JedinicaMjereDetailsScreen())));
                  if (response == true) {
                    dataSource.filterServerSide(ftsEditingController.text,
                        skraceniceEditingController.text);
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
      columns: const [
        DataColumn(
            label: Text(
          "Naziv",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Skracenica",
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataColumn(
            label: Text(
          "Opis",
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
}

class JediniceMjereDataSource extends AdvancedDataTableSource<JediniceMjere> {
  List<JediniceMjere>? data = [];
  final JediniceMjereProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String _nazivGTE = "";
  String? _skracenica;
  dynamic filter;
  BuildContext context;
  JediniceMjereDataSource({required this.provider, required this.context});

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
                    builder: ((context) => JedinicaMjereDetailsScreen(
                          jedinicaMjere: item,
                        ))));
            if (response == true) {
              filterServerSide(_nazivGTE, _skracenica);
            }
          }
        },
        cells: [
          DataCell(Text(item!.naziv ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.skracenica ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(Text(item.opis ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(ElevatedButton(
            onPressed: () async {
              if (context.mounted) {
                await buildDeleteAlert(context, item.naziv ?? "",
                    item.naziv ?? "", provider, item.jedinicaMjereId!);
                filterServerSide(_nazivGTE, _skracenica);
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

  void filterServerSide(naziv, skracenica) {
    _nazivGTE = naziv;
    _skracenica = skracenica;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<JediniceMjere>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'NazivGTE': _nazivGTE,
      'SkracenicaGTE': _skracenica,
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
