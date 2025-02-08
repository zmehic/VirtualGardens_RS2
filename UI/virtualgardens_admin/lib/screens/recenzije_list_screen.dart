import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RecenzijeListScreen extends StatefulWidget {
  final Proizvod? proizvod;
  const RecenzijeListScreen({super.key, this.proizvod});

  @override
  State<RecenzijeListScreen> createState() => _RecenzijeListScreenState();
}

class _RecenzijeListScreenState extends State<RecenzijeListScreen> {
  late Map<int, String> korisnici = {};
  static const _pageSize = 8;

  late RecenzijeProvider _recenzijeProvider;
  SearchResult<Recenzija>? recenzijeResult;

  bool isLoading = true;

  int korisnik = 0;

  RangeValues selectedRange = const RangeValues(1.0, 5.0);

  String datumOdString = "";
  String datumDoString = "";

  final TextEditingController _ocjenaEditingController =
      TextEditingController();
  final TextEditingController _datumOdEditingController =
      TextEditingController();
  final TextEditingController _datumDoEditingController =
      TextEditingController();

  final PagingController<int, Recenzija?> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _recenzijeProvider = context.read<RecenzijeProvider>();
    initForm();
    korisnici[0] = "Svi";

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, false);
    });

    super.initState();
  }

  Future initForm() async {
    _datumOdEditingController.text = "";
    _datumDoEditingController.text = "";
    _ocjenaEditingController.text = "";

    await _fetchPage(0, true);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchPage(int pageKey, bool reload,
      {RangeValues? values}) async {
    var filter = {
      'OcjenaFrom':
          values != null ? values.start.toInt() : selectedRange.start.toInt(),
      'OcjenaTo':
          values != null ? values.end.toInt() : selectedRange.end.toInt(),
      'DatumFrom': datumOdString,
      'DatumTo': datumDoString,
      'ProizvodId': widget.proizvod?.proizvodId,
      'KorisnikId': korisnik != 0 ? korisnik : null,
      'isDeleted': false,
      'IncludeTables': "Korisnik",
      'PageSize': _pageSize,
      'Page': pageKey + 1,
    };
    try {
      recenzijeResult = await _recenzijeProvider.get(filter: filter);
      final isLastPage = recenzijeResult!.result.length < _pageSize;
      if (isLastPage) {
        if (reload == true && _pagingController.itemList != null) {
          _pagingController.itemList!.clear();
        }

        _pagingController.appendLastPage(recenzijeResult!.result);
        if (_pagingController.itemList != null) {
          for (var element in _pagingController.itemList!) {
            if (korisnici.keys.contains(element!.korisnikId) == false) {
              korisnici[element.korisnikId] =
                  "${element.korisnik?.ime} ${element.korisnik?.prezime}";
            }
          }
        }
      } else {
        if (reload == true && _pagingController.itemList != null) {
          _pagingController.itemList!.clear();
        }
        final nextPageKey = pageKey + 1;

        _pagingController.appendPage(recenzijeResult!.result, nextPageKey);
        if (_pagingController.itemList != null) {
          for (var element in _pagingController.itemList!) {
            if (korisnici.keys.contains(element!.korisnikId) == false) {
              korisnici[element.korisnikId] =
                  "${element.korisnik?.ime} ${element.korisnik?.prezime}";
            }
          }
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader(
            isLoading: isLoading,
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: <Widget>[Container()],
                  iconTheme: const IconThemeData(color: Colors.white),
                  centerTitle: true,
                  title: const Text(
                    "Recenzije",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                ),
                backgroundColor: const Color.fromRGBO(103, 122, 105, 1),
                body: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromRGBO(235, 241, 224, 1),
                  child: Column(
                    children: [_buildSearch(), _buildMain()],
                  ),
                ))),
        "Recenzije");
  }

  Widget _buildSearch() {
    return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(12.0),
        color: const Color.fromRGBO(32, 76, 56, 1),
        child: Row(
          children: [
            _buildDropdown(),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _datumOdEditingController,
                    decoration: const InputDecoration(
                        labelText: "Datum od:", filled: true),
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
                        await _fetchPage(0, true);
                        setState(() {});
                      }
                    },
                  )),
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () async {
                      _datumOdEditingController.clear();
                      datumOdString = "";
                      await _fetchPage(0, true);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _datumDoEditingController,
                    decoration: const InputDecoration(
                        labelText: "Datum do:", filled: true),
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
                        await _fetchPage(0, true);
                        setState(() {});
                      }
                    },
                  )),
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      _datumDoEditingController.clear();
                      datumDoString = "";
                      await _fetchPage(0, true);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Row(
                children: [
                  const Text("Ocjena:", style: TextStyle(color: Colors.white)),
                  Expanded(
                      child: RangeSlider(
                    values: selectedRange,
                    min: 1,
                    max: 5,
                    divisions: 5,
                    inactiveColor: Colors.grey,
                    activeColor: Colors.yellow.shade600,
                    labels: RangeLabels(selectedRange.start.round().toString(),
                        selectedRange.end.round().toString()),
                    onChangeEnd: (values) async {
                      selectedRange = RangeValues(
                          values.start.round().toDouble(),
                          values.end.round().toDouble());
                      await _fetchPage(0, true);
                      setState(() {});
                    },
                    onChanged: (RangeValues value) {
                      selectedRange = value;
                      setState(() {});
                    },
                  )),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: korisnik.toString(),
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        items: korisnici.entries
            .map((item) => DropdownMenuItem(
                  value: item.key.toString(),
                  child: Text(item.value.toString(),
                      style: const TextStyle(color: Colors.black)),
                ))
            .toList(),
        onChanged: (value) async {
          if (value != null) {
            korisnik = int.tryParse(value.toString())!;
            await _fetchPage(0, true);
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _buildMain() {
    return Expanded(
      child: _buildResultView(),
    );
  }

  Widget _buildResultView() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: PagedListView<int, Recenzija?>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Recenzija?>(
            itemBuilder: (context, item, index) {
              return item != null ? _buildExpansionTile(item) : Container();
            },
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text(
                "Nema recenzija",
                style: TextStyle(color: Colors.white),
              ),
            ),
            firstPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ));
  }

  Widget _buildExpansionTile(Recenzija item) {
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
                  child: item.korisnik?.slika != null
                      ? imageFromString(item.korisnik?.slika ?? "")
                      : Image.asset(
                          'assets/images/user.png',
                          fit: BoxFit.cover,
                          width: 24,
                          height: 24,
                        )),
            ),
            const SizedBox(width: 10),
            Text(
              "${item.korisnik?.ime} ${item.korisnik?.prezime} - ${formatDateString(item.datum.toIso8601String())}",
              style: const TextStyle(color: Colors.black),
            ),
            const Spacer(),
            RatingBar(
              ignoreGestures: true,
              allowHalfRating: false,
              minRating: 1,
              maxRating: 5,
              initialRating: item.ocjena.toDouble(),
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
              title: Text(item.komentar ?? "",
                  style: const TextStyle(color: Colors.black))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
