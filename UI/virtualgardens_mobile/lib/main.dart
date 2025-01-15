import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/jedinice_mjere_provider.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/nalozi_provider.dart';
import 'package:virtualgardens_mobile/providers/narudzbe_provider.dart';
import 'package:virtualgardens_mobile/providers/pitanja_odgovori_provider.dart';
import 'package:virtualgardens_mobile/providers/ponude_provider.dart';
import 'package:virtualgardens_mobile/providers/product_provider.dart';
import 'package:virtualgardens_mobile/providers/recenzije_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_ponude_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_proizvodi_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_provider.dart';
import 'package:virtualgardens_mobile/providers/ulazi_proizvodi_provider.dart';
import 'package:virtualgardens_mobile/providers/ulazi_provider.dart';
import 'package:virtualgardens_mobile/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_mobile/providers/zaposlenici_provider.dart';
import 'package:virtualgardens_mobile/screens/home_screen.dart';
import 'package:virtualgardens_mobile/screens/register_screen.dart';

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
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      print("ON error error: ${errorDetails.exception.toString()}");
    };
    await dotenv.load(fileName: ".env");
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
  }, (error, stack) {
    print("Error from OUT_SUDE Framerwork");
    print("--------------------------------");
    print("Error : $error");
    // print("StackTrace : $stack");
  });
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 500,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.fill)),
              child: Stack(
                children: [
                  Positioned(
                      height: 300,
                      left: 60,
                      top: 100,
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[350]!))),
                        child: FormBuilderTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          name: "username",
                          controller: _usernameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Korisničko ime",
                              hintStyle: TextStyle(color: Colors.grey[350])),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[350]!))),
                        child: FormBuilderTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          name: "password",
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Lozinka",
                              hintStyle: TextStyle(color: Colors.grey[350])),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color.fromRGBO(32, 76, 56, 1),
                                Color.fromRGBO(157, 186, 155, 1)
                              ])),
                          child: InkWell(
                            onTap: () async {
                              final navigator = Navigator.of(context);
                              final provider = Provider.of<KorisnikProvider>(
                                  context,
                                  listen: false);

                              if (_formKey.currentState?.saveAndValidate() ==
                                  true) {
                                debugPrint(
                                    "credentials: ${_usernameController.text} : ${_passwordController.text}");
                                AuthProvider.username =
                                    _usernameController.text;
                                AuthProvider.password =
                                    _passwordController.text;
                              }
                              try {
                                await provider.login(
                                    username: AuthProvider.username,
                                    password: AuthProvider.password);
                                // ignore: use_build_context_synchronously
                                navigator.push(MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                              } on Exception catch (e) {
                                showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("Greška :("),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("OK"))
                                          ],
                                          content: Text(e.toString()),
                                        ));
                              }
                            },
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Text("Niste registrovani?"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(colors: [
                                          Color.fromRGBO(32, 76, 56, 1),
                                          Color.fromRGBO(157, 186, 155, 1)
                                        ])),
                                    child: InkWell(
                                      child: const Center(
                                          child: Text(
                                        "Registruj se",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      onTap: () async {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterScreen()));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
