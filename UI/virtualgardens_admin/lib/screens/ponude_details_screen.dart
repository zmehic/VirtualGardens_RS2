import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/ponuda.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/set.dart';
import 'package:virtualgardens_admin/models/setovi_ponude.dart';
import 'package:virtualgardens_admin/providers/ponude_provider.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_ponude_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';

class ProizvodiSetDTO {
  int? proizvodId;
  int? setId;
  int? kolicina;

  ProizvodiSetDTO({
    this.proizvodId,
    this.setId,
    this.kolicina,
  });

  Map<String, dynamic> toJson() {
    return {
      'proizvodId': proizvodId,
      'setId': setId,
      'kolicina': kolicina,
    };
  }
}

class PonudeDetailsScreen extends StatefulWidget {
  final Ponuda? ponuda;
  const PonudeDetailsScreen({super.key, this.ponuda});

  @override
  State<PonudeDetailsScreen> createState() => _PonudeDetailsScreenState();
}

class _PonudeDetailsScreenState extends State<PonudeDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey2 = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};
  Map<String, dynamic> _initialValue3 = {};

  List<String>? allowedActions;

  List<Proizvod> tlo = [];
  List<Proizvod> sjeme = [];
  List<Proizvod> prihrana = [];

  late PonudeProvider _ponudeProvider;
  late SetoviPonudeProvider _setoviPonudeProvider;
  late ProductProvider _proizvodiProvider;
  late SetoviProvider _setoviProvider;

  List<ProizvodiSetDTO> productList = [];

  SearchResult<SetoviPonude>? setoviPonudeResult;
  SearchResult<Proizvod>? proizvodiResult;
  Set? set;
  SetoviPonude? setPonuda;

  bool? isDeleted;

  bool isLoading = true;
  bool isLoadingSave = false;

  final TextEditingController _datumPonudeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _ponudeProvider = context.read<PonudeProvider>();
    _setoviPonudeProvider = context.read<SetoviPonudeProvider>();
    _proizvodiProvider = context.read<ProductProvider>();
    _setoviProvider = context.read<SetoviProvider>();
    initForm();
    super.initState();
  }

  Future initForm() async {
    _initialValue = {
      'ponudaId': widget.ponuda?.ponudaId,
      'naziv': widget.ponuda?.naziv,
      'popust': widget.ponuda?.popust.toString(),
      'stateMachine': widget.ponuda?.stateMachine,
      'datumKreiranja': widget.ponuda?.datumKreiranja.toIso8601String(),
    };

    _initialValue3 = {
      'cijena': null,
      'popust': null,
      'cijenaSaPopustom': null,
      'proizvodId1': null,
      'proizvodId2': null,
      'proizvodId3': null
    };

    _datumPonudeController.text = widget.ponuda != null
        ? formatDateString(widget.ponuda!.datumKreiranja.toIso8601String())
        : formatDateString(DateTime.now().toIso8601String());
    isDeleted = false;
    var filter = {
      'PonudaId': widget.ponuda?.ponudaId,
      'IsDeleted': isDeleted,
      'IncludeTables': "Set"
    };

    if (widget.ponuda != null) {
      allowedActions =
          await _ponudeProvider.allowedActions(id: widget.ponuda?.ponudaId);
      setoviPonudeResult = await _setoviPonudeProvider.get(filter: filter);
      if (setoviPonudeResult != null) {}

      var filter2 = {
        'IsDeleted': false,
        'IncludeTables': "JedinicaMjere,VrstaProizvoda"
      };

      proizvodiResult = await _proizvodiProvider.get(filter: filter2);
      if (proizvodiResult != null) {
        tlo = proizvodiResult!.result
            .where((element) => element.vrstaProizvoda?.naziv == "Tlo")
            .toList();
        prihrana = proizvodiResult!.result
            .where((element) => element.vrstaProizvoda?.naziv == "Prihrana")
            .toList();
        sjeme = proizvodiResult!.result
            .where((element) => element.vrstaProizvoda?.naziv == "Sjeme")
            .toList();
      }
    }
    setState(() {
      isLoading = false;
      isLoadingSave = false;
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
                  widget.ponuda != null ? "Detalji o ponudi" : "Nova ponuda",
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
        "Detalji");
  }

  Widget _buildMain() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Row(
          children: [
            widget.ponuda != null
                ? Expanded(
                    child: Container(
                      color: const Color.fromRGBO(32, 76, 56, 1),
                      child: Column(children: [
                        setoviPonudeResult != null &&
                                setoviPonudeResult!.result.isNotEmpty
                            ? Container()
                            : _buildSetPonudeForm(),
                        Expanded(
                          child: _buildResultView(),
                        )
                      ]),
                    ),
                  )
                : Container(),
            Expanded(
              child: Container(
                color: const Color.fromRGBO(32, 76, 56, 1),
                child: Container(
                    margin: const EdgeInsets.all(15),
                    color: const Color.fromRGBO(235, 241, 224, 1),
                    child: _buildNewForm()),
              ),
            )
          ],
        ),
      ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                        decoration:
                            const InputDecoration(labelText: "Naziv ponude"),
                        name: "naziv",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Unesite naziv ponude';
                          }

                          return null;
                        }),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                        decoration: const InputDecoration(labelText: "Popust"),
                        name: "popust",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        enabled: widget.ponuda != null ? false : true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Unesite popust';
                          }
                          if (int.tryParse(value.toString())! > 100 ||
                              int.tryParse(value.toString())! < 0) {
                            return 'Morate unijeti broj između 0 i 100';
                          }
                          return null;
                        }),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      enabled: false,
                      controller: _datumPonudeController,
                      decoration:
                          const InputDecoration(labelText: "Datum ponude"),
                      name: "datumKreiranja",
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose some value';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          _datumPonudeController.text =
                              formatDateString(pickedDate.toIso8601String());
                          _initialValue['datumKreiranja'] =
                              pickedDate.toIso8601String();
                        }
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  widget.ponuda != null
                      ? Expanded(
                          child: FormBuilderDropdown(
                          enabled: false,
                          name: "stateMachine",
                          initialValue: widget.ponuda?.stateMachine,
                          decoration:
                              const InputDecoration(labelText: "Stanje"),
                          items: const [
                            DropdownMenuItem(
                                value: "created", child: Text("Kreirana")),
                            DropdownMenuItem(
                                value: "active", child: Text("Aktivna")),
                            DropdownMenuItem(
                                value: "finished", child: Text("Završena"))
                          ],
                        ))
                      : Container(),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  allowedActions != null && allowedActions!.contains("edit")
                      ? SizedBox(
                          child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await _ponudeProvider.ponudeState(
                                      action: "edit",
                                      id: widget.ponuda?.ponudaId);
                                  if (mounted) {
                                    await buildSuccessAlert(
                                        context,
                                        "Ponuda je spremljena",
                                        "Stanje ponude ${widget.ponuda?.naziv} usješno promijenjeno");
                                  }
                                } on Exception catch (e) {
                                  if (mounted) {
                                    await buildErrorAlert(
                                        context, "Greška", e.toString(), e);
                                  }
                                }
                              },
                              child: const Text("Kreirana")))
                      : Container(),
                  allowedActions != null && allowedActions!.contains("activate")
                      ? const SizedBox(
                          width: 20,
                        )
                      : Container(),
                  allowedActions != null &&
                          allowedActions!.contains("activate") &&
                          setoviPonudeResult != null &&
                          setoviPonudeResult!.result.isNotEmpty
                      ? SizedBox(
                          child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await _ponudeProvider.ponudeState(
                                      action: "activate",
                                      id: widget.ponuda?.ponudaId);
                                  if (mounted) {
                                    await buildSuccessAlert(
                                        context,
                                        "Ponuda je spremljena",
                                        "Stanje ponude ${widget.ponuda?.naziv} usješno promijenjeno");
                                  }
                                } on Exception catch (e) {
                                  if (mounted) {
                                    await buildErrorAlert(
                                        context, "Greška", e.toString(), e);
                                  }
                                }
                              },
                              child: const Text("Aktiviraj")))
                      : Container(),
                  allowedActions != null && allowedActions!.contains("finish")
                      ? const SizedBox(
                          width: 20,
                        )
                      : Container(),
                  allowedActions != null && allowedActions!.contains("finish")
                      ? SizedBox(
                          child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await _ponudeProvider.ponudeState(
                                      action: "finish",
                                      id: widget.ponuda?.ponudaId);
                                  if (mounted) {
                                    await buildSuccessAlert(
                                        context,
                                        "Ponuda je spremljena",
                                        "Stanje ponude ${widget.ponuda?.naziv} usješno promijenjeno");
                                  }
                                } on Exception catch (e) {
                                  if (mounted) {
                                    await buildErrorAlert(
                                        context, "Greška", e.toString(), e);
                                  }
                                }
                              },
                              child: const Text("Završena")))
                      : Container(),
                  widget.ponuda?.stateMachine == "created" ||
                          widget.ponuda == null
                      ? Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: widget.ponuda?.stateMachine == "created" ||
                                      widget.ponuda == null
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState
                                                ?.saveAndValidate() ==
                                            true) {
                                          debugPrint(_formKey
                                              .currentState?.value
                                              .toString());

                                          var request = Map.from(
                                              _formKey.currentState!.value);
                                          try {
                                            if (widget.ponuda != null) {
                                              var response =
                                                  await _ponudeProvider.update(
                                                      widget.ponuda!.ponudaId,
                                                      request);
                                              if (mounted) {
                                                await buildSuccessAlert(
                                                    context,
                                                    "Ponuda je spremljena",
                                                    "Ponuda ${response.naziv} je spremljena");
                                              }
                                            } else {
                                              await _ponudeProvider
                                                  .insert(request);
                                              if (mounted) {
                                                await buildSuccessAlert(
                                                    context,
                                                    "Ponuda je dodana",
                                                    "Ponuda ${widget.ponuda?.naziv} je dodana");
                                              }
                                            }
                                          } on Exception catch (e) {
                                            if (mounted) {
                                              await buildErrorAlert(context,
                                                  "Greška", e.toString(), e);
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
                                    )
                                  : Container(),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildResultView() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: setoviPonudeResult?.result.length,
              itemBuilder: (context, index) {
                return setoviPonudeResult != null &&
                        setoviPonudeResult?.result[index] != null
                    ? _buildExpansionTile(index)
                    : Container();
              },
            )
          ],
        )));
  }

  Widget _buildExpansionTile(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        trailing: widget.ponuda?.stateMachine == "created"
            ? IconButton(
                icon: const Icon(
                  (Icons.delete),
                  color: Colors.red,
                ),
                onPressed: () async {
                  if (context.mounted) {
                    await buildDeleteAlert(
                        context,
                        "Set ${index + 1}",
                        "Set ${index + 1}",
                        _setoviPonudeProvider,
                        setoviPonudeResult!.result[index].setoviPonudeId);
                    initForm();
                  }
                },
              )
            : const SizedBox(
                width: 5,
                height: 5,
              ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        title: Text(
          "Set ${index + 1}",
          style: const TextStyle(color: Colors.black),
        ),
        textColor: Colors.white,
        children: [
          if (setoviPonudeResult?.result[index].set?.proizvodiSets != null &&
              setoviPonudeResult!.result[index].set!.proizvodiSets.isNotEmpty)
            ...setoviPonudeResult!.result[index].set!.proizvodiSets
                .map((proizvodSet) {
              return ListTile(
                title: Text(proizvodSet.proizvod?.naziv ?? "N/A"),
              );
            }),
        ],
      ),
    );
  }

  _buildSetPonudeForm() {
    return FormBuilder(
      key: _formKey2,
      initialValue: _initialValue3,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(235, 241, 224, 1),
          border:
              Border.all(color: const Color.fromRGBO(32, 76, 56, 1), width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Popust",
                ),
                initialValue: widget.ponuda?.popust.toString(),
                enabled: false,
                name: "popust",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            buildSetPonudeField("proizvodId1", "Tlo", tlo),
            const SizedBox(
              width: 10,
            ),
            buildSetPonudeField("proizvodId2", "Sjeme", sjeme),
            const SizedBox(
              width: 10,
            ),
            buildSetPonudeField("proizvodId3", "Prihrana", prihrana),
            const SizedBox(
              width: 10,
            ),
            widget.ponuda?.stateMachine == "created"
                ? SizedBox(
                    width: 45,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey2.currentState?.saveAndValidate() == true) {
                          debugPrint(_formKey.currentState?.value.toString());

                          var request = Map.from(_formKey2.currentState!.value);
                          productList.add(ProizvodiSetDTO(
                              proizvodId: int.tryParse(request['proizvodId1']),
                              setId: set?.setId,
                              kolicina: int.tryParse(request['kolicinaTlo'])));
                          productList.add(ProizvodiSetDTO(
                            proizvodId: int.tryParse(request['proizvodId2']),
                            setId: set?.setId,
                            kolicina: int.tryParse(request['kolicinaSjeme']),
                          ));
                          productList.add(ProizvodiSetDTO(
                            proizvodId: int.tryParse(request['proizvodId3']),
                            setId: set?.setId,
                            kolicina: int.tryParse(request['kolicinaPrihrana']),
                          ));

                          Map<dynamic, dynamic> requestOne = {
                            'popust': request['popust'] ?? 0,
                            'cijena': 0,
                            'cijenaSaPopustom': null,
                            'proizvodiSets':
                                productList.map((e) => e.toJson()).toList()
                          };
                          request['popust'] = request['popust'] ?? 0;
                          request['cijena'] = 0;
                          request['cijenaSaPopustom'] = 0;

                          setState(() {});
                          try {
                            if (widget.ponuda == null) {
                            } else {
                              set = await _setoviProvider.insert(requestOne);
                              if (set != null) {
                                Map<dynamic, dynamic> requestTwo = {
                                  'setId': set!.setId,
                                  'ponudaId': widget.ponuda?.ponudaId
                                };
                                setPonuda = await _setoviPonudeProvider
                                    .insert(requestTwo);
                              }
                              if (mounted) {
                                await buildSuccessAlert(context,
                                    "Uspješno ste dodali set", "Set je dodan",
                                    isDoublePop: false);
                              }
                            }

                            _formKey2.currentState?.reset();
                            initForm();
                            setState(() {});
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
                      child: isLoadingSave
                          ? const CircularProgressIndicator()
                          : const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget buildSetPonudeField(name, label, List<dynamic> itemsSent) {
    return Expanded(
      child: Column(
        children: [
          FormBuilderDropdown(
            name: name,
            decoration: InputDecoration(labelText: label),
            items: itemsSent
                .map((item) => DropdownMenuItem(
                      value: item.proizvodId.toString(),
                      child: Text(
                          "${item.naziv} (${item.jedinicaMjere?.skracenica})"),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Morate odabrati \n$label';
              }
              return null;
            },
          ),
          FormBuilderTextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(labelText: "Količina $label"),
            name: "kolicina$label",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Polje količina ne \nsmije biti prazno.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
