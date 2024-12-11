import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/providers/auth_provider.dart';
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
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

  // This widget is the root of your application.
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
        title: const Text("Login"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            name: "username",
            controller: _usernameController,
            decoration: const InputDecoration(
                labelText: "Username", prefixIcon: Icon(Icons.person)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderTextField(
              name: "password",
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Password", prefixIcon: Icon(Icons.password)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              }),
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
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
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
                  }
                }
              },
              child: const Text("Login"))
        ],
      ),
    );
  }
}
