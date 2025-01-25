import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/main.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';
import 'package:virtualgardens_mobile/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _initialValue = {};

  File? _profileImage;
  String? _base64Image;

  bool changePassword = false;
  bool isLoading = true;

  late KorisnikProvider _korisnikProvider;
  Korisnik? korisnikResult;

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

    _birthDateController.text = korisnikResult != null
        ? formatDateString(
            korisnikResult!.datumRodjenja?.toIso8601String() ?? "")
        : "";
    _base64Image = korisnikResult?.slika;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      final selectedImage = File(result.files.single.path!);
      final fileSizeInBytes = await selectedImage.length();
      final fileSizeInMb = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMb > 2) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select an image up to 2 MB in size"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          _profileImage = selectedImage;
          _base64Image = base64Encode(selectedImage.readAsBytesSync());
        });
      }
    }
  }

  Widget _buildDateField(String name, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormBuilderTextField(
        controller: _birthDateController,
        decoration: const InputDecoration(labelText: "Datum rođenja"),
        name: "datumRodjenja",
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: "Datum rođenja je obavezan."),
        ]),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(2101));
          if (pickedDate != null) {
            _birthDateController.text =
                formatDateString(pickedDate.toIso8601String());
            _initialValue['datumRodjenja'] = pickedDate.toIso8601String();
          }
        },
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Visibility(
      visible: changePassword,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FormBuilderTextField(
              obscureText: true,
              name: "lozinka",
              decoration: const InputDecoration(labelText: "Nova lozinka"),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "Nova lozinka je obavezna."),
                FormBuilderValidators.minLength(8,
                    errorText: "Lozinka mora imati najmanje 8 znakova."),
                FormBuilderValidators.match(
                    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                    errorText:
                        "Lozinka mora sadržavati velika slova, mala slova, brojeve \n i specijalne znakove.")
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FormBuilderTextField(
              obscureText: true,
              name: "lozinkaPotvrda",
              decoration: const InputDecoration(labelText: "Potvrdite lozinku"),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "Potvrda lozinke je obavezna."),
                (value) {
                  if (value !=
                      _formKey.currentState?.fields['lozinka']?.value) {
                    return "Potvrda lozinke se ne poklapa s novom lozinkom.";
                  }
                  return null;
                }
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FormBuilderTextField(
              obscureText: true,
              name: "staraLozinka",
              decoration: const InputDecoration(labelText: "Stara lozinka"),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "Stara lozinka je obavezna."),
              ]),
            ),
          )
        ],
      ),
    );
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
            title: const Text(
              "Profil",
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
                            horizontal: 20, vertical: 10),
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
      "Profil",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FormBuilderTextField(
                      name: "korisnickoIme",
                      decoration:
                          const InputDecoration(labelText: "Korisničko ime"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Korisničko ime je obavezno."),
                        FormBuilderValidators.minLength(3,
                            errorText:
                                "Korisničko ime mora imati najmanje 3 slova."),
                        FormBuilderValidators.match(r'^\S+$',
                            errorText:
                                "Korisničko ime ne smije sadržavati razmake.")
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FormBuilderTextField(
                      name: "email",
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Email je obavezan."),
                        FormBuilderValidators.email(
                            errorText: "Unesite ispravnu email adresu.")
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FormBuilderTextField(
                      name: "ime",
                      decoration: const InputDecoration(labelText: "Ime"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Ime je obavezno."),
                        FormBuilderValidators.match(r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                            errorText: "Ime može sadržavati samo slova.")
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FormBuilderTextField(
                        name: "prezime",
                        decoration: const InputDecoration(labelText: "Prezime"),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Prezime je obavezno."),
                          FormBuilderValidators.match(r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                              errorText: "Prezime može sadržavati samo slova.")
                        ])),
                  ),
                  _buildDateField("datumRodjenja", "Datum rođenja"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FormBuilderTextField(
                      name: "brojTelefona",
                      decoration:
                          const InputDecoration(labelText: "Broj telefona"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(
                            r'^(?:\+387[0-9]{2}[0-9]{6}|06[0-9]{7})$',
                            errorText:
                                "Unesite ispravan broj mobitela (npr. +38761234567).")
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FormBuilderTextField(
                      name: "adresa",
                      decoration: const InputDecoration(labelText: "Adresa"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FormBuilderTextField(
                      name: "grad",
                      decoration: const InputDecoration(labelText: "Grad"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                            errorText: "Grad može sadržavati samo slova.")
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FormBuilderTextField(
                      name: "drzava",
                      decoration: const InputDecoration(labelText: "Država"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                            errorText: "Država može sadržavati samo slova.")
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Želite li promijeniti lozinku?"),
                        Checkbox(
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
                  _buildPasswordFields(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() == true) {
                        debugPrint(_formKey.currentState?.value.toString());

                        var request = Map.from(_formKey.currentState!.value);
                        request['slika'] = _base64Image;
                        var key = request.entries.elementAt(4).key;
                        request[key] = _initialValue['datumRodjenja'];
                        setState(() {});

                        try {
                          if (request.containsKey('lozinka') == false ||
                              (request.containsKey('lozinka') == true &&
                                  request.containsKey('staraLozinka') == true &&
                                  request.containsKey('lozinkaPotvrda') ==
                                      true &&
                                  request.containsKey('lozinka') ==
                                      request.containsKey('lozinkaPotvrda'))) {
                            try {
                              var response = await _korisnikProvider.update(
                                  AuthProvider.korisnikId!, request);

                              AuthProvider.username = response.korisnickoIme;
                              AuthProvider.korisnikId = response.korisnikId;

                              QuickAlert.show(
                                // ignore: use_build_context_synchronously
                                context: context,
                                type: QuickAlertType.success,
                                title:
                                    "Uspješno ste ažurirali podatke o vašem profilu",
                                confirmBtnText: "U redu",
                                text:
                                    "Ukoliko ste mijenjali lozinku, potrebno je da se ponovo prijavite na sistem!",
                                onConfirmBtnTap: () {
                                  if (request.containsKey('lozinka') == false) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()));
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  }
                                },
                              );
                            } on Exception {
                              QuickAlert.show(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: "Greška prilikom ažuriranja profila",
                                  confirmBtnText: "U redu",
                                  text:
                                      "Molimo Vas kontaktirajte korisničku podršku");
                            }
                          } else {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: "Greška prilikom ažuriranja profila",
                                confirmBtnText: "U redu",
                                text:
                                    "Molimo Vas kontaktirajte korisničku podršku");
                            setState(() {});
                          }
                        } on Exception catch (e) {
                          QuickAlert.show(
                              // ignore: use_build_context_synchronously
                              context: context,
                              type: QuickAlertType.error,
                              title: "Greška prilikom ažuriranja",
                              text: (e.toString().split(': '))[1],
                              confirmBtnText: "U redu");

                          setState(() {});
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "Spasi promjene",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
