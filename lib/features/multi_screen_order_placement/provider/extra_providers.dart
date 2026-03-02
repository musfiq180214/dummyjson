import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class TitledFile {
  final File file;
  final String title;

  TitledFile({required this.file, required this.title});
}

final filePickerProvider =
    StateNotifierProvider<FilePickerNotifier, List<TitledFile>>(
      (ref) => FilePickerNotifier(),
    );

final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, XFile>(
  (ref) => ImagePickerNotifier(),
);

class FilePickerNotifier extends StateNotifier<List<TitledFile>> {
  FilePickerNotifier() : super([]);

  Future<void> pickFiles(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      for (var filePath in result.paths.whereType<String>()) {
        final file = File(filePath);
        final title = await _showTitleDialog(context, file);
        if (title != null && title.trim().isNotEmpty) {
          state = [...state, TitledFile(file: file, title: title.trim())];
        }
      }
    }
  }

  Future<String?> _showTitleDialog(BuildContext context, File file) async {
    String? title;
    return showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(
          text: file.uri.pathSegments.last,
        );
        return AlertDialog(
          title: Text("Enter title for '${file.uri.pathSegments.last}'"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter file title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void clearFiles() {
    state = [];
  }
}

class ImagePickerNotifier extends StateNotifier<XFile> {
  ImagePickerNotifier() : super(XFile(''));

  Future<void> pickFiles(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      state = XFile(pickedFile.path);
    }
  }

  void clearFiles() {
    state = XFile('');
  }
}
