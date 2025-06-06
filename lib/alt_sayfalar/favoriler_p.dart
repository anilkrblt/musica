// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/play_music_sayfasi.dart';

import '../profil_sayfasi.dart';

class Favoriler extends StatefulWidget {
  int control;
  final String username;
  Favoriler({super.key, required this.username, required this.control});

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
    if (!mounted) return; // Bu satırı ekleyin
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
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: beyaz(),
            size: 38,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Beğendiklerim',
          style: TextStyle(color: beyaz()),
        ),
        backgroundColor: renk3(),
      ),
      body: _favoriSarkilar.isNotEmpty
          ? Container(
              decoration: genelTema(),
              child: ListView.builder(
                itemCount: _favoriSarkilar.length,
                itemBuilder: (context, index) {
                  final sarki = _favoriSarkilar[index];
                  return Dismissible(
                    key: ValueKey(sarki['spotify_id']), 
                    onDismissed: (direction) {
                      _favoriKaldir(sarki);
                    },
                    
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(11),
                      //decoration: genelTema(),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.delete,
                          color: beyaz(),
                          size: 30,
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(11),
                      //decoration: genelTema(),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.delete,
                          color: beyaz(),
                          size: 30,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        shadowColor: Colors.black,
                        elevation: 10,
                        color: renk2(),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayMusic(
                                    //çalışmazsa kontrol et
                                        sarkiId: sarki['spotify_id'],
                                        sarkiAd: sarki['title'],
                                        sanatciAd: sarki['artist'],
                                        sure: sarki['duration'].toString(),
                                        sarkUrl: sarki['sarkiUrl'].toString(),
                                        image: sarki['image'],
                                      )),
                            );
                          },
                          title: Text(
                            sarki['title'] ?? 'Başlıksız',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: beyaz()),
                          ),
                          subtitle: Text(
                            sarki['artist'] ?? 'Sanatçı Bilinmiyor',
                            style: TextStyle(color: beyaz()),
                          ),
                          leading: sarki['image'] != null
                              ? Image.network(sarki['image'])
                              : const Icon(Icons.music_note),
                          trailing: Text(
                            _formatDuration(parseDuration(sarki['duration'])),
                            style: TextStyle(
                                color: beyaz(),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Container(
            decoration: genelTema(),
            child:  Center(
            
                child: Text('Beğendiğiniz şarkı bulunmamaktadır.',
                style: TextStyle(color: beyaz(), fontSize: 17)),
              ),
          ),
      bottomNavigationBar: widget.control==1
          ?  Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 0),
            ),
          ],
        ),
            child: BottomAppBar(
                    color: renk3(),
                    child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                padding: const EdgeInsets.only(right: 50),
                icon: const Icon(
                  Icons.home_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                padding: const EdgeInsets.only(right: 50),
                icon: const Icon(
                  Icons.favorite,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Favoriler(username: widget.username,control: 1),
                    ),
                  );
                },
              ),

              IconButton(
                icon: const Icon(
                  Icons.person_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilSayfasi( name: widget.username,control: 2),
                    ),
                  );
                },
              ),
            ],
                    ),
                  ),
          )
          : null,
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
      throw const FormatException('Invalid duration format');
    }
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return Duration(minutes: minutes, seconds: seconds);
  }
}
