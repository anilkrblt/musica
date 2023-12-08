import 'package:flutter/material.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/database/database_helper.dart';

class Favoriler extends StatefulWidget {
  const Favoriler({super.key});

  @override
  State<Favoriler> createState() => _FavorilerState();
}

class _FavorilerState extends State<Favoriler> {
  List<Map<String, dynamic>> _favoriSarkilar = []; // Başlangıçta boş liste ile başlat

  @override
  void initState() {
    super.initState();
    _favoriSarkilariGetir();
  }

  Future<void> _favoriSarkilariGetir() async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);
    try {
      final favoriler = await songCRUD.getFavoriteSongs();
      setState(() {
        _favoriSarkilar = favoriler;
      });
    } catch (e) {
      // Hata yönetimi için bir şeyler yapın
      // ignore: avoid_print
      print('Veritabanı hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorilerim'),
      ),
      body: _favoriSarkilar.isNotEmpty
          ? ListView.builder(
              itemCount: _favoriSarkilar.length,
              itemBuilder: (context, index) {
                final sarki = _favoriSarkilar[index];
                return ListTile(
                  title: Text(sarki['title'] ?? 'Başlıksız'),
                  subtitle: Text(sarki['artist'] ?? 'Sanatçı Bilinmiyor'),
                  leading: sarki['image'] != null ? Image.network(sarki['image']) : const Icon(Icons.music_note),
                );
              },
            )
          : const Center(
              child: Text('Favori şarkılarınız bulunmamaktadır.'),
            ),
    );
  }
}
