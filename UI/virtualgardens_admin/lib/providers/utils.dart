import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

String formatDateString(String dateString) {
  // Parse the date string to DateTime
  DateTime dateTime = DateTime.parse(dateString);

  // Create a DateFormat instance to format the date
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  // Format the DateTime object to a string
  return formatter.format(dateTime);
}
