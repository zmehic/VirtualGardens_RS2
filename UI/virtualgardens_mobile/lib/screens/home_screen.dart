import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/ponuda.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/models/setovi_ponude.dart';
import 'package:virtualgardens_mobile/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/korisnik_provider.dart';
import 'package:virtualgardens_mobile/providers/narudzbe_provider.dart';
import 'package:virtualgardens_mobile/providers/ponude_provider.dart';
import 'package:virtualgardens_mobile/providers/product_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_ponude_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_proizvodi_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';
import 'package:virtualgardens_mobile/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_mobile/screens/ponude_details_screen.dart';
import 'package:virtualgardens_mobile/screens/product_list_screen.dart';
import 'package:virtualgardens_mobile/screens/narudzbe_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VrsteProizvodaProvider vrsteProizvodaProvider;
  late ProductProvider productProvider;
  late KorisnikProvider korisnikProvider;
  late NarudzbaProvider narudzbaProvider;
  late PonudeProvider _ponudeProvider;
  late SetoviPonudeProvider _setoviPonudeProvider;
  late SetoviProvider _setoviProvider;
  late SetProizvodProvider _proizvodiSet;

  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;
  SearchResult<Proizvod>? proizvodiResult;
  SearchResult<SetoviPonude>? setoviPonudeResult;
  Set? set;
  SetoviPonude? setPonuda;
  Korisnik? korisnikResult;
  SearchResult<Ponuda>? ponudeResult;

  bool isLoading = true;
  int? selectedVrstaProizvoda;

  int? expandedIndex;

  @override
  void initState() {
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    productProvider = context.read<ProductProvider>();
    korisnikProvider = context.read<KorisnikProvider>();
    _ponudeProvider = context.read<PonudeProvider>();
    _setoviPonudeProvider = context.read<SetoviPonudeProvider>();
    _setoviProvider = context.read<SetoviProvider>();
    _proizvodiSet = context.read<SetProizvodProvider>();

    super.initState();

    initScreen(null);
  }

  Future initScreen(int? value) async {
    vrsteProizvodaResult = await vrsteProizvodaProvider.get();
    selectedVrstaProizvoda = vrsteProizvodaResult?.result[0].vrstaProizvodaId;

    var filterProizvodi = {
      'Page': 1,
      'OrderBy': "DostupnaKolicina",
      'SortDirection': "ASC",
      'VrstaProizvodaId': value ?? selectedVrstaProizvoda,
      'PageSize': 3,
      'IncludeTables': "JedinicaMjere"
    };

    proizvodiResult = await productProvider.get(filter: filterProizvodi);
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: const Color.fromRGBO(235, 241, 224, 1),
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
      ),
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
                    as ImageProvider<Object>
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
          SingleChildScrollView(
              child: ponude()), // Replace with appropriate content for orders
          onSearch: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NarduzbeListScreen(),
              ),
            );
          },
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
                  // Navigate to a new screen with the specific `ponuda`
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
      )
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

  Widget buildCardList() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: (proizvodiResult?.result ?? [])
            .map<Widget>((item) => buildCard(item.naziv ?? "",
                "${item.dostupnaKolicina} ${item.jedinicaMjere?.skracenica}"))
            .toList(),
      ),
    );
  }

  Widget buildCard(String name, String number) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1, // Makes the card a square
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8), // Adds spacing between name and number
              Text(
                number,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
