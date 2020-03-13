import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

write(String contactName, double bill, String trip, String date) async {
  final Directory directory = await getExternalStorageDirectory();
  final File file = File('${directory.path}/${contactName.replaceAll(' ', '')}' + DateTime.now().toString() + '.txt');
  print('File Path: ${file.path}');
  await file.writeAsString('$contactName\nDate: $date\nLocation: $trip ................. \$$bill');
}