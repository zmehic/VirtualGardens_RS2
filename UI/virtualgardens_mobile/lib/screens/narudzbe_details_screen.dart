import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/models/set.dart';
import 'package:virtualgardens_mobile/providers/setovi_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';
import 'package:virtualgardens_mobile/screens/pitanja_list_screen.dart';

// ignore: must_be_immutable
class NarudzbaUserDetailsScreen extends StatefulWidget {
  final Narudzba? narudzba;
  NarudzbaUserDetailsScreen({super.key, this.narudzba});

  @override
  State<NarudzbaUserDetailsScreen> createState() =>
      _NarudzbaUserDetailsScreenState();
}

class _NarudzbaUserDetailsScreenState extends State<NarudzbaUserDetailsScreen> {
  late SetoviProvider _setoviProvider;

  SearchResult<Set>? setoviResult;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setoviProvider = context.read<SetoviProvider>();

    // Initialize the form values and fetch sets
    initForm();
  }

  Future initForm() async {
    var filter = {
      'NarudzbaId': widget.narudzba?.narudzbaId,
      'isDeleted': false,
      'IncludeTables': "ProizvodiSets"
    };
    setoviResult = await _setoviProvider.get(filter: filter);
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
          color: const Color.fromRGBO(235, 241, 224, 1),
          child: Column(
            children: [
              _buildBanner(),
              _buildOrderDetails(),
              _buildSetsList(),
            ],
          ),
        ),
      ),
      "Detalji narudžbe",
    );
  }

  Widget _buildBanner() {
    return Container(
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(size: 45, color: Colors.white, Icons.shopping_basket),
                SizedBox(width: 10),
                Text(
                  "Detalji narudžbe",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arial",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Replace 'QuestionsScreen' with your actual screen/widget
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PitanjaOdgovoriListScreen(
                              narudzba: widget.narudzba,
                            )),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue, // Set your desired color here
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.question_answer,
                    size: 20, // Adjust the size as needed
                    color: Colors.white, // Icon color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDetailRow(
                "Broj narudžbe:", widget.narudzba?.brojNarudzbe ?? "N/A"),
            _buildDetailRow("Datum narudžbe:",
                formatDateString(widget.narudzba?.datum.toIso8601String())),
            _buildDetailRow("Status:",
                widget.narudzba?.status == true ? "Aktivna" : "Neaktivna"),
            _buildDetailRow(
                "Otkazana:", widget.narudzba?.otkazana == true ? "Da" : "Ne"),
            _buildDetailRow(
                "Plaćena:", widget.narudzba?.placeno == true ? "Da" : "Ne"),
            _buildDetailRow(
                "Ukupna cijena:", "${widget.narudzba?.ukupnaCijena} KM"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSetsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: setoviResult?.result.length ?? 0,
        itemBuilder: (context, index) {
          return (setoviResult != null
                      ? setoviResult?.result[index].proizvodiSets.length
                      : -1)! >
                  0
              ? _buildExpansionTile(index)
              : Container();
        },
      ),
    );
  }

  Widget _buildExpansionTile(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        title: Text(
          "Set ${index + 1} - ${setoviResult?.result[index].cijenaSaPopustom} KM",
          style: TextStyle(color: Colors.black),
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: setoviResult?.result[index].proizvodiSets.length ?? 0,
            itemBuilder: (context, subIndex) {
              var product = setoviResult?.result[index].proizvodiSets[subIndex];
              return ListTile(
                title: Text(
                  "${product?.proizvod?.naziv ?? ""} x ${product?.kolicina ?? ""} ${product?.proizvod?.jedinicaMjere?.skracenica ?? ""} = ${(product?.kolicina ?? 0) * (product?.proizvod?.cijena ?? 0.0)} KM",
                  style: TextStyle(color: Colors.black),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
