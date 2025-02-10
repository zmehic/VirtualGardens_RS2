import 'dart:async';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_admin/screens/vrste_proizvoda_details_screen.dart';

class VrsteProizvodaListScreen extends StatefulWidget {
  const VrsteProizvodaListScreen({super.key});

  @override
  State<VrsteProizvodaListScreen> createState() =>
      _VrsteProizvodaListScreenState();
}

class _VrsteProizvodaListScreenState extends State<VrsteProizvodaListScreen> {
  late VrsteProizvodaProvider provider;
  late VrsteProizvodaDataSource dataSource;
  int rowsPerPage = 8;

  SearchResult<VrstaProizvoda>? result;
  bool isLoading = true;
  final TextEditingController ftsEditingController = TextEditingController();
  final TextEditingController skraceniceEditingController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    provider = context.read<VrsteProizvodaProvider>();
    dataSource = VrsteProizvodaDataSource(
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
      FullScreenLoader2(
        isList: true,
        title: "Vrste proizvoda",
        actions: <Widget>[Container()],
        isLoading: isLoading,
        child: Column(
          children: [
            _buildSearch(),
            _buildResultView(),
          ],
        ),
      ),
      "Vrste proizvoda",
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
                LengthLimitingTextInputFormatter(32),
              ],
              decoration: const InputDecoration(
                filled: true,
                labelText: "Naziv",
              ),
              onChanged: (value) {
                dataSource.filterServerSide(value);
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
                              const VrsteProizvodaDetailsScreen())));
                  if (response == true) {
                    dataSource.filterServerSide(
                      ftsEditingController.text,
                    );
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

class VrsteProizvodaDataSource extends AdvancedDataTableSource<VrstaProizvoda> {
  List<VrstaProizvoda>? data = [];
  final VrsteProizvodaProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String _nazivGTE = "";
  dynamic filter;
  BuildContext context;
  VrsteProizvodaDataSource({required this.provider, required this.context});

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
                    builder: ((context) => VrsteProizvodaDetailsScreen(
                          vrstaProizvoda: item,
                        ))));
            if (response == true) {
              filterServerSide(_nazivGTE);
            }
          }
        },
        cells: [
          DataCell(Text(item!.naziv ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 18))),
          DataCell(ElevatedButton(
            onPressed: () async {
              if (context.mounted) {
                await buildDeleteAlert(context, item.naziv ?? "",
                    item.naziv ?? "", provider, item.vrstaProizvodaId!);
                filterServerSide(_nazivGTE);
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

  void filterServerSide(naziv) {
    _nazivGTE = naziv;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<VrstaProizvoda>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'NazivGTE': _nazivGTE,
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
