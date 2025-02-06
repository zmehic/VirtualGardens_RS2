import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/jedinice_mjere.dart';
import 'package:virtualgardens_admin/models/nalozi.dart';
import 'package:virtualgardens_admin/providers/jedinice_mjere_provider.dart';
import 'package:virtualgardens_admin/providers/nalozi_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';

class JedinicaMjereDetailsScreen extends StatefulWidget {
  final JediniceMjere? jedinicaMjere;
  const JedinicaMjereDetailsScreen({super.key, this.jedinicaMjere});

  @override
  State<JedinicaMjereDetailsScreen> createState() =>
      _JedinicaMjereDetailsScreenState();
}

class _JedinicaMjereDetailsScreenState
    extends State<JedinicaMjereDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late ZaposleniciNaloziProizvodiDataSource dataSource;

  Map<String, dynamic> _initialValue = {};

  late JediniceMjereProvider _provider;

  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _provider = context.read<JediniceMjereProvider>();
    super.initState();

    initForm();
  }

  Future initForm() async {
    _initialValue = {
      "naziv": widget.jedinicaMjere?.naziv,
      "skracenica": widget.jedinicaMjere?.skracenica,
      "opis": widget.jedinicaMjere?.opis,
    };
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
                    Navigator.of(context).pop(true);
                  },
                ),
                actions: <Widget>[Container()],
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  widget.jedinicaMjere != null
                      ? "Detalji o jedinici mjere"
                      : "Dodaj jedinicu mjere",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
              ),
              backgroundColor: const Color.fromRGBO(103, 122, 105, 1),
              body: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                color: const Color.fromRGBO(235, 241, 224, 1),
                child: Column(
                  children: [_buildMain()],
                ),
              ),
            )),
        "Detalji o jedinici mjere");
  }

  Widget _buildMain() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromRGBO(32, 76, 56, 1),
                child: _buildNewForm(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNewForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(235, 241, 224, 1),
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildFormBuilderTextField(
                      label: "Naziv",
                      name: "naziv",
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildFormBuilderTextField(
                      label: "Skracenica",
                      name: "skracenica",
                      isRequired: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Row(
                  children: [
                    buildFormBuilderTextField(
                      label: "Opis",
                      name: "opis",
                      isRequired: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(child: _buildSaveButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() == true) {
                debugPrint(_formKey.currentState?.value.toString());
                var request = Map.from(_formKey.currentState!.value);
                setState(() {});
                try {
                  if (widget.jedinicaMjere == null) {
                    await _provider.insert(request);
                    if (mounted) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Uspješno ste dodali jedinicu mjere",
                        confirmBtnText: "U redu",
                        text: "Jedinica mjere je dodana",
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(true);
                        },
                      );
                    }
                  } else {
                    await _provider.update(
                        widget.jedinicaMjere!.jedinicaMjereId!, request);
                    if (mounted) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Uspješno ste ažurirali jedinicu mjere",
                        confirmBtnText: "U redu",
                        text: "Jedinica mjere je ažurirana",
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(true);
                        },
                      );
                    }
                  }
                } on Exception catch (e) {
                  if (mounted) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: e.toString().split(': ')[1]);
                  }
                  setState(() {});
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(8),
            ),
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ),
        widget.jedinicaMjere != null
            ? const SizedBox(
                width: 20,
              )
            : Container(),
      ],
    );
  }
}

class ZaposleniciNaloziProizvodiDataSource
    extends AdvancedDataTableSource<Nalog> {
  List<Nalog>? data = [];
  final NaloziProvider provider;
  int count = 9;
  int page = 1;
  int pageSize = 9;
  int? zaposlenikId;
  dynamic filter;
  BuildContext context;
  ZaposleniciNaloziProizvodiDataSource(
      {required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data!.length) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Text(item!.brojNaloga,
          style: const TextStyle(color: Colors.black, fontSize: 18))),
      DataCell(Text(formatDateString(item.datumKreiranja.toIso8601String()),
          style: const TextStyle(color: Colors.black, fontSize: 18))),
      DataCell(Text(item.zavrsen == true ? "Da" : "Ne",
          style: const TextStyle(color: Colors.black, fontSize: 18))),
    ]);
  }

  void filterServerSide(zaposlenikID) {
    zaposlenikId = zaposlenikID;
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
      'ZaposlenikId': zaposlenikId,
      'IsDeleted': false,
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
