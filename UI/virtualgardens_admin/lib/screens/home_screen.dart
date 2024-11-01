import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/korisnici.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/korisnik_provider.dart';
import 'package:virtualgardens_admin/providers/narduzbe_provider.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';

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

  SearchResult<VrstaProizvoda>? vrsteProizvodaResult;
  SearchResult<Proizvod>? proizvodiResult;
  SearchResult<Narudzba>? narudzbeResult;

  Korisnik? korisnikResult;

  bool isLoading = true;
  int? selectedVrstaProizvoda;

  @override
  void initState() {
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    productProvider = context.read<ProductProvider>();
    korisnikProvider = context.read<KorisnikProvider>();
    narudzbaProvider = context.read<NarudzbaProvider>();

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

    var filterNarudzbe = {
      'Page': 1,
      'OrderBy': "Datum",
      'SortDirection': "ASC",
      'PageSize': 3,
      'IncludeTables': "Korisnik"
    };

    narudzbeResult = await narudzbaProvider.get(filter: filterNarudzbe);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        Container(
            margin:
                const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
            color: const Color.fromRGBO(235, 241, 224, 1),
            child: SingleChildScrollView(
                child: Column(
              children: [
                isLoading ? Container() : _greeting(),
                isLoading ? Container() : _basicInfo()
              ],
            ))),
        "Home Screen");
  }

  Widget _greeting() {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 350,
                color: const Color.fromRGBO(30, 44, 47, 1),
                child: Center(
                  child: Text(
                      style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: "arial",
                          color: Colors.white),
                      "Dobrodošli nazad,\n${korisnikResult?.ime} ${korisnikResult?.prezime}"),
                ),
              ),
            ),
            Expanded(
                child: Container(
              height: 350,
              color: const Color.fromRGBO(32, 76, 56, 1),
              child: Center(
                  child: Container(
                width: 270.0, // Adjust the size of the container
                height: 270.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white, // Set the border color
                    width: 4.0, // Set the border width
                  ),
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: 250, // Set the width of the container
                    height:
                        250, // Set the height of the container (same as width for a circle)
                    child: korisnikResult?.slika != null
                        ? imageFromString(korisnikResult!.slika!)
                        : Image.asset(
                            'assets/images/user.png',
                            fit: BoxFit
                                .cover, // Cover the whole area of the circle
                          ),
                  ),
                ),
              )),
            ))
          ],
        ));
  }

  Widget _basicInfo() {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(32, 76, 56, 1)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                  size: 45,
                                  color: Colors.white,
                                  Icons.store_mall_directory),
                              const Text(
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "arial",
                                      color: Colors.white),
                                  "Skladište"),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: DropdownMenu(
                                  initialSelection: "1",
                                  dropdownMenuEntries: vrsteProizvodaResult
                                          ?.result
                                          .map((item) => DropdownMenuEntry(
                                              value: item.vrstaProizvodaId
                                                  .toString(),
                                              label: item.naziv ?? ""))
                                          .toList() ??
                                      [],
                                  menuStyle: MenuStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      elevation: MaterialStateProperty.all(4),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color:
                                                      Colors.grey.shade300)))),
                                  textStyle: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  onSelected: (value) {
                                    initScreen(int.tryParse(value.toString()));
                                  },
                                ),
                              )
                            ],
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                  size: 45, color: Colors.white, Icons.search))
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 25, left: 25, right: 25, top: 10),
                        child: SizedBox(
                          height: 180,
                          child: Row(
                            children: (proizvodiResult?.result ?? [])
                                .map<Widget>((item) {
                              return buildCard(item.naziv ?? "",
                                  "${item.dostupnaKolicina.toString()} ${item.jedinicaMjere?.skracenica}");
                            }).toList(),
                          ),
                        ))
                  ],
                ),
              ),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(32, 76, 56, 1)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                  size: 45,
                                  color: Colors.white,
                                  Icons.shopping_cart),
                              Text(
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "arial",
                                      color: Colors.white),
                                  "Narudžbe")
                            ],
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                  size: 45, color: Colors.white, Icons.search))
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(25),
                        child: SizedBox(
                          width: double.infinity,
                          height: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40.0, bottom: 10, top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      ...(narudzbeResult?.result ?? [])
                                          .map<Widget>((item) {
                                        return buildList(
                                            formatDateString(
                                                        item.datum.toString())
                                                    .toString() ??
                                                "",
                                            "${item.korisnik?.ime} ${item.korisnik?.prezime}",
                                            "${item.ukupnaCijena.toString()} KM");
                                      }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ))
          ],
        ));
  }

  Widget buildList(String datum, String naziv, String cijena) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(235, 241, 224, 1),
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(datum,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(naziv,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(cijena,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ],
        ),
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
