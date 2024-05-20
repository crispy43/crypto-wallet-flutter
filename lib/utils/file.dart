import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile(String path) async {
  final String localPath = await _localPath;
  return File('$localPath$path');
}

Future<String> readFileToString(String path) async {
  final File file = await _localFile(path);
  return file.toString();
}
