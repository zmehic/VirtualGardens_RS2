import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_mobile/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_mobile/layouts/master_screen.dart';
import 'package:virtualgardens_mobile/models/ponuda.dart';
import 'package:virtualgardens_mobile/models/search_result.dart';
import 'package:virtualgardens_mobile/models/setovi_ponude.dart';
import 'package:virtualgardens_mobile/providers/ponude_provider.dart';
import 'package:virtualgardens_mobile/providers/product_provider.dart';
import 'package:virtualgardens_mobile/providers/setovi_ponude_provider.dart';

class PonudeDetailsScreen extends StatefulWidget {
  Ponuda? ponuda;
  PonudeDetailsScreen({super.key, this.ponuda});

  @override
  State<PonudeDetailsScreen> createState() => _PonudeDetailsScreenState();
}

class _PonudeDetailsScreenState extends State<PonudeDetailsScreen> {
  late PonudeProvider _ponudeProvider;
  late SetoviPonudeProvider _setoviPonudeProvider;
  late ProductProvider _proizvodiProvider;

  bool isLoading = true;
  SearchResult<SetoviPonude>? setoviPonudeResult;

  final TextEditingController _offerNameController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ponudeProvider = context.read<PonudeProvider>();
    _setoviPonudeProvider = context.read<SetoviPonudeProvider>();
    _proizvodiProvider = context.read<ProductProvider>();

    _offerNameController.text = widget.ponuda?.naziv ?? "Unnamed Offer";
    _discountController.text = widget.ponuda?.popust?.toString() ?? "0";
    initForm();
  }

  Future initForm() async {
    var isDeleted = false;
    var filter = {
      'PonudaId': widget.ponuda?.ponudaId,
      'isDeleted': isDeleted,
      'IncludeTables': "Set"
    };

    if (widget.ponuda != null) {
      setoviPonudeResult = await _setoviPonudeProvider.get(filter: filter);
      if (setoviPonudeResult != null) {}
    }
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
          color: const Color.fromRGBO(235, 241, 224, 1),
          child: Column(
            children: [
              _buildBanner(),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ),
      "Detalji",
    );
  }

  Widget _buildBanner() {
    return Container(
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(size: 45, color: Colors.white, Icons.edit_note_rounded),
            SizedBox(width: 10),
            Text(
              "Detalji o ponudi",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Arial",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _offerNameController,
              label: "Offer Name",
              hintText: "Enter the offer name",
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _discountController,
              label: "Discount (%)",
              hintText: "Enter the discount",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            _buildResultsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      enabled: false,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildResultsSection() {
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
            "Sets in Offer",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          widget.ponuda != null
              ? _buildResultView()
              : const Center(
                  child: Text(
                    "No sets available.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: setoviPonudeResult != null
          ? setoviPonudeResult?.result.length
          : 0, // Replace with actual count of sets
      itemBuilder: (context, index) {
        return setoviPonudeResult != null &&
                setoviPonudeResult?.result[index] != null &&
                setoviPonudeResult!.result[index].set!.proizvodiSets.length <= 3
            ? _buildExpansionTile(index)
            : Container();
      },
    );
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
        title: Text(
          "Set ${index + 1}",
          style: const TextStyle(color: Colors.black),
        ),
        textColor: Colors.white,
        children: [
          ListTile(
            title: Text(
                "${setoviPonudeResult?.result[index].set?.proizvodiSets[0].proizvod?.naziv}"),
          ),
          ListTile(
            title: Text(
                "${setoviPonudeResult?.result[index].set?.proizvodiSets[1].proizvod?.naziv}"),
          ),
          ListTile(
            title: Text(
                "${setoviPonudeResult?.result[index].set?.proizvodiSets[2].proizvod?.naziv}"),
          ),
        ],
      ),
    );
  }
}
