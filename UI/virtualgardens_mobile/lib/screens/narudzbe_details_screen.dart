import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/ponuda.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/models/set.dart';
import 'package:virtualgardens_mobile/providers/narudzbe_provider.dart';
import 'package:virtualgardens_mobile/providers/ponude_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_provider.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/utils.dart';
import 'package:virtualgardens_mobile/screens/add_product_set_screen.dart';
import 'package:virtualgardens_mobile/screens/pitanja_list_screen.dart';
import 'package:virtualgardens_mobile/screens/ponude_details_screen.dart';

// ignore: must_be_immutable
class NarudzbaUserDetailsScreen extends StatefulWidget {
  Narudzba? narudzba;
  String? secretKeyValue;
  String? clientIdValue;
  NarudzbaUserDetailsScreen({super.key, this.narudzba}) {
    secretKeyValue =
        const String.fromEnvironment("SECRETKEY", defaultValue: "");
    clientIdValue = const String.fromEnvironment("CLIENTID", defaultValue: "");
  }

  @override
  State<NarudzbaUserDetailsScreen> createState() =>
      _NarudzbaUserDetailsScreenState();
}

class _NarudzbaUserDetailsScreenState extends State<NarudzbaUserDetailsScreen> {
  late SetoviProvider _setoviProvider;
  late NarudzbaProvider _narudzbaProvider;
  late PonudeProvider _ponudeProvider;

  List<String> listaValidity = [];

  SearchResult<Set>? setoviResult;
  SearchResult<Ponuda>? offersResult;

  bool isLoading = true;

  final _scaffoldKeyOrderDetails = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _setoviProvider = context.read<SetoviProvider>();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    _ponudeProvider = context.read<PonudeProvider>();

    initForm();
  }

  Future<bool> checkValidity() async {
    listaValidity = await _narudzbaProvider.checkOrderValidity(
        orderid: widget.narudzba!.narudzbaId);
    if (listaValidity.isEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future initForm() async {
    widget.narudzba =
        await _narudzbaProvider.getById(widget.narudzba!.narudzbaId);

    var filter = {
      'NarudzbaId': widget.narudzba?.narudzbaId,
      'isDeleted': false,
      'IncludeTables': "ProizvodiSets"
    };
    setoviResult = await _setoviProvider.get(filter: filter);
    fetchOffers();
    setState(() {
      isLoading = false;
    });
  }

  Future fetchOffers() async {
    var filter = {'isDeleted': false, 'stateMachine': 'active'};
    offersResult = await _ponudeProvider.get(filter: filter);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.narudzba?.stateMachine == "created" ? 2 : 1,
      child: MasterScreen(
        FullScreenLoader(
          isLoading: isLoading,
          child: Scaffold(
            key: _scaffoldKeyOrderDetails,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              actions: <Widget>[
                widget.narudzba!.stateMachine != 'created'
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PitanjaOdgovoriListScreen(
                                narudzba: widget.narudzba,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.question_answer,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(),
              ],
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Detalji narudžbe",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
            ),
            body: Container(
              color: const Color.fromRGBO(235, 241, 224, 1),
              child: Column(
                children: [
                  widget.narudzba?.stateMachine == "created"
                      ? const TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.green,
                          tabs: [
                            Tab(text: "Detalji narudžbe"),
                            Tab(text: "Ponude"),
                          ],
                        )
                      : const TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.green,
                          tabs: [
                            Tab(text: "Detalji narudžbe"),
                          ],
                        ),
                  Expanded(
                    child: widget.narudzba?.stateMachine == "created"
                        ? TabBarView(
                            children: [
                              _buildOrderDetailsTab(),
                              _buildOffersTab()
                            ],
                          )
                        : TabBarView(
                            children: [
                              _buildOrderDetailsTab(),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        "Detalji narudžbe",
      ),
    );
  }

  Widget _buildOrderDetailsTab() {
    return Column(
      children: [
        _buildOrderDetails(),
        if (widget.narudzba?.stateMachine == 'created') _buildButtonsRow(),
        _buildSetsList()
      ],
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
              ? _buildCard(index)
              : Container();
        },
      ),
    );
  }

  Widget _buildCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ExpansionTile(
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Set ${index + 1} - ${setoviResult?.result[index].cijenaSaPopustom} KM",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            widget.narudzba?.stateMachine == 'created'
                ? IconButton(
                    onPressed: () async {
                      await buildDeleteAlert(context, "Set", "Set",
                          _setoviProvider, setoviResult!.result[index].setId);
                      initForm();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    tooltip: "Obriši Set",
                  )
                : Container(),
          ],
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: setoviResult?.result[index].proizvodiSets.length ?? 0,
            itemBuilder: (context, subIndex) {
              var product = setoviResult?.result[index].proizvodiSets[subIndex];
              return ListTile(
                leading: const Icon(Icons.local_offer, color: Colors.green),
                title: Text(
                  "${product?.proizvod?.naziv ?? ""} - ${product?.proizvod?.cijena} KM x ${product?.kolicina ?? ""} ${product?.proizvod?.jedinicaMjere?.skracenica ?? ""} = ${(product?.kolicina ?? 0) * (product?.proizvod?.cijena ?? 0.0)} KM",
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.narudzba?.ukupnaCijena != null &&
                    widget.narudzba!.ukupnaCijena > 0
                ? ElevatedButton.icon(
                    onPressed: () async {
                      var response = await checkValidity();
                      String errorText = listaValidity.join("\n");
                      if (response == false) {
                        if (mounted) {
                          await buildErrorAlert(
                              context,
                              "Vaša narudžba nije validna",
                              errorText,
                              Exception("Invalid order"));
                        }
                        return;
                      } else {
                        var secret = dotenv.env['SECRETKEY'] ?? "";
                        var clientId = dotenv.env['CLIENTID'] ?? "";

                        var secretValue = (widget.secretKeyValue == "" ||
                                widget.secretKeyValue == null)
                            ? secret
                            : widget.secretKeyValue;

                        var clientValue = (widget.clientIdValue == "" ||
                                widget.clientIdValue == null)
                            ? clientId
                            : widget.clientIdValue;

                        if ((secretValue?.isEmpty ?? true) ||
                            (clientValue?.isEmpty ?? true)) {
                          if (mounted) {
                            await buildErrorAlert(
                                context,
                                "Greška",
                                "Greška sa plaćanjem",
                                Exception("Invalid order"));
                          }
                          return;
                        }

                        List<Map<String, dynamic>> transactions = [];
                        setoviResult?.result.forEach((set) {
                          for (var proizvodSet in set.proizvodiSets) {
                            transactions.add({
                              "name": proizvodSet.proizvod?.naziv ?? "",
                              "quantity": proizvodSet.kolicina,
                              "price": ((proizvodSet.proizvod?.cijena ?? 0.0) *
                                      (1 - (set.popust! / 100)))
                                  .toStringAsFixed(2),
                              "currency": "EUR",
                            });
                          }
                        });

                        if (mounted) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => PaypalCheckoutView(
                              sandboxMode: true,
                              clientId: clientValue,
                              secretKey: secretValue,
                              transactions: [
                                {
                                  "amount": {
                                    "total": widget.narudzba!.ukupnaCijena
                                        .toStringAsFixed(2),
                                    "currency": "EUR",
                                    "details": {
                                      "subtotal": widget.narudzba!.ukupnaCijena
                                          .toStringAsFixed(2),
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description": "Plaćanje narudžbe",
                                  "item_list": {
                                    "items": transactions,
                                  }
                                }
                              ],
                              note: "Hvala Vam na plaćanju",
                              onSuccess: (Map params) async {
                                print(params);
                                var request = {
                                  "brojNarudzbe": widget.narudzba!.brojNarudzbe,
                                  "ukupnaCijena": widget.narudzba!.ukupnaCijena,
                                  "korisnikId": widget.narudzba!.korisnikId,
                                  "nalogId": null,
                                  "placeno": true
                                };
                                var response = await _narudzbaProvider.update(
                                    widget.narudzba!.narudzbaId, request);
                                if (response.narudzbaId ==
                                    widget.narudzba!.narudzbaId) {
                                  await _narudzbaProvider.narudzbeState(
                                      action: "inprogress",
                                      id: widget.narudzba?.narudzbaId);
                                }
                                if (context.mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              },
                              onError: (error) {
                                print(error);
                                Navigator.pop(context);
                              },
                              onCancel: () {},
                            ),
                          ))
                              .then((result) async {
                            if (result == true) {
                              widget.narudzba = await _narudzbaProvider
                                  .getById(widget.narudzba!.narudzbaId);
                              setState(() {});
                              if (mounted) {
                                await buildSuccessAlert(context, "Plaćanje",
                                    "Uspješno ste izvršili uplatu, vaša narudžba se sada nalazi u procesu.",
                                    isDoublePop: false);
                              }
                            }
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.payment, color: Colors.white),
                    label: const Text("Plaćanje",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                : Container(),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () async {
                bool? response = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddProductSetScreen(
                      narudzba: widget.narudzba,
                    ),
                  ),
                );
                if (response == true) {
                  if (mounted) {
                    buildSuccessAlert(context, "Set uspješno dodan!",
                        "Uspješno ste dodali set u narudžbu.",
                        isDoublePop: false);
                  }
                  await initForm();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Dodaj Set",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detalji narudžbe",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Divider(color: Colors.grey),
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
          _buildDetailRow("Ukupna cijena:",
              "${widget.narudzba?.ukupnaCijena.toStringAsFixed(2)} KM"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersTab() {
    return ListView.builder(
      itemCount: offersResult?.result.length ?? 0,
      itemBuilder: (context, index) {
        final offer = offersResult?.result[index];
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PonudeDetailsScreen(ponuda: offer)));
            },
            child: Card(
              color: Colors.green.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.green.shade700, width: 2),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                title: Text("Ponuda ${index + 1}: ${offer?.naziv}"),
                subtitle: Text("Popust ${offer?.popust} %"),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await _ponudeProvider.addOfferToOrder(
                        ponudaId: offer?.ponudaId,
                        narudzbaId: widget.narudzba?.narudzbaId);
                    if (context.mounted) {
                      await buildSuccessAlert(context, "Uspješno dodano!",
                          "Ponuda je dodana u narudzbu.",
                          isDoublePop: false);
                    }
                    initForm();
                  },
                  child: const Text("Odaberi"),
                ),
              ),
            ));
      },
    );
  }
}
