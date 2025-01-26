import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/models/ponuda.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/ponude_provider.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';
import 'package:virtualgardens_mobile/screens/narudzbe_list_screen.dart';
import 'package:virtualgardens_mobile/screens/ponude_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late KorisnikProvider korisnikProvider;
  late PonudeProvider _ponudeProvider;

  Korisnik? korisnikResult;
  SearchResult<Ponuda>? ponudeResult;

  bool isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    korisnikProvider = context.read<KorisnikProvider>();
    _ponudeProvider = context.read<PonudeProvider>();

    super.initState();

    initScreen(null);
  }

  Future initScreen(int? value) async {
    korisnikResult = await korisnikProvider.getById(AuthProvider.korisnikId!);

    var filterPonude = {
      'IsDeleted': false,
      'IncludeTables': "SetoviPonudes",
      'stateMachine': "active"
    };

    ponudeResult = await _ponudeProvider.get(filter: filterPonude);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MasterScreen(
      FullScreenLoader(
          isLoading: isLoading,
          child: Scaffold(
            key: _scaffoldKey,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _greeting(screenWidth),
                        const SizedBox(height: 20),
                        _basicInfo(screenWidth),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(32, 76, 56, 1),
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(235, 241, 224, 1),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserOrdersScreen(),
                        ),
                      );
                    },
                    child: const Text('Kreiraj narudžbu'),
                  ),
                ),
              ],
            ),
          )),
      "Home Screen",
    );
  }

  Widget _greeting(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Dobrodošli nazad,\n${korisnikResult?.ime} ${korisnikResult?.prezime}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Arial",
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: screenWidth * 0.2,
            backgroundImage: korisnikResult?.slika != null
                ? imageFromString(korisnikResult!.slika!).image
                : const AssetImage('assets/images/user.png'),
          ),
        ],
      ),
    );
  }

  Widget _basicInfo(double screenWidth) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _sectionContainer(
          "Ponude",
          Icons.local_offer,
          SingleChildScrollView(child: ponude()),
          onSearch: () {},
        ),
      ],
    );
  }

  Widget ponude() {
    return Column(children: [
      ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        itemCount: ponudeResult?.result.length ?? 0,
        itemBuilder: (context, index) {
          final ponuda = ponudeResult?.result[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              title: Text(
                ponuda?.naziv ?? "Unknown",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.black),
                onPressed: () {
                  if (ponuda != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PonudeDetailsScreen(ponuda: ponuda),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    ]);
  }

  Widget _sectionContainer(String title, IconData icon, Widget content,
      {required VoidCallback onSearch}) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(32, 76, 56, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 40, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: onSearch,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: content,
          ),
        ],
      ),
    );
  }
}
