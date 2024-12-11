import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/main.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';
import 'package:virtualgardens_mobile/screens/home_screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        "Profil");
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      child: const Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(size: 45, color: Colors.white, Icons.person),
            SizedBox(
              width: 10,
            ),
            Text("Detalji o profilu",
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
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(50),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(235, 241, 224, 1),
                                    width: 5)),
                            child: korisnikResult?.slika != null
                                ? imageFromString(_base64Image!)
                                : const Text(""),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(235, 241, 224, 1),
                      borderRadius: BorderRadius.circular(20), // Rounded edges
                    ),
                    child: _buildNewForm(),
                  ),
                )
              ],
            ),
          )),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select an image up to 2 MB in size"),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                          decoration: const InputDecoration(
                              labelText: "Korisničko ime"),
                          name: "korisnickoIme",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FormBuilderTextField(
                          decoration: const InputDecoration(labelText: "Email"),
                          name: "email",
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
                          decoration: const InputDecoration(labelText: "Ime"),
                          name: "ime",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FormBuilderTextField(
                          decoration:
                              const InputDecoration(labelText: "Prezime"),
                          name: "prezime",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          }),
                    ),
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
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        decoration:
                            const InputDecoration(labelText: "Broj telefona"),
                        name: "brojTelefona",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
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
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FormBuilderTextField(
                        decoration: const InputDecoration(labelText: "Država"),
                        name: "drzava",
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
                      child: FormBuilderTextField(
                        decoration:
                            const InputDecoration(labelText: "Nova lozinka"),
                        obscureText: true,
                        name: "lozinka",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FormBuilderTextField(
                          decoration: const InputDecoration(
                              labelText: "Potvrdite lozinku"),
                          obscureText: true,
                          name: "lozinkaPotvrda"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FormBuilderTextField(
                          decoration:
                              const InputDecoration(labelText: "Stara lozinka"),
                          obscureText: true,
                          name: "staraLozinka"),
                    ),
                  ],
                ),
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
                                  isLoadingSave = true;
                                  setState(() {});
                                  try {
                                    await _korisnikProvider.update(
                                        AuthProvider.korisnikId!, request);

                                    if (request['lozinka'].toString().isEmpty) {
                                      // ignore: use_build_context_synchronously
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

                                    // ignore: empty_catches
                                  } on Exception catch (e) {
                                    isLoadingSave = false;
                                    showDialog(
                                        // ignore: use_build_context_synchronously
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
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
