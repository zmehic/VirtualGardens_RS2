import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/recenzija.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/recenzije_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';

// ignore: must_be_immutable
class RecenzijeListScreen extends StatefulWidget {
  Proizvod? proizvod;
  RecenzijeListScreen({super.key, this.proizvod});

  @override
  State<RecenzijeListScreen> createState() => _RecenzijeListScreenState();
}

class _RecenzijeListScreenState extends State<RecenzijeListScreen> {
  late Map<int, String> korisnici = {};

  late RecenzijeProvider _recenzijeProvider;

  SearchResult<Recenzija>? recenzijeResult;

  bool isLoading = true;
  bool isLoadingSave = false;

  int? korisnik;

  RangeValues selectedRange = RangeValues(1, 5);

  String datumOdString = "";
  String datumDoString = "";

  final TextEditingController _ocjenaEditingController =
      TextEditingController();
  final TextEditingController _datumOdEditingController =
      TextEditingController();
  final TextEditingController _datumDoEditingController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _recenzijeProvider = context.read<RecenzijeProvider>();

    super.initState();

    initForm();
  }

  Future initForm() async {
    korisnici[0] = "Svi";
    _datumOdEditingController.text = "";
    _datumDoEditingController.text = "";
    _ocjenaEditingController.text = "";
    selectedRange = RangeValues(1, 5);

    var filter = {
      'ProizvodId': widget.proizvod?.proizvodId,
      'isDeleted': false,
      'IncludeTables': "Korisnik"
    };
    recenzijeResult = await _recenzijeProvider.get(filter: filter);

    if (recenzijeResult != null) {
      for (var element in recenzijeResult!.result) {
        if (korisnici.keys.contains(element.korisnikId) == false) {
          korisnici[element.korisnikId] =
              "${element.korisnik?.ime} ${element.korisnik?.prezime}";
        }
      }
    }
    setState(() {
      isLoading = false;
      isLoadingSave = false;
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
                children: [_buildBanner(), _buildSearch(), _buildMain()],
              ),
            )),
        "Recenzije");
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(size: 45, color: Colors.white, Icons.star),
            SizedBox(
              width: 10,
            ),
            Text("Recenzije",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arial",
                    color: Colors.white)),
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
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: const Color.fromRGBO(235, 241, 224, 1),
                    child: Column(children: [
                      Expanded(
                        child: _buildResultView(),
                      )
                    ]),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildResultView() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: recenzijeResult?.result.length,
              itemBuilder: (context, index) {
                return recenzijeResult != null &&
                        recenzijeResult?.result[index] != null
                    ? _buildExpansionTile(index)
                    : Container();
              },
            )
          ],
        )));
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
        title: Row(
          children: [
            ClipOval(
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: recenzijeResult?.result[index].korisnik?.slika != null
                      ? imageFromString(
                          recenzijeResult?.result[index].korisnik?.slika ?? "")
                      : Image.asset(
                          'assets/images/user.png',
                          fit: BoxFit.cover,
                          width: 24,
                          height: 24, // Cover the whole area of the circle
                        )),
            ),
            const SizedBox(width: 10),
            Text(
              "${recenzijeResult?.result[index].korisnik?.ime} ${recenzijeResult?.result[index].korisnik?.prezime} - ${formatDateString(recenzijeResult?.result[index].datum.toIso8601String())}",
              style: const TextStyle(color: Colors.black),
            ),
            const Spacer(),
            RatingBar(
              ignoreGestures: true,
              allowHalfRating: false,
              minRating: 1,
              maxRating: 5,
              initialRating: recenzijeResult?.result[index].ocjena.toDouble() ??
                  1.toDouble(),
              ratingWidget: RatingWidget(
                  full: const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  empty: const Icon(Icons.star, color: Colors.grey),
                  half: const Icon(Icons.star_half)),
              onRatingUpdate: (double value) {},
            )
          ],
        ),
        textColor: Colors.white,
        children: [
          ListTile(
              title: Text(recenzijeResult?.result[index].komentar ?? "",
                  style: const TextStyle(color: Colors.black))),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400)),
              child: DropdownMenu(
                initialSelection: 0,
                enableFilter: false,
                dropdownMenuEntries: korisnici.keys
                    .map((e) =>
                        DropdownMenuEntry(value: e, label: korisnici[e]!))
                    .toList(),
                menuStyle: MenuStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(4),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300)))),
                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                onSelected: (value) {
                  if (value != null) {
                    korisnik = int.tryParse(value.toString());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Odaberite validnu vrijednost"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _datumOdEditingController,
              decoration: const InputDecoration(labelText: "Datum od:"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  datumOdString = pickedDate.toIso8601String();
                  _datumOdEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                }
              },
            )),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _datumOdEditingController.clear();
                datumOdString = "";
              },
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _datumDoEditingController,
              decoration: const InputDecoration(labelText: "Datum do:"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  pickedDate = DateTime(pickedDate.year, pickedDate.month,
                      pickedDate.day, 23, 59, 59);
                  datumDoString = pickedDate.toIso8601String();
                  _datumDoEditingController.text =
                      formatDateString(pickedDate.toIso8601String());
                }
              },
            )),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _datumDoEditingController.clear();
                datumDoString = "";
              },
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Ocjena:"),
            RangeSlider(
                values: selectedRange,
                min: 1,
                max: 5,
                divisions: 5,
                labels: RangeLabels(selectedRange.start.round().toString(),
                    selectedRange.end.round().toString()),
                onChanged: (values) {
                  setState(() {
                    selectedRange = values;
                  });
                }),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  var filter = {
                    'OcjenaFrom': selectedRange.start.toInt(),
                    'OcjenaTo': selectedRange.end.toInt(),
                    'DatumFrom': datumOdString,
                    'DatumTo': datumDoString,
                    'ProizvodId': widget.proizvod?.proizvodId,
                    'KorisnikId': korisnik != 0 ? korisnik : null,
                    'isDeleted': false,
                    'IncludeTables': "Korisnik"
                  };
                  recenzijeResult =
                      await _recenzijeProvider.get(filter: filter);
                  setState(() {});
                },
                child: const Text("Pretraga")),
          ],
        ));
  }
}
