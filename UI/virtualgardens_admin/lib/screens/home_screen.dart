import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/korisnici.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/korisnik_provider.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';
import 'package:virtualgardens_admin/screens/product_list_screen.dart';
import 'package:virtualgardens_admin/screens/narudzbe_list_screen.dart';

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
    super.initState();
    vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    productProvider = context.read<ProductProvider>();
    korisnikProvider = context.read<KorisnikProvider>();
    narudzbaProvider = context.read<NarudzbaProvider>();

    initScreen(null);
  }

  Future initScreen(int? value) async {
    vrsteProizvodaResult = await vrsteProizvodaProvider.get();
    selectedVrstaProizvoda = vrsteProizvodaResult?.result[0].vrstaProizvodaId;

    await fetchProducts(value);

    korisnikResult = await korisnikProvider.getById(AuthProvider.korisnikId!);

    var filterNarudzbe = {
      'Page': 1,
      'OrderBy': "Datum",
      'SortDirection': "ASC",
      'PageSize': 3,
      'IncludeTables': "Korisnik",
      'StateMachine': "created"
    };

    narudzbeResult = await narudzbaProvider.get(filter: filterNarudzbe);

    setState(() {
      isLoading = false;
    });
  }

  Future fetchProducts(int? value) async {
    var filterProizvodi = {
      'Page': 1,
      'OrderBy': "DostupnaKolicina",
      'SortDirection': "ASC",
      'VrstaProizvodaId': value ?? selectedVrstaProizvoda,
      'PageSize': 3,
      'IncludeTables': "JedinicaMjere",
      'isDeleted': false
    };
    proizvodiResult = await productProvider.get(filter: filterProizvodi);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        color: const Color.fromRGBO(235, 241, 224, 1),
        child: Column(
          children: [
            isLoading ? Container() : Expanded(child: _greeting()),
            isLoading ? Container() : Expanded(child: _basicInfo())
          ],
        ),
      ),
      "Home Screen",
    );
  }

  Widget _greeting() {
    return Row(
      children: [
        _buildGreeting(),
        _buildProfileImage(),
      ],
    );
  }

  Widget _basicInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProductsPreview(),
          const SizedBox(width: 10),
          _buildOrderPreview(),
        ],
      ),
    );
  }

  Widget buildList(String datum, String naziv, String cijena) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(235, 241, 224, 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(datum,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(naziv,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(cijena,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String name, String number) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(number,
                  style: const TextStyle(
                      fontSize: 27, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Expanded(
      child: Container(
        color: const Color.fromRGBO(30, 44, 47, 1),
        child: Center(
          child: Text(
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              fontFamily: "arial",
              color: Colors.white,
            ),
            "Dobrodošli nazad,\n${korisnikResult?.ime} ${korisnikResult?.prezime}",
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Expanded(
      child: Container(
        color: const Color.fromRGBO(32, 76, 56, 1),
        child: Center(
          child: Container(
            width: 270.0,
            height: 270.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4.0),
            ),
            child: ClipOval(
              child: SizedBox(
                width: 250,
                height: 250,
                child: korisnikResult?.slika != null
                    ? imageFromString(korisnikResult!.slika!)
                    : Image.asset('assets/images/user.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsPreview() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
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
                        "Skladište",
                      ),
                      const SizedBox(width: 20),
                      _buildDropdown(),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        IconButton(
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductListScreen()));
                          },
                          icon: const Icon(
                              size: 45, color: Colors.white, Icons.search),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SizedBox(
                  height: 180,
                  child: Row(
                    children:
                        (proizvodiResult?.result ?? []).map<Widget>((item) {
                      return buildCard(item.naziv ?? "",
                          "${item.dostupnaKolicina.toString()} ${item.jedinicaMjere?.skracenica}");
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: "$selectedVrstaProizvoda",
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        items: vrsteProizvodaResult?.result
                .map((item) => DropdownMenuItem(
                      value: item.vrstaProizvodaId.toString(),
                      child: Text(item.naziv ?? "",
                          style: const TextStyle(color: Colors.black)),
                    ))
                .toList() ??
            [],
        onChanged: (value) async {
          if (value != null) {
            selectedVrstaProizvoda = int.tryParse(value.toString());
            await fetchProducts(selectedVrstaProizvoda);
            setState(() {});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Vrijednost može biti 'Tlo', 'Sjeme' ili 'Prihrana'!"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderPreview() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(32, 76, 56, 1),
      ),
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(size: 45, color: Colors.white, Icons.shopping_cart),
                    Text(
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "arial",
                          color: Colors.white),
                      "Narudžbe",
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NarduzbeListScreen()));
                  },
                  icon: const Icon(size: 45, color: Colors.white, Icons.search),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0, right: 40.0, bottom: 25, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...(narudzbeResult?.result ?? [])
                                .map<Widget>((item) {
                              return buildList(
                                formatDateString(item.datum.toString())
                                    .toString(),
                                "${item.korisnik?.ime} ${item.korisnik?.prezime}",
                                "${item.ukupnaCijena.toString()} KM",
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
