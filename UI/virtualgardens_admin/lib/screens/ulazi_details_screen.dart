import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi.dart';
import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/ulazi_proizvodi_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';

class UlaziDetailsScreen extends StatefulWidget {
  final Ulaz? ulaz;
  const UlaziDetailsScreen({super.key, this.ulaz});

  @override
  State<UlaziDetailsScreen> createState() => _UlaziDetailsScreenState();
}

class _UlaziDetailsScreenState extends State<UlaziDetailsScreen> {
  late UlaziProizvodiDataSource dataSource;
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey2 = GlobalKey<FormBuilderState>();

  int selectedProizvodId = 0;

  Map<String, dynamic> _initialValue = {};
  Map<String, dynamic> _initialValue2 = {};

  late UlaziProizvodiProvider _ulaziProizvodiProvider;
  late ProductProvider _proizvodiProvider;

  SearchResult<UlazProizvod>? ulaziProizvodiResult;
  SearchResult<Proizvod>? proizvodiResult;

  bool isLoading = true;
  bool isLoadingSave = false;

  final TextEditingController _datumUlazaController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _ulaziProizvodiProvider = context.read<UlaziProizvodiProvider>();
    _proizvodiProvider = context.read<ProductProvider>();
    dataSource = UlaziProizvodiDataSource(
      provider: _ulaziProizvodiProvider,
      context: context,
    );

    initForm();
    super.initState();
  }

  Future initForm() async {
    _initialValue = {
      'ulazId': widget.ulaz?.ulazId,
      'brojUlaza': widget.ulaz?.brojUlaza,
      'datumUlaza': widget.ulaz?.datumUlaza.toIso8601String(),
      'korisnikId': widget.ulaz?.korisnikId,
    };

    _initialValue2 = {
      'ulazId': widget.ulaz?.ulazId,
      'proizvoidId': null,
      'kolicina': null
    };
    _datumUlazaController.text = widget.ulaz != null
        ? formatDateString(widget.ulaz!.datumUlaza.toIso8601String())
        : "";

    if (widget.ulaz != null) {
      var filter2 = {'IsDeleted': false, 'IncludeTables': "JedinicaMjere"};

      proizvodiResult = await _proizvodiProvider.get(filter: filter2);
      if (proizvodiResult != null) {
        selectedProizvodId = proizvodiResult!.result[0].proizvodId!;
      }
    }
    dataSource.filterServerSide(widget.ulaz?.ulazId);
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
                  },
                ),
                actions: <Widget>[Container()],
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                title: const Text(
                  "Detalji o ulazu",
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
                  children: [_buildMain()],
                ),
              ),
            )),
        "Detalji");
  }

  Widget _buildMain() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(15),
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color.fromRGBO(32, 76, 56, 1),
                          child: Column(children: [
                            _buildUlaziProizvodiForm(),
                            _buildResultView(),
                          ]),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          color: const Color.fromRGBO(32, 76, 56, 1),
                          child: _buildNewForm(),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildNewForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Container(
          color: const Color.fromRGBO(235, 241, 224, 1),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                    enabled: false,
                    decoration: const InputDecoration(labelText: "Broj ulaza"),
                    name: "brojUlaza",
                  ))
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      enabled: false,
                      controller: _datumUlazaController,
                      decoration:
                          const InputDecoration(labelText: "Datum ulaza"),
                      name: "datumUlaza",
                      readOnly: true,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: FormBuilderDropdown(
                    enabled: false,
                    name: "korisnikId",
                    decoration: const InputDecoration(labelText: "Korisnik"),
                    items: [
                      DropdownMenuItem(
                          value: widget.ulaz?.korisnikId,
                          child: Text(
                              "${widget.ulaz?.korisnik.ime} ${widget.ulaz?.korisnik.prezime}"))
                    ],
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ));
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
            showCheckboxColumn: false,
            rowsPerPage: 9,
            columns: const [
              DataColumn(
                  label: Text(
                "Proizvod",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                  label: Text(
                "Količina",
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
              DataColumn(
                label: Text(
                  "Obriši",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
            source: dataSource,
            addEmptyRows: false,
          ))),
    );
  }

  _buildUlaziProizvodiForm() {
    return FormBuilder(
      key: _formKey2,
      initialValue: _initialValue2,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(235, 241, 224, 1),
        ),
        child: Row(
          children: [
            DropdownButtonHideUnderline(
                child: DropdownButton2(
                    value: proizvodiResult?.result[0].proizvodId.toString(),
                    iconStyleData:
                        const IconStyleData(iconEnabledColor: Colors.black),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                          color: Colors.brown.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.brown.shade300, width: 2)),
                    ),
                    items: proizvodiResult?.result
                            .map((item) => DropdownMenuItem(
                                  value: item.proizvodId.toString(),
                                  child: Text(item.naziv ?? "",
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ))
                            .toList() ??
                        [],
                    onChanged: (value) async {
                      selectedProizvodId = int.tryParse(value.toString())!;
                    })),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Količina",
                  filled: true,
                ),
                name: "kolicina",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje količina ne smije biti prazno.';
                  }
                  return null;
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

                    var request = Map.from(_formKey2.currentState!.value);
                    request['ulazId'] = widget.ulaz?.ulazId;
                    request['proizvodId'] = selectedProizvodId;
                    setState(() {});
                    try {
                      if (widget.ulaz == null) {
                      } else {
                        await _ulaziProizvodiProvider.insert(request);
                        if (mounted) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "Proizvod uspješno dodan u ulaz.",
                            title: "Dodan proizvod",
                            confirmBtnText: "U redu",
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              dataSource.filterServerSide(widget.ulaz?.ulazId);
                            },
                          );
                        }
                      }

                      _formKey2.currentState?.reset();
                      setState(() {});
                    } on Exception catch (e) {
                      debugPrint(e.toString());
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
}

class UlaziProizvodiDataSource extends AdvancedDataTableSource<UlazProizvod> {
  List<UlazProizvod>? data = [];
  final UlaziProizvodiProvider provider;
  int count = 9;
  int page = 1;
  int pageSize = 9;
  int ulazId = 0;
  dynamic filter;
  BuildContext context;
  UlaziProizvodiDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data!.length) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Text(item!.proizvod!.naziv ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 18))),
      DataCell(Text(
          "${item.kolicina.toString()} ${item.proizvod!.jedinicaMjere?.naziv}",
          style: const TextStyle(color: Colors.black, fontSize: 18))),
      DataCell(ElevatedButton(
        onPressed: () async {
          if (context.mounted) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              title: "Potvrda brisanja",
              text: "Jeste li sigurni da želite obrisati proizvod?",
              confirmBtnText: "U redu",
              onConfirmBtnTap: () async {
                await provider.delete(item.proizvodId);
                if (context.mounted) {
                  await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: "Uspješno ste obrisali proizvod",
                    confirmBtnText: "U redu",
                    text: "Proizvod je obrisan",
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop();
                    },
                  );
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                  filterServerSide(ulazId);
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

  void filterServerSide(ulazID) {
    ulazId = ulazID;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<UlazProizvod>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;

    var filter = {
      'UlazId': ulazId,
      'IsDeleted': false,
      'IncludeTables': "Proizvod",
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
