import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/nalozi.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/models/zaposlenici.dart';
import 'package:virtualgardens_admin/providers/nalozi_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/zaposlenici_provider.dart';

class ZaposleniciDetailsScreen extends StatefulWidget {
  final Zaposlenik? zaposlenik;
  const ZaposleniciDetailsScreen({super.key, this.zaposlenik});

  @override
  State<ZaposleniciDetailsScreen> createState() =>
      _ZaposleniciDetailsScreenState();
}

class _ZaposleniciDetailsScreenState extends State<ZaposleniciDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late ZaposleniciNaloziProizvodiDataSource dataSource;

  Map<String, dynamic> _initialValue = {};

  late ZaposlenikProvider _zaposlenikProvider;
  late NaloziProvider _naloziProvider;

  UlazProizvod? zaposlenik;
  SearchResult<Nalog>? naloziResult;

  bool isLoading = true;

  final TextEditingController _datumRodjenjaController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _zaposlenikProvider = context.read<ZaposlenikProvider>();
    _naloziProvider = context.read<NaloziProvider>();
    dataSource = ZaposleniciNaloziProizvodiDataSource(
      provider: _naloziProvider,
      context: context,
    );
    super.initState();

    initForm();
  }

  Future initForm() async {
    _initialValue = {
      "zaposlenikId": widget.zaposlenik?.zaposlenikId,
      "email": widget.zaposlenik?.email,
      "ime": widget.zaposlenik?.ime,
      "prezime": widget.zaposlenik?.prezime,
      "brojTelefona": widget.zaposlenik?.brojTelefona,
      "adresa": widget.zaposlenik?.adresa,
      "grad": widget.zaposlenik?.grad,
      "drzava": widget.zaposlenik?.drzava,
      "jeAktivan": widget.zaposlenik?.jeAktivan,
      "datumRodjenja": widget.zaposlenik?.datumRodjenja?.toIso8601String()
    };

    _datumRodjenjaController.text = widget.zaposlenik != null
        ? formatDateString(widget.zaposlenik!.datumRodjenja?.toIso8601String())
        : "";

    if (widget.zaposlenik != null) {
      dataSource.filterServerSide(widget.zaposlenik?.zaposlenikId);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader2(
          isLoading: isLoading,
          isList: false,
          title: widget.zaposlenik != null
              ? "Detalji o zaposleniku"
              : "Dodaj zaposlenik",
          actions: <Widget>[Container()],
          child: Column(
            children: [_buildMain()],
          ),
        ),
        "Detalji o zaposleniku");
  }

  Widget _buildMain() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Row(
          children: [
            widget.zaposlenik != null
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(32, 76, 56, 1),
                      child: Column(children: [
                        Expanded(
                          child: _buildResultView(),
                        )
                      ]),
                    ),
                  )
                : Container(),
            widget.zaposlenik != null
                ? const SizedBox(
                    width: 20,
                  )
                : Container(),
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
                        label: "Email",
                        name: "email",
                        isRequired: true,
                        maxLength: 100,
                        isEmail: true),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: FormBuilderCheckbox(
                            name: "jeAktivan",
                            initialValue: _initialValue['jeAktivan'] ?? true,
                            validator: (value) {
                              if (value == null) {
                                return 'Please choose some value';
                              }
                              return null;
                            },
                            title: const Text(
                              "Da li je zaposlenik aktivan",
                              style: TextStyle(fontSize: 15),
                            )))
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildFormBuilderTextField(
                        label: "Ime",
                        name: "ime",
                        maxLength: 50,
                        isRequired: true,
                        match: r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                        matchErrorText: "Ime može sadržavati samo slova."),
                    const SizedBox(
                      width: 10,
                    ),
                    buildFormBuilderTextField(
                        label: "Prezime",
                        name: "prezime",
                        maxLength: 50,
                        isRequired: true,
                        match: r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                        matchErrorText: "Prezime može sadržavati samo slova."),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FormBuilderTextField(
                        controller: _datumRodjenjaController,
                        decoration:
                            const InputDecoration(labelText: "Datum rođenja"),
                        name: "datumRodjenja",
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());
                          if (pickedDate != null) {
                            _datumRodjenjaController.text =
                                formatDateString(pickedDate.toIso8601String());
                            _initialValue['datumRodjenja'] =
                                pickedDate.toIso8601String();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    buildFormBuilderTextField(
                      maxLength: 12,
                      label: "Broj telefona",
                      name: "brojTelefona",
                      match: r'^(?:\+387[0-9]{2}[0-9]{6}|06[0-9]{7})$',
                      matchErrorText:
                          "Unesite ispravan broj mobitela (npr. +38761234567).",
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    buildFormBuilderTextField(
                      maxLength: 255,
                      name: "adresa",
                      label: "Adresa",
                      isValidated: false,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    buildFormBuilderTextField(
                        maxLength: 100,
                        name: "grad",
                        label: "Grad",
                        match: r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                        matchErrorText: "Grad može sadržavati samo slova."),
                    const SizedBox(
                      width: 10,
                    ),
                    buildFormBuilderTextField(
                        maxLength: 100,
                        name: "drzava",
                        label: "Država",
                        match: r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                        matchErrorText: "Država može sadržavati samo slova."),
                  ],
                ),
              ),
              Expanded(child: _buildSaveButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(235, 241, 224, 1),
        ),
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: AdvancedPaginatedDataTable(
          source: dataSource,
          showCheckboxColumn: false,
          rowsPerPage: 9,
          columns: const [
            DataColumn(
                label: Text(
              "Broj naloga",
              style: TextStyle(color: Colors.black, fontSize: 18),
            )),
            DataColumn(
                label: Text(
              "Datum naloga",
              style: TextStyle(color: Colors.black, fontSize: 18),
            )),
            DataColumn(
              label: Text(
                "Završen",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        )));
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
                var key = request.entries.elementAt(4).key;
                request[key] = _initialValue['datumRodjenja'];
                setState(() {});
                try {
                  if (widget.zaposlenik == null) {
                    var response = await _zaposlenikProvider.insert(request);
                    if (mounted) {
                      await buildSuccessAlert(
                          context,
                          "Uspješno ste dodali zaposlenika",
                          "Zaposlenik ${response.ime} ${response.prezime} je dodan");
                    }
                  } else {
                    var response = await _zaposlenikProvider.update(
                        widget.zaposlenik!.zaposlenikId, request);
                    if (mounted) {
                      await buildSuccessAlert(
                          context,
                          "Uspješno ste ažurirali zaposlenika",
                          "Zaposlenik ${response.ime} ${response.prezime} je ažuriran");
                    }
                  }
                } on Exception catch (e) {
                  if (mounted) {
                    await buildErrorAlert(context, "Greška", e.toString(), e);
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
        widget.zaposlenik != null
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
        await buildErrorAlert(context, "Greška", e.toString(), e);
      }
    }

    return RemoteDataSourceDetails(count, data!);
  }
}
