import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/jedinice_mjere_provider.dart';
import 'package:virtualgardens_admin/providers/korisnik_provider.dart';
import 'package:virtualgardens_admin/providers/nalozi_provider.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/pitanja_odgovori_provider.dart';
import 'package:virtualgardens_admin/providers/ponude_provider.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/recenzije_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_ponude_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_proizvodi_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_provider.dart';
import 'package:virtualgardens_admin/providers/ulazi_proizvodi_provider.dart';
import 'package:virtualgardens_admin/providers/ulazi_provider.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_admin/providers/zaposlenici_provider.dart';
import 'package:virtualgardens_admin/screens/home_screen.dart';
import 'package:window_manager/window_manager.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMinimumSize(const Size(1000, 600));
    await windowManager.maximize();
  });

  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => JediniceMjereProvider()),
      ChangeNotifierProvider(create: (_) => VrsteProizvodaProvider()),
      ChangeNotifierProvider(create: (_) => KorisnikProvider()),
      ChangeNotifierProvider(create: (_) => NarudzbaProvider()),
      ChangeNotifierProvider(create: (_) => UlaziProvider()),
      ChangeNotifierProvider(create: (_) => UlaziProizvodiProvider()),
      ChangeNotifierProvider(create: (_) => ZaposlenikProvider()),
      ChangeNotifierProvider(create: (_) => NaloziProvider()),
      ChangeNotifierProvider(create: (_) => SetoviProvider()),
      ChangeNotifierProvider(create: (_) => SetoviPonudeProvider()),
      ChangeNotifierProvider(create: (_) => PonudeProvider()),
      ChangeNotifierProvider(create: (_) => SetProizvodProvider()),
      ChangeNotifierProvider(create: (_) => PitanjaOdgovoriProvider()),
      ChangeNotifierProvider(create: (_) => RecenzijeProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.lightGreen.shade800),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
      ),
      body: Center(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _buildForm(context))),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 100,
            width: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderTextField(
            maxLength: 50,
            name: "username",
            controller: _usernameController,
            decoration: const InputDecoration(
                labelText: "Username", prefixIcon: Icon(Icons.person)),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: "Korisničko ime je obavezno."),
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderTextField(
            maxLength: 50,
            name: "password",
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                labelText: "Password", prefixIcon: Icon(Icons.password)),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "Lozinka je obavezna."),
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.saveAndValidate() == true) {
                  KorisnikProvider provider = KorisnikProvider();
                  debugPrint("Login attempt");
                  AuthProvider.username = _usernameController.text;
                  AuthProvider.password = _passwordController.text;
                  try {
                    await provider.login(
                        username: AuthProvider.username,
                        password: AuthProvider.password);
                    _usernameController.clear();
                    _passwordController.clear();
                    if (context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    }
                  } on Exception catch (e) {
                    if (context.mounted) {
                      await buildErrorAlert(
                          context, "Greška prilikom prijave", e.toString(), e);
                    }
                    _usernameController.clear();
                    _passwordController.clear();
                  }
                }
              },
              child: const Text("Login"))
        ],
      ),
    );
  }
}
