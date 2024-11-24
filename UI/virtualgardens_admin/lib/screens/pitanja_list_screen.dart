import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/pitanja_odgovori.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/pitanja_odgovori_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';

// ignore: must_be_immutable
class PitanjaOdgovoriListScreen extends StatefulWidget {
  Narudzba? narudzba;
  PitanjaOdgovoriListScreen({super.key, this.narudzba});

  @override
  State<PitanjaOdgovoriListScreen> createState() =>
      _PitanjaOdgovoriListScreenState();
}

class _PitanjaOdgovoriListScreenState extends State<PitanjaOdgovoriListScreen> {
  late PitanjaOdgovoriProvider provider;

  SearchResult<PitanjeOdgovor>? result;

  bool isLoading = true;

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
        isLoading: isLoading, // Your loading state
        child: Container(
          margin:
              const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
          color: const Color.fromRGBO(235, 241, 224, 1),
          child: Column(
            children: [
              _buildBanner(),
              _buildResultView(),
            ],
          ),
        ),
      ),
      "Pitanja za narudžbu - ${widget.narudzba?.brojNarudzbe}",
    );
  }

  final TextEditingController _porukaEditingController =
      TextEditingController();

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
                          ClipOval(
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: message?.korisnik?.slika != null
                                    ? imageFromString(
                                        message?.korisnik?.slika ?? "")
                                    : Image.asset(
                                        'assets/images/user.png',
                                        fit: BoxFit.cover,
                                        width: 24,
                                        height:
                                            24, // Cover the whole area of the circle
                                      )),
                          ),
                        if (!isLoggedInUser) const SizedBox(width: 10),

                        // Message bubble
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

                        // Show profile picture for logged-in user
                        if (isLoggedInUser) const SizedBox(width: 10),
                        if (isLoggedInUser)
                          ClipOval(
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: message?.korisnik?.slika != null
                                    ? imageFromString(
                                        message?.korisnik?.slika ?? "")
                                    : Image.asset(
                                        'assets/images/user.png',
                                        fit: BoxFit.cover,
                                        width: 24,
                                        height:
                                            24, // Cover the whole area of the circle
                                      )),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Input field for new messages
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

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(size: 45, color: Colors.white, Icons.question_answer),
            const SizedBox(
              width: 10,
            ),
            Text("Pitanja za narudžbu - ${widget.narudzba?.brojNarudzbe}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arial",
                    color: Colors.white)),
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
}
