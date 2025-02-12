import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/models/recenzija.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/recenzije_provider.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Proizvod? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Map<String, dynamic> _initialValue = {};

  late RecenzijeProvider _recenzijeProvider;
  SearchResult<Recenzija>? recenzijeResult;

  bool isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _productRatingFormKey =
      GlobalKey<FormBuilderState>();

  @override
  void initState() {
    _recenzijeProvider = context.read<RecenzijeProvider>();
    super.initState();
    initForm();
  }

  Future initForm() async {
    _initialValue = {'komenatar': ""};

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
              endDrawer: _buildEndDrawer("Recenzija", null),
              resizeToAvoidBottomInset: false,
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
                      Text(
                        widget.product?.naziv ?? "Naziv proizvoda",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(32, 76, 56, 1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${widget.product?.cijena ?? 0} KM / ${widget.product?.jedinicaMjere?.skracenica ?? ''}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.product?.opis ?? "Opis proizvoda nije dostupan.",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Recenzije",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 250,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              recenzijeResult?.result.isNotEmpty ?? false
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          recenzijeResult?.result.length ?? 0,
                                      itemBuilder: (context, index) {
                                        final recenzija =
                                            recenzijeResult!.result[index];
                                        return _buildRecenzijaWidget(recenzija);
                                      },
                                    )
                                  : const Text("Nema dostupnih recenzija."),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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

  _buildEndDrawer(String title, Recenzija? recenzija) {
    double userRating = 1;
    TextEditingController commentController = TextEditingController();

    return Drawer(
      child: FormBuilder(
        key: _productRatingFormKey,
        initialValue: _initialValue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(32, 76, 56, 1)),
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
                child: SingleChildScrollView(
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
                      RatingBar(
                        ignoreGestures: false,
                        allowHalfRating: false,
                        initialRating: 1,
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
                      const Text(
                        "Vaš komentar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: "komentar",
                        maxLines: 5,
                        maxLength: 255,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Napišite svoj komentar ovdje...",
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(100,
                              errorText: "Maksimalno dozvoljeno je 100 znakova")
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(32, 76, 56, 1),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                            ),
                            onPressed: () async {
                              if (_productRatingFormKey.currentState
                                      ?.saveAndValidate() ==
                                  true) {
                                if (userRating == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Molimo odaberite ocjenu."),
                                    ),
                                  );
                                  return;
                                }

                                final newReview = {
                                  'ocjena': userRating.toInt(),
                                  'komentar': _productRatingFormKey
                                          .currentState!
                                          .fields['komentar']
                                          ?.value ??
                                      "",
                                  'korisnikId': AuthProvider.korisnikId,
                                  'proizvodId': widget.product!.proizvodId,
                                };
                                try {
                                  var result = await _recenzijeProvider
                                      .insert(newReview);
                                  recenzijeResult!.result.add(result);
                                  if (mounted) {
                                    await buildSuccessAlert(
                                        context,
                                        "Uspješno!",
                                        "Vaša recenzija je uspješno poslana!",
                                        isDoublePop: false);
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  userRating = 0;
                                  commentController.clear();
                                  _scaffoldKey.currentState?.closeEndDrawer();
                                  setState(() {});
                                } on Exception catch (e) {
                                  if (mounted) {
                                    await buildErrorAlert(
                                        context, "Greška", e.toString(), e);
                                  }
                                  setState(() {});
                                }
                                userRating = 0;
                                commentController.clear();
                                _scaffoldKey.currentState?.closeEndDrawer();

                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: const Text("Pošalji recenziju",
                                style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              userRating = 0;
                              _productRatingFormKey.currentState!
                                  .setInternalFieldValue('komentar', "");
                              _scaffoldKey.currentState?.closeEndDrawer();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                            ),
                            child: const Text(
                              "Otkaži",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecenzijaWidget(Recenzija recenzija) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              recenzija.korisnik?.ime ?? "Nepoznati korisnik",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
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
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  recenzija.komentar ?? "Bez komentara",
                ),
              ),
              recenzija.korisnikId == AuthProvider.korisnikId
                  ? IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        if (mounted) {
                          await buildDeleteAlert(
                              context,
                              "Recenzija",
                              "Recenzija",
                              _recenzijeProvider,
                              recenzija.recenzijaId);
                        }
                        recenzijeResult!.result.remove(recenzija);
                        setState(() {});
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
