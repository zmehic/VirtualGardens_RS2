import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/models/set.dart';
import 'package:virtualgardens_admin/screens/pitanja_list_screen.dart';

class NarudzbeDetailsScreen extends StatefulWidget {
  final Narudzba? narudzba;
  const NarudzbeDetailsScreen({super.key, this.narudzba});

  @override
  State<NarudzbeDetailsScreen> createState() => _NarudzbeDetailsScreenState();
}

class _NarudzbeDetailsScreenState extends State<NarudzbeDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final int _pageSize = 5;

  Map<String, dynamic> _initialValue = {};

  late NarudzbaProvider _narudzbaProvider;
  late SetoviProvider _setoviProvider;

  SearchResult<Set>? setoviResult;
  List<String>? allowedActions;
  List<Widget> actions = [];
  String? korisnik;

  bool isLoading = true;

  final TextEditingController _datumNarudzbeController =
      TextEditingController();

  final PagingController<int, Set?> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _narudzbaProvider = context.read<NarudzbaProvider>();
    _setoviProvider = context.read<SetoviProvider>();

    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, false);
    });
    initForm();
  }

  Future initForm() async {
    actions.add(widget.narudzba != null
        ? Container(
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PitanjaOdgovoriListScreen(
                          narudzba: widget.narudzba)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(235, 241, 224, 1),
                ),
                child: const Text(
                  "Pitanja",
                  style: TextStyle(
                    color: Color.fromRGBO(32, 76, 56, 1),
                  ),
                )),
          )
        : Container());
    _initialValue = {
      "narudzbaId": widget.narudzba?.narudzbaId,
      "brojNarudzbe": widget.narudzba?.brojNarudzbe,
      "otkazana": widget.narudzba?.otkazana,
      "datum": widget.narudzba?.datum.toIso8601String(),
      "placeno": widget.narudzba?.placeno,
      "status": widget.narudzba?.status,
      "stateMachine": widget.narudzba?.stateMachine,
      "ukupnaCijena": widget.narudzba?.ukupnaCijena,
      "korisnikId": widget.narudzba?.korisnikId,
    };
    await _fetchPage(0, true);
    korisnik = "${widget.narudzba?.korisnik?.korisnickoIme}";
    _datumNarudzbeController.text = widget.narudzba != null
        ? formatDateString(widget.narudzba!.datum.toIso8601String())
        : "";

    allowedActions =
        await _narudzbaProvider.allowedActions(id: widget.narudzba?.narudzbaId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchPage(int pageKey, bool reload) async {
    var filter = {
      'NarudzbaId': widget.narudzba?.narudzbaId,
      'isDeleted': false,
      'IncludeTables': "ProizvodiSets",
      'PageSize': _pageSize,
      'Page': pageKey + 1,
    };

    try {
      setoviResult = await _setoviProvider.get(filter: filter);
      final isLastPage = setoviResult!.result.length < _pageSize;
      if (isLastPage) {
        if (reload == true && _pagingController.itemList != null) {
          _pagingController.itemList!.clear();
        }
        _pagingController.appendLastPage(setoviResult!.result);
      } else {
        if (reload == true && _pagingController.itemList != null) {
          _pagingController.itemList!.clear();
        }
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(setoviResult!.result, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader2(
          isLoading: isLoading,
          isList: false,
          title:
              widget.narudzba != null ? "Detalji o narudžbi" : "Dodaj narudžbu",
          actions: actions,
          child: Column(
            children: [_buildMain()],
          ),
        ),
        "Detalji o narudžbi");
  }

  Widget _buildMain() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color.fromRGBO(32, 76, 56, 1),
              child: Column(children: [
                Expanded(
                  child: _buildResultView(),
                )
              ]),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              color: const Color.fromRGBO(235, 241, 224, 1),
              child: _buildNewForm(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: PagedListView<int, Set?>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Set?>(
            itemBuilder: (context, item, index) {
              return item != null
                  ? _buildExpansionTile(item, index)
                  : Container();
            },
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text(
                "Nema setova",
                style: TextStyle(color: Colors.white),
              ),
            ),
            firstPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ));
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
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Broj narudžbe"),
                  name: "brojNarudzbe",
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "stateMachine",
                  enabled: false,
                  decoration: const InputDecoration(labelText: "Status"),
                  initialValue: _initialValue['stateMachine'] ?? true,
                  items: const [
                    DropdownMenuItem(value: "created", child: Text("Kreirana")),
                    DropdownMenuItem(
                        value: "inprogress", child: Text("U procesu")),
                    DropdownMenuItem(
                        value: "finished", child: Text("Završena")),
                  ],
                  onChanged: (value) {},
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderCheckbox(
                  enabled: false,
                  name: "otkazana",
                  initialValue: _initialValue['otkazana'] ?? true,
                  title: const Text("Otkazana"),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderCheckbox(
                  enabled: false,
                  name: "placeno",
                  initialValue: _initialValue['placeno'] ?? true,
                  title: const Text("Plaćeno"),
                )),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Datum narudžbe"),
                    readOnly: true,
                    controller: _datumNarudzbeController,
                    name: "datum",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Ukupna cijena"),
                    readOnly: true,
                    name: "ukupnaCijena",
                    initialValue: _initialValue['ukupnaCijena'].toString(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Kupac"),
                    readOnly: true,
                    name: "korisnickoIme",
                    initialValue: korisnik ?? "",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                allowedActions != null && allowedActions!.contains("edit")
                    ? SizedBox(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(32, 76, 56, 1)),
                            ),
                            onPressed: () async {
                              try {
                                await _narudzbaProvider.narudzbeState(
                                    action: "edit",
                                    id: widget.narudzba?.narudzbaId);
                                if (mounted) {
                                  await buildSuccessAlert(
                                      context,
                                      "Uspješno ste ažurirali narudžbu",
                                      "Narudžba ${widget.narudzba?.brojNarudzbe} je ažurirana");
                                }
                              } on Exception catch (e) {
                                if (mounted) {
                                  await buildErrorAlert(
                                      context, "Greška", e.toString(), e);
                                }
                              }
                            },
                            child: const Text(
                              "Kreirana",
                              style: TextStyle(color: Colors.white),
                            )))
                    : Container(),
                allowedActions != null && allowedActions!.contains("inprogress")
                    ? const SizedBox(
                        width: 20,
                      )
                    : Container(),
                allowedActions != null && allowedActions!.contains("inprogress")
                    ? SizedBox(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(32, 76, 56, 1))),
                            onPressed: () async {
                              try {
                                await _narudzbaProvider.narudzbeState(
                                    action: "inprogress",
                                    id: widget.narudzba?.narudzbaId);
                                if (mounted) {
                                  await buildSuccessAlert(
                                      context,
                                      "Uspješno ste ažurirali narudžbu",
                                      "Narudžba ${widget.narudzba?.brojNarudzbe} je ažurirana");
                                }
                              } on Exception catch (e) {
                                if (mounted) {
                                  await buildErrorAlert(
                                      context, "Greška", e.toString(), e);
                                }
                              }
                            },
                            child: const Text("U procesu",
                                style: TextStyle(color: Colors.white))))
                    : Container(),
                allowedActions != null && allowedActions!.contains("finish")
                    ? const SizedBox(
                        width: 20,
                      )
                    : Container(),
                allowedActions != null && allowedActions!.contains("finish")
                    ? SizedBox(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(32, 76, 56, 1))),
                            onPressed: () async {
                              try {
                                await _narudzbaProvider.narudzbeState(
                                    action: "finish",
                                    id: widget.narudzba?.narudzbaId);
                                if (mounted) {
                                  await buildSuccessAlert(
                                      context,
                                      "Uspješno ste ažurirali narudžbu",
                                      "Narudžba ${widget.narudzba?.brojNarudzbe} je ažurirana");
                                }
                              } on Exception catch (e) {
                                if (mounted) {
                                  await buildErrorAlert(
                                      context, "Greška", e.toString(), e);
                                }
                              }
                            },
                            child: const Text("Završena",
                                style: TextStyle(color: Colors.white))))
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(Set item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        title: Text(
          "Set ${index + 1} - ${item.cijenaSaPopustom} KM",
          style: const TextStyle(color: Colors.black),
        ),
        textColor: Colors.white,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: item.proizvodiSets.length,
            itemBuilder: (context, i) {
              final proizvodSet = item.proizvodiSets[i];
              final naziv = proizvodSet.proizvod?.naziv ?? "";
              final kolicina = proizvodSet.kolicina;
              final jedinicaMjere =
                  proizvodSet.proizvod?.jedinicaMjere?.skracenica ?? "";
              final cijena = proizvodSet.proizvod?.cijena ?? 0.0;
              final ukupnaCijena = kolicina * cijena;

              return ListTile(
                title: Text(
                  "$naziv x $kolicina $jedinicaMjere = $ukupnaCijena KM",
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
