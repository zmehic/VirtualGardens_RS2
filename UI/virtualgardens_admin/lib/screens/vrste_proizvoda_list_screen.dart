import 'dart:async';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
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
              "Vrste proizvoda",
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
          ))),
    );
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
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: "Potvrda brisanja",
                  text: "Jeste li sigurni da želite obrisati vrstu proizvoda?",
                  confirmBtnText: "U redu",
                  onConfirmBtnTap: () async {
                    try {
                      await provider.delete(item.vrstaProizvodaId!);
                      if (context.mounted) {
                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: "Uspješno ste obrisali vrstu proizvoda",
                          confirmBtnText: "U redu",
                          text: "Vrsta proizvoda je obrisana",
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        filterServerSide(_nazivGTE);
                      }
                    } on Exception catch (e) {
                      if (context.mounted) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: e.toString().split(': ')[1],
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        );
                      }
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
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: e.toString().split(': ')[1]);
      }
    }

    return RemoteDataSourceDetails(count, data!);
  }
}
