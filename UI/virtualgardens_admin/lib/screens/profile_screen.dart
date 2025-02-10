import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/main.dart';
import 'package:virtualgardens_admin/models/korisnici.dart';
import 'package:virtualgardens_admin/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/korisnik_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late KorisnikProvider _korisnikProvider;
  Korisnik? korisnikResult;
  String? _base64Image;

  bool isLoading = true;
  bool changePassword = false;

  final TextEditingController _datumRodjenjaController =
      TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _korisnikProvider = context.read<KorisnikProvider>();
    super.initState();
    initForm();
  }

  Future initForm() async {
    korisnikResult = await _korisnikProvider.getById(AuthProvider.korisnikId!);
    _initialValue = {
      'korisnickoIme': korisnikResult?.korisnickoIme,
      'lozinka': "",
      'lozinkaPotvrda': "",
      'staraLozinka': "",
      'email': korisnikResult?.email,
      'ime': korisnikResult?.ime,
      'prezime': korisnikResult?.prezime,
      'brojTelefona': korisnikResult?.brojTelefona,
      'adresa': korisnikResult?.adresa,
      'grad': korisnikResult?.grad,
      'drzava': korisnikResult?.drzava,
      'datumRodjenja': korisnikResult?.datumRodjenja!.toIso8601String(),
    };

    _datumRodjenjaController.text = korisnikResult != null
        ? formatDateString(
            korisnikResult!.datumRodjenja?.toIso8601String() ?? "")
        : "";
    _base64Image = korisnikResult?.slika;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader2(
        isList: true,
        title: "Detalji o profilu",
        actions: <Widget>[Container()],
        isLoading: isLoading,
        child: _buildMain(),
      ),
      "Profil",
    );
  }

  Widget _buildMain() {
    return Column(
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(103, 122, 105, 1),
          ),
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Row(
              children: [
                _buildProfileImage(),
                _buildProfileInformation(),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildProfileInformation() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(32, 76, 56, 1),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: _buildNewForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              width: 520,
              height: 520,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 5,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                radius: 260,
                backgroundImage: _base64Image != null
                    ? imageFromString(_base64Image!).image
                    : null,
                child: _base64Image == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(235, 241, 224, 1),
                border: Border.all(color: Colors.brown.shade300, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Osnovne informacije",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildFormBuilderTextField(
                          name: "korisnickoIme",
                          label: "Korisničko ime",
                          isRequired: true,
                          minLength: 3,
                          maxLength: 32,
                          match: r'^\S+$',
                          matchErrorText:
                              "Korisničko ime ne smije sadržavati razmake."),
                      const SizedBox(width: 10),
                      buildFormBuilderTextField(
                        name: "email",
                        label: "Email",
                        maxLength: 50,
                        isEmail: true,
                        isRequired: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildFormBuilderTextField(
                          name: "ime",
                          label: "Ime",
                          isRequired: true,
                          maxLength: 32,
                          match: r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                          matchErrorText: "Ime može sadržavati samo slova."),
                      const SizedBox(
                        width: 10,
                      ),
                      buildFormBuilderTextField(
                          name: "prezime",
                          label: "Prezime",
                          maxLength: 32,
                          isRequired: true,
                          match: r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                          matchErrorText:
                              "Prezime može sadržavati samo slova."),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose some value';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              _datumRodjenjaController.text = formatDateString(
                                  pickedDate.toIso8601String());
                              _initialValue['datumRodjenja'] =
                                  pickedDate.toIso8601String();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 241, 224, 1),
                  border: Border.all(color: Colors.brown.shade300, width: 2)),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Dodatne informacije",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      buildFormBuilderTextField(
                        name: "brojTelefona",
                        maxLength: 12,
                        label: "Broj telefona",
                        match: r'^(?:\+387[0-9]{2}[0-9]{6}|06[0-9]{7})$',
                        matchErrorText:
                            "Unesite ispravan broj mobitela \n(npr. +38761234567 ili 061234567).",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      buildFormBuilderTextField(
                        name: "adresa",
                        maxLength: 32,
                        label: "Adresa",
                        isValidated: false,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      buildFormBuilderTextField(
                          name: "grad",
                          label: "Grad",
                          maxLength: 32,
                          match: r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                          matchErrorText: "Grad može sadržavati samo slova."),
                      const SizedBox(
                        width: 10,
                      ),
                      buildFormBuilderTextField(
                          name: "drzava",
                          label: "Država",
                          maxLength: 32,
                          match: r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                          matchErrorText: "Država može sadržavati samo slova."),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Želite li promijeniti lozinku?",
                    style: TextStyle(color: Colors.white),
                  ),
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        } else if (states.contains(MaterialState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      },
                    ),
                    value: changePassword,
                    onChanged: (value) {
                      setState(() {
                        changePassword = value!;
                        _formKey.currentState
                            ?.setInternalFieldValue('lozinka', "");
                      });
                    },
                    semanticLabel: "Promjeni lozinku",
                  ),
                ],
              ),
            ),
            changePassword == true
                ? Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 5, top: 5),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(235, 241, 224, 1),
                        border:
                            Border.all(color: Colors.brown.shade300, width: 2)),
                    child: _buildPasswordFields())
                : Container(),
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 241, 224, 1),
                  border: Border.all(color: Colors.brown.shade300, width: 2)),
              margin:
                  const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: FormBuilderField(
                      name: "imageId",
                      builder: (field) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                              labelText: "Profilna fotografija"),
                          child: InkWell(
                            onTap: () async {
                              _base64Image = await chooseAnImage(context);
                              setState(() {});
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.image, size: 24),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                        "Odaberite profilnu fotografiju (do 2 MB)"),
                                  ),
                                  Icon(Icons.file_upload),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                request['slika'] = _base64Image;
                                var key = request.entries.elementAt(4).key;
                                request[key] = _initialValue['datumRodjenja'];
                                try {
                                  if (changePassword == false ||
                                      (changePassword == true &&
                                          request.containsKey('lozinka') ==
                                              true &&
                                          request.containsKey('staraLozinka') ==
                                              true &&
                                          request.containsKey(
                                                  'lozinkaPotvrda') ==
                                              true)) {
                                    var response =
                                        await _korisnikProvider.update(
                                            AuthProvider.korisnikId!, request);
                                    AuthProvider.korisnikId =
                                        response.korisnikId;
                                    AuthProvider.username =
                                        response.korisnickoIme;

                                    if (mounted) {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        title:
                                            "Uspješno ste ažurirali podatke o vašem profilu",
                                        confirmBtnText: "U redu",
                                        text:
                                            "Ukoliko ste mijenjali lozinku, potrebno je da se ponovo prijavite na sistem!",
                                        onConfirmBtnTap: () {
                                          if (changePassword == false) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomeScreen()));
                                          } else {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()));
                                          }
                                        },
                                      );
                                    }
                                  }
                                } on Exception catch (e) {
                                  if (mounted) {
                                    await buildErrorAlert(
                                        context, "Greška", e.toString(), e);
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
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  Widget _buildPasswordFields() {
    return Visibility(
      visible: changePassword,
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                "Promjena lozinke",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              buildFormBuilderTextField(
                name: "lozinka",
                label: "Nova lozinka",
                isRequired: true,
                minLength: 8,
                maxLength: 32,
                match:
                    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                matchErrorText:
                    "Lozinka mora sadržavati velika \nslova, mala slova, brojeve \ni specijalne znakove.",
                obscureText: true,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  decoration:
                      const InputDecoration(labelText: "Potvrdite lozinku"),
                  obscureText: true,
                  maxLength: 32,
                  name: "lozinkaPotvrda",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Potvrda lozinke je obavezno."),
                    (value) {
                      if (value !=
                          _formKey.currentState?.fields['lozinka']?.value) {
                        return "Potvrda lozinke se ne \npoklapa s novom lozinkom.";
                      }
                      return null;
                    }
                  ]),
                ),
              ),
              const SizedBox(width: 10),
              buildFormBuilderTextField(
                maxLength: 32,
                name: "staraLozinka",
                label: "Stara lozinka",
                isRequired: true,
                obscureText: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
