import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/nalozi.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/models/zaposlenici.dart';
import 'package:virtualgardens_admin/providers/nalozi_provider.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/zaposlenici_provider.dart';

class NaloziDetailsScreen extends StatefulWidget {
  final Nalog? nalog;
  const NaloziDetailsScreen({super.key, this.nalog});

  @override
  State<NaloziDetailsScreen> createState() => _NaloziDetailsScreenState();
}

class _NaloziDetailsScreenState extends State<NaloziDetailsScreen> {
  late NarudzbeNalogDataSource dataSource;

  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey2 = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};
  final Map<String, dynamic> _initialValue2 = {};

  late bool selectedStanje;
  late NaloziProvider _naloziProvider;
  late NarudzbaProvider _narudzbaProvider;
  late ZaposlenikProvider _zaposlenikProvider;

  SearchResult<UlazProizvod>? ulaziProizvodiResult;
  SearchResult<Narudzba>? narudzbaResult;
  SearchResult<Zaposlenik>? zaposleniciResult;

  bool isLoading = true;

  int? zaposlenikId = 0;
  int? narudzbaId;

  final TextEditingController _datumNalogaController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _naloziProvider = context.read<NaloziProvider>();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    _zaposlenikProvider = context.read<ZaposlenikProvider>();
    selectedStanje = widget.nalog?.zavrsen ?? false;
    zaposlenikId = widget.nalog?.zaposlenikId;
    dataSource =
        NarudzbeNalogDataSource(provider: _narudzbaProvider, context: context);

    initForm();
    super.initState();
  }

  Future initForm() async {
    _initialValue = {
      'nalogId': widget.nalog?.nalogId,
      'brojNaloga': widget.nalog?.brojNaloga,
      'datumNaloga': widget.nalog?.datumKreiranja.toIso8601String() ??
          formatDateString(DateTime.now().toIso8601String()),
      'zaposlenikId': widget.nalog?.zaposlenikId,
      'zavrsen': widget.nalog?.zavrsen
    };

    _datumNalogaController.text = widget.nalog != null
        ? formatDateString(widget.nalog!.datumKreiranja.toIso8601String())
        : formatDateString(DateTime.now().toIso8601String());
    var filter = {
      'isDeleted': false,
    };

    zaposleniciResult = await _zaposlenikProvider.get(filter: filter);

    if (widget.nalog != null) {
      var filter2 = {
        'IsDeleted': false,
        'NalogId': 0,
        'Otkazana': false,
        'Placeno': true,
        'StateMachine': "inprogress",
      };

      narudzbaResult = await _narudzbaProvider.get(filter: filter2);
      dataSource.filterServerSide(widget.nalog?.nalogId);
    }

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
                  widget.nalog == null ? "Dodaj nalog" : "Uredi nalog",
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
        "Nalog");
  }

  Widget _buildMain() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Row(
          children: [
            widget.nalog != null
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(32, 76, 56, 1),
                      child: Column(children: [
                        _buildNarudzbeForm(),
                        _buildResultView(),
                      ]),
                    ),
                  )
                : Container(),
            Expanded(
              child: Container(
                color: const Color.fromRGBO(235, 241, 224, 1),
                child: _buildNewForm(),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildNarudzbeForm() {
    return FormBuilder(
      key: _formKey2,
      initialValue: _initialValue2,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10.0),
        color: const Color.fromRGBO(235, 241, 224, 1),
        child: Row(
          children: [
            Expanded(
              child: FormBuilderDropdown(
                name: "narudzbaId",
                decoration: const InputDecoration(labelText: "Narudžba"),
                items: narudzbaResult?.result
                        .map((item) => DropdownMenuItem(
                              value: item.narudzbaId.toString(),
                              child: Text(item.brojNarudzbe),
                            ))
                        .toList() ??
                    [],
                validator: (value) {
                  if (value == null) {
                    return 'Morate odabrati narudžbu';
                  }
                  return null;
                },
                onChanged: (value) {
                  narudzbaId = int.tryParse(value.toString());
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 45,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey2.currentState?.saveAndValidate() == true) {
                    debugPrint(_formKey.currentState?.value.toString());

                    Map<dynamic, dynamic> request = {};
                    var narudzba = narudzbaResult?.result
                        .where((element) => element.narudzbaId == narudzbaId)
                        .first;
                    request['brojNarudzbe'] = narudzba?.brojNarudzbe;
                    request['ukupnaCijena'] = narudzba?.ukupnaCijena;
                    request['korisnikId'] = narudzba?.korisnikId;
                    request['placeno'] = narudzba?.placeno;
                    request['nalogId'] = widget.nalog?.nalogId;
                    setState(() {});
                    try {
                      if (widget.nalog == null) {
                      } else {
                        await _narudzbaProvider.update(
                            narudzba!.narudzbaId, request);
                        widget.nalog!.narudzbes.add(Narudzba(
                            narudzbaId: narudzba.narudzbaId,
                            brojNarudzbe: narudzba.brojNarudzbe,
                            datum: narudzba.datum,
                            placeno: narudzba.placeno,
                            ukupnaCijena: narudzba.ukupnaCijena,
                            korisnikId: narudzba.korisnikId));
                      }

                      if (mounted) {
                        await buildSuccessAlert(
                          context,
                          "Uspješno ste dodali narudžbu",
                          "Uspješno ste dodali narudžbu ${narudzba?.brojNarudzbe} u nalog ${widget.nalog?.brojNaloga}",
                          isDoublePop: false,
                        );
                      }
                      _formKey2.currentState?.reset();
                      initForm();
                    } on Exception catch (e) {
                      if (mounted) {
                        await buildErrorAlert(
                            context, "Greška", e.toString(), e);
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(235, 241, 224, 1),
          ),
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          child: SingleChildScrollView(
              child: AdvancedPaginatedDataTable(
            source: dataSource,
            rowsPerPage: 9,
            showCheckboxColumn: false,
            addEmptyRows: false,
            columns: const [
              DataColumn(
                  label: Text(
                "Narudzba",
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
                ),
              ),
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

  Widget _buildNewForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: FormBuilderDropdown(
                      enabled: true,
                      name: "zaposlenikId",
                      initialValue: widget.nalog?.zaposlenikId.toString(),
                      decoration:
                          const InputDecoration(labelText: "Zaposlenik"),
                      items: zaposleniciResult?.result
                              .map((item) => DropdownMenuItem(
                                    value: item.zaposlenikId.toString(),
                                    child: Text("${item.ime} ${item.prezime}"),
                                  ))
                              .toList() ??
                          [],
                      validator: (value) {
                        if (value == null) {
                          return 'Molimo odaberite zaposlenika';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        zaposlenikId = int.tryParse(value.toString());
                      },
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: FormBuilderCheckbox(
                name: "zavrsen",
                initialValue: _initialValue['zavrsen'] ?? false,
                validator: (value) {
                  if (value == null) {
                    return 'Morate odabrati neku vrijednost';
                  }
                  return null;
                },
                title: const Text(
                  "Da li je nalog završen",
                  style: TextStyle(fontSize: 15),
                ),
              )),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.saveAndValidate() ==
                                    true) {
                                  debugPrint(
                                      _formKey.currentState?.value.toString());

                                  var request =
                                      Map.from(_formKey.currentState!.value);
                                  request['brojNaloga'] =
                                      widget.nalog?.brojNaloga;
                                  request['zaposlenikId'] = zaposlenikId;
                                  request['narudzbe'] = [];
                                  setState(() {});
                                  try {
                                    if (widget.nalog == null) {
                                      var response =
                                          await _naloziProvider.insert(request);
                                      if (mounted) {
                                        await buildSuccessAlert(
                                          context,
                                          "Uspješno ste dodali nalog",
                                          "Novi nalog ${response.brojNaloga} je uspješno dodan.",
                                        );
                                      }
                                    } else {
                                      var response =
                                          await _naloziProvider.update(
                                              widget.nalog!.nalogId, request);
                                      if (mounted) {
                                        await buildSuccessAlert(
                                          context,
                                          "Uspješno ste izmijenili nalog",
                                          "Nalog ${response.brojNaloga} je uspješno izmijenjen.",
                                        );
                                      }
                                    }
                                  } on Exception catch (e) {
                                    if (mounted) {
                                      await buildErrorAlert(
                                          context, "Greška", e.toString(), e);
                                    }
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
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class NarudzbeNalogDataSource extends AdvancedDataTableSource<Narudzba> {
  List<Narudzba>? data = [];
  final NarudzbaProvider provider;
  int count = 9;
  int page = 1;
  int pageSize = 9;
  int nalogId = 0;
  dynamic filter;
  BuildContext context;
  NarudzbeNalogDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data!.length) {
      return null;
    }

    final item = data?[index];
    return DataRow(cells: [
      DataCell(Text(item!.brojNarudzbe,
          style: const TextStyle(color: Colors.black, fontSize: 18))),
      DataCell(Text(formatDateString(item.datum.toIso8601String()),
          style: const TextStyle(color: Colors.black, fontSize: 18))),
      DataCell(Text(item.ukupnaCijena.toString(),
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
                var request = {};
                request['brojNarudzbe'] = item.brojNarudzbe;
                request['ukupnaCijena'] = item.ukupnaCijena;
                request['korisnikId'] = item.korisnikId;
                request['placeno'] = item.placeno;
                request['nalogId'] = null;
                try {
                  await provider.update(item.narudzbaId, request);
                  if (context.mounted) {
                    await buildSuccessAlert(
                      context,
                      "Uspješno ste obrisali narudžbu",
                      "Narudžba ${item.brojNarudzbe} je uspješno obrisana iz naloga",
                      isDoublePop: false,
                    );
                  }
                } on Exception {
                  if (context.mounted) {
                    await buildErrorAlert(
                        context,
                        "Greška",
                        "Narudžba je završena",
                        Exception("Narudžba je završena unutar ovog naloga"));
                  }
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                  filterServerSide(nalogId);
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

  void filterServerSide(nalogID) {
    nalogId = nalogID;
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
      'NalogId': nalogId,
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
