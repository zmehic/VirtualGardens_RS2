import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_mobile/main.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';

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
  String? base64Image;

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

    base64Image = korisnikResult?.slika;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.lightGreen.shade800),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: SingleChildScrollView(
            child: _buildMainContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/backgroundregister.png"),
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
                            image: AssetImage("assets/images/logo.png"))),
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
              buildFormBuilderTextField(
                  label: "Korisničko ime",
                  name: "korisnickoIme",
                  isRequired: true,
                  minLength: 3,
                  match: r'^\S+$',
                  matchErrorText:
                      "Korisničko ime ne smije sadržavati razmake."),
              const SizedBox(height: 15),
              buildFormBuilderTextField(
                label: "Email",
                name: "email",
                isEmail: true,
                isRequired: true,
              ),
              const SizedBox(height: 15),
              buildFormBuilderTextField(
                  label: "Ime",
                  name: "ime",
                  isRequired: true,
                  match: r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                  matchErrorText: "Ime može sadržavati samo slova."),
              const SizedBox(
                height: 15,
              ),
              buildFormBuilderTextField(
                  label: "Prezime",
                  name: "prezime",
                  isRequired: true,
                  match: r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                  matchErrorText: "Prezime može sadržavati samo slova."),
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
              buildFormBuilderTextField(
                label: "Broj telefona",
                name: "brojTelefona",
                match: r'^(?:\+387[0-9]{2}[0-9]{6}|06[0-9]{7})$',
                matchErrorText:
                    "Unesite ispravan broj mobitela (npr. +38761234567).",
              ),
              const SizedBox(height: 15),
              buildFormBuilderTextField(
                label: "Adresa",
                name: "adresa",
                isValidated: false,
              ),
              const SizedBox(
                height: 15,
              ),
              buildFormBuilderTextField(
                  label: "Grad",
                  name: "grad",
                  match: r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                  matchErrorText: "Grad može sadržavati samo slova."),
              const SizedBox(
                height: 15,
              ),
              buildFormBuilderTextField(
                  label: "Država",
                  name: "drzava",
                  match: r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                  matchErrorText: "Država može sadržavati samo slova."),
              const SizedBox(
                height: 15,
              ),
              buildFormBuilderTextField(
                  label: "Nova lozinka",
                  name: "lozinka",
                  isRequired: true,
                  minLength: 8,
                  match: r"",
                  matchErrorText:
                      "Lozinka mora sadržavati velika slova, mala slova, brojeve \n i specijalne znakove.",
                  obscureText: true),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration:
                          const InputDecoration(labelText: "Potvrdite lozinku"),
                      obscureText: true,
                      name: "lozinkaPotvrda",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Potvrda lozinke je obavezno."),
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
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
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
                            onTap: chooseAnImage,
                          ),
                        );
                      },
                    ),
                  ),
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
                              padding: const EdgeInsets.all(8),
                            ),
                            child: isLoadingSave
                                ? const CircularProgressIndicator()
                                : const Icon(
                                    Icons.keyboard_return,
                                    color: Colors.white,
                                  ),
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
                                var request =
                                    Map.from(_formKey.currentState!.value);
                                request['slika'] = base64Image;
                                var key = request.entries.elementAt(4).key;
                                request[key] = _initialValue['datumRodjenja'];
                                setState(() {});
                                isLoading = true;
                                try {
                                  await _korisnikProvider.insert(request);
                                  if (mounted) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  }
                                } on Exception catch (e) {
                                  isLoading = false;
                                  if (mounted) {
                                    QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        title: "Greška",
                                        text: e.toString());
                                  }
                                  setState(() {});
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.all(8),
                            ),
                            child: isLoadingSave
                                ? const CircularProgressIndicator()
                                : const Icon(
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
            ],
          ),
        ));
  }

  void chooseAnImage() async {
    var image = await getImage();
    if (image == null) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: "Informacija",
          text: "Niste odabrali sliku ili ona premašuje veličinu od 2 MB.",
          confirmBtnText: "U redu",
        );
        base64Image = null;
      }
    } else {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Slika uspješno dodana",
          text: "Uspješno ste odabrali sliku.",
          confirmBtnText: "U redu",
        );
      }
      base64Image = image.toString();
    }
    setState(() {});
  }
}
