import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  final String fileName;

  Storage({required this.fileName});

  Future<String> readFile() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      print(await File('$path/$fileName').readAsString());
      return File('$path/$fileName').readAsString();
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> writeFile(String data) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      File('$path/$fileName').writeAsString(data);
    } catch (e) {
      print(e);
    }
  }
}
