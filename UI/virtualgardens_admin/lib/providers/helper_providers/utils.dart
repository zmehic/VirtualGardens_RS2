import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:advanced_datatable/datatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('#,##0.00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

String formatDateString(String? dateString) {
  if (dateString != null) {
    DateTime dateTime = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    return formatter.format(dateTime);
  } else {
    return "";
  }
}

Future? getImage() async {
  File? image;
  String? base64Image;

  var result = await FilePicker.platform.pickFiles(type: FileType.image);

  if (result != null && result.files.single.path != null) {
    image = File(result.files.single.path!);

    int fileSizeInBytes = await image.length();
    double fileSizeInMb = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMb > 2) {
      return null;
    } else {
      base64Image = base64Encode(await image.readAsBytes());
      return base64Image;
    }
  }
}

Widget buildFormBuilderTextField(
    {required String label,
    required String name,
    bool obscureText = false,
    bool isRequired = false,
    bool isEmail = false,
    int? maxLength,
    int? minLength,
    String? match,
    bool isValidated = true,
    String matchErrorText = "Uneseni podaci se ne \npoklapaju sa poljima."}) {
  return Expanded(
    child: FormBuilderTextField(
      obscureText: obscureText,
      name: name,
      validator: isValidated
          ? FormBuilderValidators.compose([
              if (isRequired == true)
                FormBuilderValidators.required(
                    errorText: "$label je obavezno polje."),
              if (isEmail == true)
                FormBuilderValidators.email(
                    errorText: "Unesite ispravnu email adresu."),
              if (maxLength != null)
                FormBuilderValidators.maxLength(maxLength,
                    errorText:
                        "Polje $label ne smije sadržavati \nviše od $maxLength znakova."),
              if (minLength != null)
                FormBuilderValidators.minLength(minLength,
                    errorText:
                        "Polje $label mora sadržavati \nnajmanje $minLength znakova."),
              if (match != null)
                FormBuilderValidators.match(match, errorText: matchErrorText),
            ])
          : null,
      decoration: InputDecoration(labelText: label),
    ),
  );
}

Future<String?> chooseAnImage(BuildContext context) async {
  var image = await getImage();
  if (image == null) {
    if (context.mounted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: "Informacija",
        text:
            "Niste odabrali sliku ili ona premašuje veličinu od 2 MB. Ukoliko spremite promjene ukloniti ćete postojeću fotografiju.",
        confirmBtnText: "U redu",
      );
      return null;
    }
  } else {
    if (context.mounted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Slika uspješno dodana",
        text: "Uspješno ste odabrali sliku.",
        confirmBtnText: "U redu",
      );
    }
  }
  return image.toString();
}

Future<dynamic> buildSuccessAlert(
    BuildContext context, String title, String text,
    {bool isDoublePop = true}) async {
  return await QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: title,
    text: text,
    confirmBtnText: "U redu",
    onConfirmBtnTap: () {
      Navigator.of(context).pop();
      if (isDoublePop == true) {
        Navigator.of(context).pop(true);
      }
    },
  );
}

Future<dynamic> buildErrorAlert(
    BuildContext context, String title, String text, Exception e) async {
  return await QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    text: e.toString().split(': ')[1],
    title: "Greška",
    confirmBtnText: "U redu",
    onConfirmBtnTap: () {
      Navigator.of(context).pop();
    },
  );
}

Future<dynamic> buildDeleteAlert(BuildContext context, String title,
    String text, BaseProvider provider, int id) async {
  return await QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: "Potvrda brisanja",
    text: "Jeste li sigurni da želite obrisati $title",
    confirmBtnText: "U redu",
    onConfirmBtnTap: () async {
      try {
        await provider.delete(id);
        if (context.mounted) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "Brisanje je uspješno završeno!",
            confirmBtnText: "U redu",
            text: "Uspješno ste obrisali $title",
            onConfirmBtnTap: () {
              Navigator.of(context).pop();
            },
          );
        }
      } on Exception catch (e) {
        if (context.mounted) {
          await buildErrorAlert(context, "Greška", e.toString(), e);
        }
      }

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    },
  );
}

Widget buildResultView(AdvancedPaginatedDataTable table) {
  return Expanded(
    child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(32, 76, 56, 1),
          border: Border.all(color: Colors.white, width: 3),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: SingleChildScrollView(child: table)),
  );
}
