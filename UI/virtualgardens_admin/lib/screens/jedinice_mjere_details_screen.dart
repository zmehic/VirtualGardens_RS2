import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/jedinice_mjere.dart';
import 'package:virtualgardens_admin/providers/jedinice_mjere_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';

class JedinicaMjereDetailsScreen extends StatefulWidget {
  final JediniceMjere? jedinicaMjere;
  const JedinicaMjereDetailsScreen({super.key, this.jedinicaMjere});

  @override
  State<JedinicaMjereDetailsScreen> createState() =>
      _JedinicaMjereDetailsScreenState();
}

class _JedinicaMjereDetailsScreenState
    extends State<JedinicaMjereDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};

  late JediniceMjereProvider _provider;

  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _provider = context.read<JediniceMjereProvider>();
    super.initState();

    initForm();
  }

  Future initForm() async {
    _initialValue = {
      "naziv": widget.jedinicaMjere?.naziv,
      "skracenica": widget.jedinicaMjere?.skracenica,
      "opis": widget.jedinicaMjere?.opis,
    };
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader2(
          isLoading: isLoading,
          isList: false,
          title: widget.jedinicaMjere != null
              ? "Detalji o jedinici mjere"
              : "Dodaj jedinicu mjere",
          actions: <Widget>[Container()],
          child: Column(
            children: [_buildMain()],
          ),
        ),
        "Detalji o jedinici mjere");
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
                      maxLength: 32,
                      label: "Naziv",
                      name: "naziv",
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildFormBuilderTextField(
                        label: "Skracenica",
                        name: "skracenica",
                        isRequired: false,
                        maxLength: 10),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Row(
                  children: [
                    buildFormBuilderTextField(
                        label: "Opis",
                        name: "opis",
                        isRequired: false,
                        maxLength: 100),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
                try {
                  if (widget.jedinicaMjere == null) {
                    var response = await _provider.insert(request);
                    if (mounted) {
                      await buildSuccessAlert(
                          context,
                          "Uspješno ste dodali jedinicu mjere - ${response.naziv}",
                          "Jedinica mjere ${response.naziv} je dodana");
                    }
                  } else {
                    var response = await _provider.update(
                        widget.jedinicaMjere!.jedinicaMjereId!, request);
                    if (mounted) {
                      await buildSuccessAlert(
                          context,
                          "Uspješno ste ažurirali jedinicu mjere - ${response.naziv}",
                          "Jedinica mjere ${response.naziv} je ažurirana");
                    }
                  }
                } on Exception catch (e) {
                  if (mounted) {
                    await buildErrorAlert(
                        context, "Greška", e.toString().split(': ')[1], e);
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
        widget.jedinicaMjere != null
            ? const SizedBox(
                width: 20,
              )
            : Container(),
      ],
    );
  }
}
