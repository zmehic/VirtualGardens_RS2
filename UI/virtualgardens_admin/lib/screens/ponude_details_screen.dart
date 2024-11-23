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
import 'package:virtualgardens_admin/providers/setovi_proizvodi_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/screens/ponude_list_screen.dart';

// ignore: must_be_immutable
class PonudeDetailsScreen extends StatefulWidget {
  Ponuda? ponuda;
  PonudeDetailsScreen({super.key, this.ponuda});

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
  late SetProizvodProvider _proizvodiSet;

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
    _proizvodiSet = context.read<SetProizvodProvider>();

    super.initState();

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

    initForm();
  }

  Future initForm() async {
    isDeleted = false;
    var filter = {
      'PonudaId': widget.ponuda?.ponudaId,
      'IsDeleted': isDeleted,
      'IncludeTables': "Set"
    };

    if (widget.ponuda != null) {
      allowedActions =
          await _ponudeProvider.AllowedActions(id: widget.ponuda?.ponudaId);
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
            child: Container(
              margin: const EdgeInsets.only(
                  left: 40, right: 40, top: 20, bottom: 10),
              color: const Color.fromRGBO(235, 241, 224, 1),
              child: Column(
                children: [_buildBanner(), _buildMain()],
              ),
            )),
        "Detalji");
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(size: 45, color: Colors.white, Icons.edit_note_rounded),
            const SizedBox(
              width: 10,
            ),
            widget.ponuda == null
                ? const Text("Nova ponuda",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arial",
                        color: Colors.white))
                : const Text("Detalji o ponudi",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arial",
                        color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _buildMain() {
    return Expanded(
      child: Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(32, 76, 56, 1),
          ),
          margin: const EdgeInsets.all(15),
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                widget.ponuda != null
                    ? Expanded(
                        child: Container(
                          color: const Color.fromRGBO(235, 241, 224, 1),
                          child: Column(children: [
                            _buildSetPonudeForm(),
                            Expanded(
                              child: _buildResultView(),
                            )
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
          )),
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
                            return 'Please enter some text';
                          }
                          return null;
                        }),
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                        decoration: const InputDecoration(labelText: "Popust"),
                        name: "popust",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
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
                              validator: (value) {
                                if (value == null) {
                                  return 'Please choose some value';
                                }
                                return null;
                              }))
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
                                isLoadingSave = true;
                                setState(() {});

                                await _ponudeProvider.ponudeState(
                                    action: "edit",
                                    id: widget.ponuda?.ponudaId);

                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PonudeListScreen()));
                              }, // Define this function to handle the save action
                              child: const Text("Kreirana")))
                      : Container(),
                  allowedActions != null && allowedActions!.contains("activate")
                      ? const SizedBox(
                          width: 20,
                        )
                      : Container(),
                  allowedActions != null && allowedActions!.contains("activate")
                      ? SizedBox(
                          child: ElevatedButton(
                              onPressed: () async {
                                isLoadingSave = true;
                                setState(() {});

                                await _ponudeProvider.ponudeState(
                                    action: "activate",
                                    id: widget.ponuda?.ponudaId);

                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PonudeListScreen()));
                              }, // Define this function to handle the save action
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
                                isLoadingSave = true;
                                setState(() {});

                                await _ponudeProvider.ponudeState(
                                    action: "finish",
                                    id: widget.ponuda?.ponudaId);

                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PonudeListScreen()));
                              }, // Define this function to handle the save action
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
                                          isLoadingSave = true;
                                          setState(() {});
                                          try {
                                            if (widget.ponuda != null) {
                                              await _ponudeProvider.update(
                                                  widget.ponuda!.ponudaId,
                                                  request);
                                            } else {
                                              await _ponudeProvider
                                                  .insert(request);
                                            }

                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PonudeListScreen()));
                                            // ignore: empty_catches
                                          } on Exception catch (e) {
                                            isLoadingSave = false;
                                            showDialog(
                                                // ignore: use_build_context_synchronously
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title:
                                                          const Text("Error"),
                                                      content:
                                                          Text(e.toString()),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: const Text(
                                                                "Ok"))
                                                      ],
                                                    ));
                                            setState(() {});
                                          }
                                        }
                                      }, // Define this function to handle the save action
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape:
                                            const CircleBorder(), // Makes the button circular
                                        padding: const EdgeInsets.all(
                                            8), // Adjust padding for icon size // Background color
                                      ),

                                      child: isLoadingSave
                                          ? const CircularProgressIndicator()
                                          : const Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            ), // Save icon inside
                                    )
                                  : Container(),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: widget.ponuda?.stateMachine == "created"
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        isLoadingSave = true;
                                        setState(() {});

                                        await _ponudeProvider
                                            .delete(widget.ponuda!.ponudaId);

                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PonudeListScreen()));
                                      }, // Define this function to handle the save action
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .red, // Makes the button circular
                                        padding: const EdgeInsets.all(
                                            8), // Adjust padding for icon size // Background color
                                      ),

                                      child: isLoadingSave
                                          ? const CircularProgressIndicator()
                                          : const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ), // Save icon inside
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
                        setoviPonudeResult?.result[index] != null &&
                        setoviPonudeResult!
                                .result[index].set!.proizvodiSets.length <=
                            3
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
                  setState(() {
                    isLoading = true;
                  });
                  await _setoviPonudeProvider
                      .delete(setoviPonudeResult!.result[index].setoviPonudeId);
                  initForm();
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
          ListTile(
            title: Text(
                "${setoviPonudeResult?.result[index].set?.proizvodiSets[0].proizvod?.naziv}"),
          ),
          ListTile(
            title: Text(
                "${setoviPonudeResult?.result[index].set?.proizvodiSets[1].proizvod?.naziv}"),
          ),
          ListTile(
            title: Text(
                "${setoviPonudeResult?.result[index].set?.proizvodiSets[2].proizvod?.naziv}"),
          ),
        ],
      ),
    );
  }

  _buildSetPonudeForm() {
    return FormBuilder(
      key: _formKey2,
      initialValue: _initialValue3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
                child: FormBuilderTextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: "Popust"),
              name: "popust",
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderDropdown(
                name: "proizvodId1",
                decoration: const InputDecoration(labelText: "Tlo"),
                items: tlo
                    .map((item) => DropdownMenuItem(
                          value: item.proizvodId.toString(),
                          child: Text(
                              "${item.naziv} (${item.jedinicaMjere?.skracenica})"),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please choose some value';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderDropdown(
                name: "proizvodId2",
                decoration: const InputDecoration(labelText: "Sjeme"),
                items: sjeme
                    .map((item) => DropdownMenuItem(
                          value: item.proizvodId.toString(),
                          child: Text(
                              "${item.naziv} (${item.jedinicaMjere?.skracenica})"),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please choose some value';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderDropdown(
                name: "proizvodId3",
                decoration: const InputDecoration(labelText: "Prihrana"),
                items: prihrana
                    .map((item) => DropdownMenuItem(
                          value: item.proizvodId.toString(),
                          child: Text(
                              "${item.naziv} (${item.jedinicaMjere?.skracenica})"),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please choose some value';
                  }
                  return null;
                },
              ),
            ),
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
                          Map<dynamic, dynamic> requestOne = {
                            'popust': request['popust'] ?? 0,
                            'cijena': 0,
                            'cijenaSaPopustom': 0
                          };
                          request['popust'] = request['popust'] ?? 0;
                          request['cijena'] = 0;
                          request['cijenaSaPopustom'] = 0;

                          isLoadingSave = true;
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
                                if (setPonuda != null) {
                                  Map<dynamic, dynamic> requestThree = {
                                    'proizvodId': request['proizvodId1'],
                                    'setId': set!.setId,
                                    'kolicina': 0
                                  };
                                  Map<dynamic, dynamic> requestFour = {
                                    'proizvodId': request['proizvodId2'],
                                    'setId': set!.setId,
                                    'kolicina': 0
                                  };
                                  Map<dynamic, dynamic> requestFive = {
                                    'proizvodId': request['proizvodId3'],
                                    'setId': set!.setId,
                                    'kolicina': 0
                                  };
                                  await _proizvodiSet.insert(requestThree);
                                  await _proizvodiSet.insert(requestFour);
                                  await _proizvodiSet.insert(requestFive);
                                }
                              }
                            }

                            _formKey2.currentState?.reset();
                            initForm();
                            setState(() {});
                          } on Exception catch (e) {
                            debugPrint(e.toString());
                          }
                        }
                      }, // Define this function to handle the save action
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape:
                            const CircleBorder(), // Makes the button circular
                        padding: const EdgeInsets.all(
                            8), // Adjust padding for icon size // Background color
                      ),

                      child: isLoadingSave
                          ? const CircularProgressIndicator()
                          : const Icon(
                              Icons.add,
                              color: Colors.white,
                            ), // Save icon inside
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
