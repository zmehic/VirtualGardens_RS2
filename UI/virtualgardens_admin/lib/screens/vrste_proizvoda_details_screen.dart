import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/vrste_proizvoda_provider.dart';

class VrsteProizvodaDetailsScreen extends StatefulWidget {
  final VrstaProizvoda? vrstaProizvoda;
  const VrsteProizvodaDetailsScreen({super.key, this.vrstaProizvoda});

  @override
  State<VrsteProizvodaDetailsScreen> createState() =>
      _VrsteProizvodaDetailsScreenState();
}

class _VrsteProizvodaDetailsScreenState
    extends State<VrsteProizvodaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};

  late VrsteProizvodaProvider _provider;

  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _provider = context.read<VrsteProizvodaProvider>();
    super.initState();

    initForm();
  }

  Future initForm() async {
    _initialValue = {
      "naziv": widget.vrstaProizvoda?.naziv,
    };
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
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                actions: <Widget>[Container()],
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  widget.vrstaProizvoda != null
                      ? "Detalji o vrsti proizvoda"
                      : "Dodaj vrstu proizvoda",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
              ),
              backgroundColor: const Color.fromRGBO(103, 122, 105, 1),
              body: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                color: const Color.fromRGBO(235, 241, 224, 1),
                child: Column(
                  children: [_buildMain()],
                ),
              ),
            )),
        "Detalji o vrsti proizvoda");
  }

  Widget _buildMain() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromRGBO(32, 76, 56, 1),
                child: _buildNewForm(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNewForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(235, 241, 224, 1),
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildFormBuilderTextField(
                      label: "Naziv",
                      name: "naziv",
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(child: _buildSaveButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() == true) {
                debugPrint(_formKey.currentState?.value.toString());
                var request = Map.from(_formKey.currentState!.value);
                setState(() {});
                try {
                  if (widget.vrstaProizvoda == null) {
                    var response = await _provider.insert(request);
                    if (mounted) {
                      await buildSuccessAlert(
                          context,
                          "Uspješno ste dodali vrstu proizvoda",
                          "Vrsta proizvoda ${response.naziv} je dodana");
                    }
                  } else {
                    var response = await _provider.update(
                        widget.vrstaProizvoda!.vrstaProizvodaId!, request);
                    if (mounted) {
                      await buildSuccessAlert(
                          context,
                          "Uspješno ste ažurirali vrstu proizvoda",
                          "Vrsta proizvoda ${response.naziv} je ažurirana");
                    }
                  }
                } on Exception catch (e) {
                  if (mounted) {
                    await buildErrorAlert(context, "Greška", e.toString(), e);
                  }
                  setState(() {});
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(8),
            ),
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ),
        widget.vrstaProizvoda != null
            ? const SizedBox(
                width: 20,
              )
            : Container(),
      ],
    );
  }
}
