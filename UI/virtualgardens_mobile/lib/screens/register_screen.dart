import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/main.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late KorisnikProvider _korisnikProvider;

  Korisnik? korisnikResult;

  bool isLoading = true;
  bool isLoadingSave = false;

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
    setState(() {
      isLoading = false;
    });
    initForm();
  }

  Future initForm() async {
    _initialValue = {
      'korisnickoIme': korisnikResult?.korisnickoIme,
      'lozinka': "",
      'lozinkaPotvrda': "",
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.lightGreen.shade800),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/backgroundregister.png"),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: [
                      Positioned(
                          height: 250,
                          left: 60,
                          top: 4,
                          width: 300,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/logo.png"))),
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Center(
                    child: Text(
                      "Registracija",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                _buildNewForm()
              ],
            ),
          ),
        ),
      ),
    );
  }

  File? _image;
  String? _base64Image;

  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);

      int fileSizeInBytes = await _image!.length();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMb > 2) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Molimo vas odaberite fotografiju veličine do 2 MB"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        _base64Image = base64Encode(await _image!.readAsBytes());
        setState(() {});
      }
    }
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
                            const InputDecoration(labelText: "Korisničko ime"),
                        name: "korisnickoIme",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Korisničko ime je obavezno."),
                          FormBuilderValidators.minLength(3,
                              errorText:
                                  "Korisničko ime mora imati najmanje 3 slova."),
                          FormBuilderValidators.match(r'^\S+$',
                              errorText:
                                  "Korisničko ime ne smije sadržavati razmake.")
                        ])),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                        decoration: const InputDecoration(labelText: "Email"),
                        name: "email",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Email je obavezan."),
                          FormBuilderValidators.email(
                              errorText: "Unesite ispravnu email adresu.")
                        ])),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                        decoration: const InputDecoration(labelText: "Ime"),
                        name: "ime",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Ime je obavezno."),
                          FormBuilderValidators.match(r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                              errorText: "Ime može sadržavati samo slova.")
                        ])),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: FormBuilderTextField(
                      decoration: const InputDecoration(labelText: "Prezime"),
                      name: "prezime",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Prezime je obavezno."),
                        FormBuilderValidators.match(r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                            errorText: "Prezime može sadržavati samo slova.")
                      ])),
                ),
              ]),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      controller: _datumRodjenjaController,
                      decoration:
                          const InputDecoration(labelText: "Datum rođenja"),
                      name: "datumRodjenja",
                      readOnly: true,
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration:
                          const InputDecoration(labelText: "Broj telefona"),
                      name: "brojTelefona",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(
                            r'^(?:\+387[0-9]{2}[0-9]{6}|06[0-9]{7})$',
                            errorText:
                                "Unesite ispravan broj mobitela (npr. +38761234567).")
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: const InputDecoration(labelText: "Adresa"),
                      name: "adresa",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                        decoration: const InputDecoration(labelText: "Grad"),
                        name: "grad",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.match(r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                              errorText: "Grad može sadržavati samo slova.")
                        ])),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: FormBuilderTextField(
                      decoration: const InputDecoration(labelText: "Država"),
                      name: "drzava",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                            errorText: "Država može sadržavati samo slova.")
                      ])),
                ),
              ]),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                        decoration:
                            const InputDecoration(labelText: "Nova lozinka"),
                        obscureText: true,
                        name: "lozinka",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Nova lozinka je obavezna."),
                          FormBuilderValidators.minLength(8,
                              errorText:
                                  "Lozinka mora imati najmanje 8 znakova."),
                          FormBuilderValidators.match(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                              errorText:
                                  "Lozinka mora sadržavati velika slova, mala slova, brojeve \n i specijalne znakove.")
                        ])),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: FormBuilderTextField(
                      decoration:
                          const InputDecoration(labelText: "Potvrdite lozinku"),
                      obscureText: true,
                      name: "lozinkaPotvrda",
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
                      ])),
                ),
              ]),
              const SizedBox(height: 15),
              Row(
                children: [
                  // Expanded widget for the image upload, taking up half of the width
                  Expanded(
                    child: FormBuilderField(
                      name: "imageId",
                      builder: (field) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                              labelText: "Choose an input image"),
                          child: ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text("Select an image"),
                            trailing: const Icon(Icons.file_upload),
                            onTap: getImage,
                          ),
                        );
                      },
                    ),
                  ),
                  // Expanded widget for the save button, taking up the other half of the width
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              } on Exception catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.all(
                                  8), // Adjust padding for icon size // Background color
                            ),

                            child: isLoadingSave
                                ? const CircularProgressIndicator()
                                : const Icon(
                                    Icons.keyboard_return,
                                    color: Colors.white,
                                  ), // Save icon inside
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
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
                                isLoadingSave = true;
                                setState(() {});
                                try {
                                  await _korisnikProvider.insert(request);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                  // ignore: empty_catches
                                } on Exception catch (e) {
                                  isLoadingSave = false;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Error"),
                                            content: Text(e.toString()),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("Ok"))
                                            ],
                                          ));
                                  setState(() {});
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.all(
                                  8), // Adjust padding for icon size // Background color
                            ),

                            child: isLoadingSave
                                ? const CircularProgressIndicator()
                                : const Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ), // Save icon inside
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
