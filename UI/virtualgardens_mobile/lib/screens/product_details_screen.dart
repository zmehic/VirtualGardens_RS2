import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/recenzija.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/recenzije_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Proizvod? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late RecenzijeProvider _recenzijeProvider;
  SearchResult<Recenzija>? recenzijeResult;
  bool isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _recenzijeProvider = context.read<RecenzijeProvider>();
    super.initState();
    initForm();
  }

  Future initForm() async {
    var filter = {
      'ProizvodId': widget.product?.proizvodId,
      'isDeleted': false,
      'IncludeTables': "Korisnik"
    };
    recenzijeResult = await _recenzijeProvider.get(filter: filter);

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
              endDrawer: _buildEndDrawer("Recenzija"),
              appBar: AppBar(
                actions: <Widget>[Container()],
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Detalji o proizvodu",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: widget.product?.slika != null
                            ? imageFromString(widget.product!.slika!)
                            : const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Product Name
                      Text(
                        widget.product?.naziv ?? "Naziv proizvoda",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(32, 76, 56, 1),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Product Price
                      Text(
                        "${widget.product?.cijena ?? 0} KM / ${widget.product?.jedinicaMjere?.skracenica ?? ''}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Product Description
                      Text(
                        widget.product?.opis ?? "Opis proizvoda nije dostupan.",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Reviews Section Header
                      Text(
                        "Recenzije",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Reviews List
                      recenzijeResult?.result.isNotEmpty ?? false
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: recenzijeResult?.result.length ?? 0,
                              itemBuilder: (context, index) {
                                final recenzija =
                                    recenzijeResult!.result[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 0.0),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          recenzija.korisnik?.ime ??
                                              "Nepoznati korisnik",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        RatingBarIndicator(
                                          rating: recenzija.ocjena.toDouble(),
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemSize: 20,
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        recenzija.komentar ?? "Bez komentara",
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text("Nema dostupnih recenzija."),
                      const SizedBox(height: 16),

                      // Write Review Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text(
                            "Napiši recenziju",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(32, 76, 56, 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        "Detalji o proizvodu");
  }

  _buildEndDrawer(String title) {
    double userRating = 0; // To store the user's selected rating
    TextEditingController _commentController = TextEditingController();

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green.shade700),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ocijenite proizvod",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rating Bar
                  RatingBar(
                    ignoreGestures: false,
                    allowHalfRating: false,
                    minRating: 1,
                    maxRating: 5,
                    ratingWidget: RatingWidget(
                        full: const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        empty: const Icon(Icons.star, color: Colors.grey),
                        half: const Icon(Icons.star_half)),
                    onRatingUpdate: (double value) {
                      userRating = value;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Comment Field
                  const Text(
                    "Vaš komentar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "Napišite svoj komentar ovdje...",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (userRating == 0) {
                            // Show an error if the user hasn't given a rating
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Molimo odaberite ocjenu."),
                              ),
                            );
                            return;
                          }

                          if (_commentController.text.isEmpty) {
                            // Show an error if the comment is empty
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Molimo unesite komentar."),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          // Handle review submission here
                          final newReview = {
                            'ocjena': userRating.toInt(),
                            'komentar': _commentController.text,
                            'korisnikId': AuthProvider.korisnikId,
                            'proizvodId': widget.product!.proizvodId,
                          };

                          await _recenzijeProvider.insert(newReview);

                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "Vaša recenzija je uspješno poslana!",
                          );

                          // Clear inputs after submission
                          userRating = 0;
                          _commentController.clear();

                          // Close the drawer
                          _scaffoldKey.currentState?.closeEndDrawer();

                          await initForm();
                        },
                        child: const Text("Pošalji recenziju"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Clear inputs when cancel is pressed
                          userRating = 0;
                          _commentController.clear();
                          _scaffoldKey.currentState?.closeEndDrawer();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text("Otkaži"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
