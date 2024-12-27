import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/recenzija.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/providers/recenzije_provider.dart';
import 'package:virtualgardens_mobile/providers/utils.dart';
import 'package:virtualgardens_mobile/screens/recenzije_list_screen.dart';

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
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromRGBO(235, 241, 224, 1),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
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

                  // Product Price and Unit
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
                  const SizedBox(height: 16),

                  // Product Type
                  Text(
                    "Vrsta proizvoda: ${widget.product?.vrstaProizvoda?.naziv ?? "Vrsta proizvoda nije poznata."}",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Availability
                  Row(
                    children: [
                      (widget.product?.dostupnaKolicina ?? 0) > 0 == true
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(
                              Icons.not_interested,
                              color: Colors.red,
                            ),
                      const SizedBox(width: 8),
                      Text(
                        "Dostupno: ${widget.product?.dostupnaKolicina ?? 0} ${widget.product?.jedinicaMjere?.skracenica ?? ''}",
                        style: TextStyle(
                          fontSize: 16,
                          color: (widget.product?.dostupnaKolicina ?? 0) > 0 ==
                                  true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Write Review Button and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingBar(
                        ignoreGestures: true,
                        allowHalfRating: true,
                        minRating: 1,
                        maxRating: 5,
                        initialRating: _calculateAverage(),
                        ratingWidget: RatingWidget(
                          full: const Icon(Icons.star, color: Colors.amber),
                          empty: const Icon(Icons.star, color: Colors.grey),
                          half: const Icon(Icons.star_half),
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecenzijeListScreen(
                                proizvod: widget.product,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          "Napiši recenziju",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 7),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Reviews List
                  Text(
                    "Recenzije",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: recenzijeResult?.result.length ?? 0,
                    itemBuilder: (context, index) {
                      final recenzija = recenzijeResult!.result[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        elevation: 3, // Subtle shadow for the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          expandedAlignment: Alignment.centerLeft,
                          backgroundColor:
                              const Color.fromRGBO(250, 250, 250, 1),
                          collapsedBackgroundColor:
                              const Color.fromRGBO(245, 245, 245, 1),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  recenzija.korisnik?.ime ??
                                      "Nepoznati korisnik",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(32, 76, 56, 1),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              RatingBarIndicator(
                                rating: recenzija.ocjena.toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemSize: 20,
                              ),
                            ],
                          ),
                          children: [
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                recenzija.komentar ?? "Bez komentara",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      "Detalji o proizvodu",
    );
  }

  double _calculateAverage() {
    if (recenzijeResult == null || recenzijeResult!.result.isEmpty) {
      return 0.0;
    }
    final total = recenzijeResult!.result
        .fold<int>(0, (sum, recenzija) => sum + recenzija.ocjena);
    return total / recenzijeResult!.result.length;
  }
}
