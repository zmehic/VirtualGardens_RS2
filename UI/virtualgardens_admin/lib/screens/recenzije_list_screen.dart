import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/recenzija.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/recenzije_provider.dart';
import 'package:virtualgardens_admin/providers/setovi_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/screens/narudzbe_list_screen.dart';
import 'package:virtualgardens_admin/screens/pitanja_list_screen.dart';
import 'package:virtualgardens_admin/screens/zaposlenici_list_screen.dart';
import 'package:virtualgardens_admin/models/set.dart';

// ignore: must_be_immutable
class RecenzijeListScreen extends StatefulWidget {
  Proizvod? proizvod;
  RecenzijeListScreen({super.key, this.proizvod});

  @override
  State<RecenzijeListScreen> createState() => _RecenzijeListScreenState();
}

class _RecenzijeListScreenState extends State<RecenzijeListScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};

  late RecenzijeProvider _recenzijeProvider;

  SearchResult<Recenzija>? recenzijeResult;

  bool isLoading = true;
  bool isLoadingSave = false;

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
    var filter = {
      'ProizvodId': widget.proizvod?.proizvodId,
      'isDeleted': false,
      'IncludeTables': "Korisnik"
    };
    recenzijeResult = await _recenzijeProvider.get(filter: filter);
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
                children: [_buildBanner(), _buildMain()],
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
              "${recenzijeResult?.result[index].korisnik?.ime} ${recenzijeResult?.result[index].korisnik?.prezime}",
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
}
