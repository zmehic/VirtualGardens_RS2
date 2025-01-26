import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/pitanja_odgovori.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/pitanja_odgovori_provider.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';

class PitanjaOdgovoriListScreen extends StatefulWidget {
  final Narudzba? narudzba;
  const PitanjaOdgovoriListScreen({super.key, this.narudzba});

  @override
  State<PitanjaOdgovoriListScreen> createState() =>
      _PitanjaOdgovoriListScreenState();
}

class _PitanjaOdgovoriListScreenState extends State<PitanjaOdgovoriListScreen> {
  late PitanjaOdgovoriProvider provider;

  SearchResult<PitanjeOdgovor>? result;

  bool isLoading = true;

  final TextEditingController _porukaEditingController =
      TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    provider = context.read<PitanjaOdgovoriProvider>();
    super.initState();
    initScreen();
  }

  Future initScreen() async {
    var filter = {
      'NarudzbaId': widget.narudzba?.narudzbaId,
      'IncludeTables': "Korisnik",
      'isDeleted': false
    };

    result = await provider.get(filter: filter);

    _porukaEditingController.text = "";

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      FullScreenLoader(
        isLoading: isLoading,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[Container()],
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Pitanja za narudžbu",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          ),
          body: Column(
            children: [_buildResultView()],
          ),
        ),
      ),
      "Pitanja za narudžbu",
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: result?.result.length ?? 0,
                itemBuilder: (context, index) {
                  var message = result?.result[index];
                  var isLoggedInUser =
                      message?.korisnikId == AuthProvider.korisnikId;

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: isLoggedInUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isLoggedInUser)
                          _buildUserProfilePicture(message?.korisnik),
                        if (!isLoggedInUser) const SizedBox(width: 10),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isLoggedInUser
                                  ? Colors.blue[100]
                                  : Colors.green[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message?.tekst ?? "",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formatDateString(
                                      message?.datum.toIso8601String() ?? ""),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isLoggedInUser) const SizedBox(width: 10),
                        if (isLoggedInUser)
                          _buildUserProfilePicture(message?.korisnik),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TextField(
                        controller: _porukaEditingController,
                        decoration: const InputDecoration(
                          hintText: 'Upišite poruku...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_porukaEditingController.text.isEmpty) return;
    Map<dynamic, dynamic> request = {
      'tekst': _porukaEditingController.text,
      'korisnikId': AuthProvider.korisnikId,
      'narudzbaId': widget.narudzba?.narudzbaId
    };
    await provider.insert(request);
    initScreen();
  }

  _buildUserProfilePicture(Korisnik? korisnik) {
    return ClipOval(
      child: SizedBox(
          width: 40,
          height: 40,
          child: korisnik?.slika != null
              ? imageFromString(korisnik?.slika ?? "")
              : Image.asset(
                  'assets/images/user.png',
                  fit: BoxFit.cover,
                  width: 24,
                  height: 24,
                )),
    );
  }
}
