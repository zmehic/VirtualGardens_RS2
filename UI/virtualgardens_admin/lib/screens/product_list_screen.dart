import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/providers/product_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/screens/product_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<ProductProvider>();
  }

  SearchResult<Proizvod>? result = null;
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        Container(
            child: Column(
          children: [_buildSearch(), _buildResultView()],
        )),
        "Lista proizvoda");
  }

  TextEditingController _ftsEditingController = TextEditingController();
  TextEditingController _cijenaOdEditingController = TextEditingController();
  TextEditingController _cijenaDoEditingController = TextEditingController();

  Widget _buildSearch() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _ftsEditingController,
              decoration: InputDecoration(labelText: "Naziv"),
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _cijenaOdEditingController,
              decoration: InputDecoration(labelText: "Cijena od:"),
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextField(
              controller: _cijenaDoEditingController,
              decoration: InputDecoration(labelText: "Cijena do:"),
            )),
            ElevatedButton(
                onPressed: () async {
                  var filter = {
                    'NazivGTE': _ftsEditingController.text,
                    'CijenaFrom': _cijenaOdEditingController.text,
                    'CijenaTo': _cijenaDoEditingController.text
                  };
                  result = await provider.get(filter: filter);
                  setState(() {});
                },
                child: Text("Pretraga")),
            SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen()));
                },
                child: Text("Dodaj")),
          ],
        ));
  }

  Widget _buildResultView() {
    return Expanded(
      child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
              child: DataTable(
                  columns: [
                DataColumn(label: Text("ID"), numeric: true),
                DataColumn(label: Text("Naziv")),
                DataColumn(label: Text("Cijena")),
                DataColumn(label: Text("Slika")),
              ],
                  rows: result?.result
                          .map((e) => DataRow(
                                  onSelectChanged: (selected) => {
                                        if (selected == true)
                                          {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailsScreen(
                                                                product: e)))
                                          }
                                      },
                                  cells: [
                                    DataCell(Text(e.proizvodId.toString())),
                                    DataCell(Text(e.naziv ?? "")),
                                    DataCell(Text(formatNumber(e.cijena))),
                                    DataCell(e.slika != null
                                        ? Container(
                                            width: 100,
                                            height: 100,
                                            child: imageFromString(e.slika!),
                                          )
                                        : Text(""))
                                  ]))
                          .toList()
                          .cast<DataRow>() ??
                      []))),
    );
  }
}
