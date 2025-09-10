import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/main.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/models/izazov.dart';
import 'package:virtualgardens_mobile/models/izazov_kategorija.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/izazov_provider.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';
import 'package:virtualgardens_mobile/screens/frmChallenges14072025.dart';
import 'package:virtualgardens_mobile/screens/home_screen.dart';

class ChallengesDetailsSceen extends StatefulWidget {
  const ChallengesDetailsSceen({super.key});

  @override
  State<ChallengesDetailsSceen> createState() => _ChallengesDetailsSceenState();
}

class _ChallengesDetailsSceenState extends State<ChallengesDetailsSceen> {
  Map<String, dynamic> _initialValue = {};
  bool isLoading = true;

  late IzazovProvider _izazovProvider;
  late KorisnikProvider _korisnikProvider;
  List<IzazovKategorija>? kategorije;
  SearchResult<Korisnik>? korisnici;

  final TextEditingController _birthDateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKeyProfile =
      GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _korisnikProvider = context.read<KorisnikProvider>();
    _izazovProvider = context.read<IzazovProvider>();
    super.initState();
    initForm();
  }

  Future initForm() async {
    kategorije = await _izazovProvider.getKategorije();
    korisnici = await _korisnikProvider.get();

    _initialValue = {
      'korisnikIzazvaniId': null,
      'izazovId': null,
      'poruka': "",
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
          key: _scaffoldKeyProfile,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[Container()],
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Izazov",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        color: const Color.fromRGBO(235, 241, 224, 1),
                        child: body(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      "Izazov",
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: FormBuilder(
              key: _formKey,
              initialValue: _initialValue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FormBuilderDropdown(
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Obavezno polje")
                        ]),
                        name: "korisnikIzazvaniId",
                        items: korisnici?.result
                                .map((e) => DropdownMenuItem(
                                    value: e.korisnikId,
                                    child: Text(e.korisnickoIme)))
                                .toList() ??
                            []),
                    FormBuilderDropdown(
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Obavezno polje")
                        ]),
                        name: "izazovId",
                        items: kategorije
                                ?.map((e) => DropdownMenuItem(
                                    value: e.id, child: Text(e.naziv)))
                                .toList() ??
                            []),
                    const SizedBox(height: 20),
                    FormBuilderTextField(name: "poruka"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() == true) {
                          debugPrint(_formKey.currentState?.value.toString());

                          var request = Map.from(_formKey.currentState!.value);
                          request['datumKreiranja'] =
                              DateTime.now().toIso8601String();
                          request['korisnikIzazivacId'] =
                              AuthProvider.korisnikId ?? 0;
                          request['status'] = 0;
                          setState(() {});

                          try {
                            // var duplicate =
                            //     _izazovProvider.duplicate(request: request);

                            // if (duplicate == true) {
                            //   if (mounted) {
                            //     QuickAlert.show(
                            //       context: context,
                            //       type: QuickAlertType.error,
                            //       title: "Taj izazov vec postoji",
                            //       confirmBtnText: "U redu",
                            //       text: "Taj izazov vec postoji",
                            //       onConfirmBtnTap: () {
                            //         Navigator.of(context).pushReplacement(
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     ChallengesListScreen()));
                            //       },
                            //     );
                            //   }
                            // }
                            var response =
                                await _izazovProvider.insertIzazov(request);

                            if (mounted) {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                title: "Uspješno ste poslali zahtjev za izazov",
                                confirmBtnText: "U redu",
                                text: "Zahtjev za izazov poslan",
                                onConfirmBtnTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChallengesListScreen()));
                                },
                              );
                            }
                          } on Exception catch (e) {
                            if (mounted) {
                              await buildErrorAlert(
                                  context,
                                  "Greška prilikom ažuriranja",
                                  e.toString(),
                                  e);
                            }
                            setState(() {});
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                      ),
                      child: const Icon(Icons.save, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
