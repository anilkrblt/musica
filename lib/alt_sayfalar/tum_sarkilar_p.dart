import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TumSarkilarSayfasi extends StatefulWidget {
  const TumSarkilarSayfasi({super.key});

  @override
  State<TumSarkilarSayfasi> createState() => _TumSarkilarSayfasiState();
}

class _TumSarkilarSayfasiState extends State<TumSarkilarSayfasi> {
  List<String> _fileNames = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        _fileNames = result.paths.map((path) => path!.split('/').last).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şarkılarım'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFiles,
              child: const Text('Dosya Seç'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _fileNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_fileNames[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
