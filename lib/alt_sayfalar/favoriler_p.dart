import 'package:flutter/material.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/play_music_sayfasi.dart';

class Favoriler extends StatefulWidget {
  const Favoriler({super.key});

  @override
  State<Favoriler> createState() => _FavorilerState();
}

class _FavorilerState extends State<Favoriler> {
  List<Map<String, dynamic>> _favoriSarkilar = [];

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
      print('Veritabanı hatası: $e');
    }
  }

  void _favoriKaldir(Map<String, dynamic> track) async {
    final songCRUD = SongCRUD(DatabaseHelper.instance);
    final trackId = track['spotify_id'];

    if (_favoriSarkilar.any((sarki) => sarki['spotify_id'] == trackId)) {
      setState(() {
        _favoriSarkilar = List.from(_favoriSarkilar)
          ..removeWhere((sarki) => sarki['spotify_id'] == trackId);
      });
      await songCRUD.addOrUpdateSong(track, false);
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
                return Dismissible(
                  key: ValueKey(index), // Her öğe için benzersiz bir anahtar
                  onDismissed: (direction) {
                    _favoriKaldir(sarki);
                  },
                  background:
                      Container(color: Colors.red), // Kaydırma arka planı
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlayMusic(
                                  sarkiAd: sarki['title'],
                                  sanatciAd: sarki['artist'],
                                  sure: sarki['duration'].toString(),
                                  sarkUrl: sarki['sarkiUrl'].toString(),
                                  image: sarki['image'],
                                )),
                      );
                    },
                    title: Text(sarki['title'] ?? 'Başlıksız'),
                    subtitle: Text(sarki['artist'] ?? 'Sanatçı Bilinmiyor'),
                    leading: sarki['image'] != null
                        ? Image.network(sarki['image'])
                        : const Icon(Icons.music_note),
                    trailing:
                        Text(_formatDuration(parseDuration(sarki['duration']))),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Favori şarkılarınız bulunmamaktadır.'),
            ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Duration parseDuration(String durationStr) {
    final parts = durationStr.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid duration format');
    }
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return Duration(minutes: minutes, seconds: seconds);
  }
}
