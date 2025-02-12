import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/main.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';
import 'package:virtualgardens_mobile/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _initialValue = {};
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: chooseAnImage,
                        child: CircleAvatar(
                          backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                          radius: 60,
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
                    const SizedBox(height: 20),
                    buildFormBuilderTextField(
                        name: "korisnickoIme",
                        label: "Korisničko ime",
                        isRequired: true,
                        minLength: 3,
                        maxLength: 50,
                        match: r'^\S+$',
                        matchErrorText:
                            "Korisničko ime ne smije sadržavati razmake."),
                    const SizedBox(height: 10),
                    buildFormBuilderTextField(
                        name: "email",
                        label: "Email",
                        isEmail: true,
                        isRequired: true,
                        maxLength: 100),
                    const SizedBox(height: 10),
                    buildFormBuilderTextField(
                        name: "ime",
                        label: "Ime",
                        isRequired: true,
                        minLength: 3,
                        maxLength: 50,
                        match: r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                        matchErrorText: "Ime može sadržavati samo slova."),
                    const SizedBox(height: 10),
                    buildFormBuilderTextField(
                        name: "prezime",
                        label: "Prezime",
                        minLength: 3,
                        maxLength: 50,
                        isRequired: true,
                        match: r'^[a-zA-ZčćžšđČĆŽŠĐ]+$',
                        matchErrorText: "Prezime može sadržavati samo slova."),
                    const SizedBox(height: 10),
                    _buildDateField("datumRodjenja", "Datum rođenja"),
                    const SizedBox(height: 10),
                    buildFormBuilderTextField(
                      maxLength: 12,
                      name: "brojTelefona",
                      label: "Broj telefona",
                      match: r'^(?:\+387[0-9]{2}[0-9]{6}|06[0-9]{7})$',
                      matchErrorText:
                          "Unesite ispravan broj mobitela \n(npr. +38761234567 ili 061234567).",
                    ),
                    const SizedBox(height: 10),
                    buildFormBuilderTextField(
                      maxLength: 255,
                      name: "adresa",
                      label: "Adresa",
                      isValidated: false,
                    ),
                    const SizedBox(height: 10),
                    buildFormBuilderTextField(
                        maxLength: 100,
                        name: "grad",
                        label: "Grad",
                        match: r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                        matchErrorText: "Grad može sadržavati samo slova."),
                    const SizedBox(height: 10),
                    buildFormBuilderTextField(
                        maxLength: 100,
                        name: "drzava",
                        label: "Država",
                        match: r'^[a-zA-ZčćžšđČĆŽŠĐ ]+$',
                        matchErrorText: "Država može sadržavati samo slova."),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
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
                            if (changePassword == false ||
                                (changePassword == true &&
                                    request.containsKey('lozinka') == true &&
                                    request.containsKey('staraLozinka') ==
                                        true &&
                                    request.containsKey('lozinkaPotvrda') ==
                                        true)) {
                              var response = await _korisnikProvider.update(
                                  AuthProvider.korisnikId!, request);

                              AuthProvider.username = response.korisnickoIme;
                              AuthProvider.korisnikId = response.korisnikId;

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
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen()));
                                    } else {
                                      Navigator.of(context).pushReplacement(
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
              lastDate: DateTime.now());
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
          buildFormBuilderTextField(
            name: "lozinka",
            label: "Nova lozinka",
            isRequired: true,
            maxLength: 50,
            minLength: 8,
            match:
                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
            matchErrorText:
                "Lozinka mora sadržavati velika slova,\nmala slova, brojeve \ni specijalne znakove.",
            obscureText: true,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FormBuilderTextField(
                  decoration:
                      const InputDecoration(labelText: "Potvrdite lozinku"),
                  obscureText: true,
                  name: "lozinkaPotvrda",
                  maxLength: 50,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Potvrda lozinke je obavezno."),
                    (value) {
                      if (value !=
                          _formKey.currentState?.fields['lozinka']?.value) {
                        return "Potvrda lozinke se ne poklapa s \nnovom lozinkom.";
                      }
                      return null;
                    }
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          buildFormBuilderTextField(
            maxLength: 50,
            name: "staraLozinka",
            label: "Stara lozinka",
            isRequired: true,
            obscureText: true,
          ),
        ],
      ),
    );
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
        _base64Image = null;
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
      _base64Image = image.toString();
    }
    setState(() {});
  }
}
