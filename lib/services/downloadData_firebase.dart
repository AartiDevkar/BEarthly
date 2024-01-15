import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> downloadAndSaveCSV() async {
  try {
    // Replace 'path/to/your/data.csv' with the actual path in your Firebase Storage
    final Reference ref =
        FirebaseStorage.instance.ref().child('path/to/your/data.csv');

    // Download data as a byte buffer
    final Uint8List? data = await ref.getData();

    // Save data to a local file
    final File localFile = File('local/path/to/save/data.csv');
    await localFile.writeAsBytes(data as List<int>);

    print('Data downloaded and saved successfully!');
  } catch (e) {
    print('Error: $e');
  }
}

void main() async {
  await downloadAndSaveCSV();
}
