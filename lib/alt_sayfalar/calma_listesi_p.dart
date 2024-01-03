// ignore_for_file: non_constant_identifier_names


import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/music_player.dart';
import 'package:musica/play_music_sayfasi.dart';
import 'package:musica/profil_sayfasi.dart';

class CalmaListesi extends StatefulWidget {
  final String calmaListeAdi;
  final int calmaListeId;
  const CalmaListesi(
      {required this.calmaListeAdi, required this.calmaListeId, super.key});

  @override
  State<CalmaListesi> createState() => _CalmaListesiState();
}

class _CalmaListesiState extends State<CalmaListesi> {
  late String playlist_adi;
  late int playlist_id;
  List<Map<String, dynamic>> _muzikler = [];
  late final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    playlist_adi = widget.calmaListeAdi;
    playlist_id = widget.calmaListeId;
    _muzikleriGetir();
  }

  Future<void> _muzikleriGetir() async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);
    final muzikler = await songCRUD.findSongsByPlaylist(widget.calmaListeId);
    setState(() {
      _muzikler = muzikler;
    });
    _audioService.setPlaylist(muzikler
        .map((sarki) => sarki['sarkiUrl'] as String?)
        .where((url) => url != null)
        .cast<String>()
        .toList());
  }

  // Şarkıya tıklama fonksiyonu
  void onTrackTap(int index) {
    _audioService.playTrack(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _audioService.isMusicPlaying ? MusicPlayerControls(audioService: _audioService) : null,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Çalma Listesi',
          textAlign: TextAlign.end,
        ),
        backgroundColor: renk2(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: genelTema(),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: calmaListeKapakResmi(),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 15),
                child: Column(
                  children: [
                    Text(
                      playlist_adi,
                      style: const TextStyle(fontSize: 25),
                    ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 150),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Row(
                                        children: [
                                          Text(
                                            "  Karışık",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: renk2(),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                if (_muzikler.isNotEmpty) {
                                                  _muzikler.shuffle();
                                                  setState(() {});
                                                }
                                              },
                                              icon: Icon(Icons.shuffle,
                                                  color: renk2())),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            Positioned(
                              left: 20,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      backgroundColor:
                                          renk2(), // Arka plan rengi
                                      foregroundColor:
                                          Colors.white // Yazı rengi,
                                      ,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                          bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Çal",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                _audioService.playTrack(0);
                                              },
                                              icon: const Icon(
                                                Icons.play_arrow,
                                              ))
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: _muzikler.isNotEmpty
                    ? sarkiListele()
                    : Column(
                        // Yatay padding ayarı
                        children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/AramaSayfasi');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4), // Buton içi dolgu
                                // Diğer stil ayarları...
                              ),
                              child: const Text("Şarkı Ekle"),
                            ),
                            Expanded(child: Container())
                          ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Image calmaListeKapakResmi() {
    String resimUrl = _muzikler[0]['image'];
    
   

    return Image.network(resimUrl);
  }

  ListView sarkiListele() {
    return ListView.builder(
        itemCount: _muzikler.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: renk2(),
            child: ListTile(
              leading: Text(
                "${index + 1}",
                style: TextStyle(color: beyaz(), fontSize: 20),
              ),
              title: Text(
                _muzikler[index]['title'],
                style: TextStyle(
                    color: beyaz(), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _audioService.playTrack(index);
              },
              subtitle: Text(
                "${_muzikler[index]['artist']} - ${_muzikler[index]['duration']}",
                style: TextStyle(color: beyaz(), fontSize: 18),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.delete_forever, color: beyaz()),
                  onPressed: () {
                    calmaListesindenKaldir(
                        playlist_id, _muzikler[index]['spotify_id']);
                  }),
            ),
          );
        });
  }

  void calmaListesindenKaldir(int playlistId, String songId) async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);
    try {
      await songCRUD.removeSongFromPlaylist(playlistId, songId);

      setState(() {
        _muzikler.removeWhere((sarki) => sarki['spotify_id'] == songId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Şarkı çalma listesinden kaldırıldı')),
        );
      });
    } catch (e) {
      print('Çalma listesinden şarkı kaldırılırken hata oluştu: $e');
    }
  }
}
