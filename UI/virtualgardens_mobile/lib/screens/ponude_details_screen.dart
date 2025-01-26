import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/ponuda.dart';
import 'package:virtualgardens_mobile/models/helper_models/search_result.dart';
import 'package:virtualgardens_mobile/models/setovi_ponude.dart';
import 'package:virtualgardens_mobile/providers/setovi_ponude_provider.dart';

class PonudeDetailsScreen extends StatefulWidget {
  final Ponuda? ponuda;
  const PonudeDetailsScreen({super.key, this.ponuda});

  @override
  State<PonudeDetailsScreen> createState() => _PonudeDetailsScreenState();
}

class _PonudeDetailsScreenState extends State<PonudeDetailsScreen> {
  late SetoviPonudeProvider _setoviPonudeProvider;
  bool isLoading = true;
  SearchResult<SetoviPonude>? setoviPonudeResult;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _setoviPonudeProvider = context.read<SetoviPonudeProvider>();
    initForm();
  }

  Future<void> initForm() async {
    var filter = {
      'PonudaId': widget.ponuda?.ponudaId,
      'isDeleted': false,
      'IncludeTables': "Set"
    };

    setoviPonudeResult = await _setoviPonudeProvider.get(filter: filter);

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
              "Detalji o ponudi",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
          ),
          body: Column(
            children: [_buildMainContent()],
          ),
        ),
      ),
      "Detalji o ponudi",
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailsCard(),
            const SizedBox(height: 20),
            _buildSetsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Naziv ponude:", widget.ponuda?.naziv ?? "N/A"),
            const SizedBox(height: 10),
            _buildDetailRow(
                "Popust (%):", "${widget.ponuda?.popust?.toString() ?? '0'}%"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSetsSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(32, 76, 56, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Setovi u ponudi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          widget.ponuda != null
              ? _buildSetsList()
              : const Center(
                  child: Text(
                    "Nema dostupnih setova.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSetsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: setoviPonudeResult?.result.length ?? 0,
      itemBuilder: (context, index) {
        final setovi = setoviPonudeResult!.result[index];
        return _buildSetCard(setovi, index);
      },
    );
  }

  Widget _buildSetCard(SetoviPonude setovi, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        title: Text(
          "Set ${index + 1}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          ...setovi.set!.proizvodiSets.map((proizvodSet) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    proizvodSet.proizvod?.naziv ?? "Nepoznato",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "${proizvodSet.kolicina} ${proizvodSet.proizvod?.jedinicaMjere?.skracenica ?? ''}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
