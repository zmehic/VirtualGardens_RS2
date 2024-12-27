import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  final TextEditingController _birthDateController = TextEditingController();
  File? _profileImage;
  String? _base64Image;

  late KorisnikProvider _korisnikProvider;

  Korisnik? korisnikResult;

  bool isLoading = true;

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

  Widget _buildTextField(String name, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
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
            _birthDateController.text =
                formatDateString(pickedDate.toIso8601String());
            _initialValue['datumRodjenja'] = pickedDate.toIso8601String();
          }
        },
      ),
    );
  }

  Widget _buildPasswordTextField(String name, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormBuilderTextField(
        obscureText: true,
        name: name,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        _buildPasswordTextField("lozinka", "Nova lozinka"),
        _buildPasswordTextField("lozinkaPotvrda", "Potvrdite lozinku"),
        _buildPasswordTextField("staraLozinka", "Stara lozinka"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader(
        isLoading: isLoading,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: const Color.fromRGBO(235, 241, 224, 1),
          child: SingleChildScrollView(
            child: Column(
              children: [body()],
            ),
          ),
        ),
      ),
      "Profile",
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          initialValue: _initialValue,
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(32, 76, 56, 1),
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
              _buildTextField("korisnickoIme", "Username"),
              _buildTextField("email", "Email"),
              _buildTextField("ime", "First Name"),
              _buildTextField("prezime", "Last Name"),
              _buildDateField("datumRodjenja", "Birth Date"),
              _buildTextField("brojTelefona", "Phone"),
              _buildTextField("adresa", "Address"),
              _buildTextField("grad", "City"),
              _buildTextField("drzava", "Country"),
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
                      if (request['lozinka'].toString().isEmpty ||
                          (request['lozinka'].toString().isEmpty == false &&
                              request['staraLozinka'].toString().isEmpty ==
                                  false &&
                              request['lozinkaPotvrda'].toString().isEmpty ==
                                  false &&
                              request['lozinka'].toString().isEmpty ==
                                  request['lozinkaPotvrda']
                                      .toString()
                                      .isEmpty)) {
                        await _korisnikProvider.update(
                            AuthProvider.korisnikId!, request);

                        if (request['lozinka'].toString().isEmpty) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }
                      } else {
                        showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Error"),
                                  content: Text("Molimo provjerite unos"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Ok"))
                                  ],
                                ));
                        setState(() {});
                      }

                      // ignore: empty_catches
                    } on Exception catch (e) {
                      showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Error"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Ok"))
                                ],
                              ));
                      setState(() {});
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(32, 76, 56, 1),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
