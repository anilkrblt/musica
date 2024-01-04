// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/database/user_crud.dart';
import 'package:musica/music_player.dart';
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
    _audioService.setPlaylist(
        muzikler
            .map((sarki) => sarki['sarkiUrl'] as String?)
            .where((url) => url != null)
            .cast<String>()
            .toList(),
        muzikler);
  }

  void onTrackTap(int index) {
    final songCRUD = SongCRUD(DatabaseHelper.instance);
    final userId = CurrentUser().userId;
    if (userId != null) {
 
      songCRUD.addRecentPlayed(_audioService.playlistDetay[index], userId);
    }
    _audioService.playTrack(index).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _audioService.isPlaying
          ? MusicPlayerControls(audioService: _audioService)
          : null,
      resizeToAvoidBottomInset: false,
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
        backgroundColor: renk3(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: genelTema(),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: calmaListeKapakResmi(),
            ),
            Expanded(
              flex: 2,
              child: Container(
                // margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        playlist_adi,
                        style: const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      margin: EdgeInsets.only(bottom: 5),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 150),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_muzikler.isNotEmpty) {
                                        _audioService.playlist
                                            .shuffle();

                                        setState(() {});
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: renk5(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(17.0),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                          bottom: 10),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(left: 12),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Karışık",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: renk4(),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.shuffle,
                                              color: renk4(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                              Positioned(
                                left: 20,
                                child: Container(
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  child: ElevatedButton(
                                      onPressed: () {_audioService.playTrack(0);},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(17.0),
                                        ),
                                        primary: renk3(), // Arka plan rengi
                                        onPrimary: beyaz() // Yazı rengi,
                                        ,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Çal",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.play_arrow,
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: _muzikler.isNotEmpty
                    ? sarkiListele()
                    : Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Column(
                          // Yatay padding ayarı
                          children: [
                            Text("Çalma listen boş", style: TextStyle(color: beyaz(), fontSize: 25)),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/AramaSayfasi');
                                },
                                style: ElevatedButton.styleFrom(

                                  backgroundColor: renk6(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 6, ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:   BorderRadius.circular(10),
                                  )
                                ),
                                child:  Text("Şarkı Ekle", style: TextStyle(color: renk4())),
                              ),
                              Expanded(child: Container())
                            ]),
                    ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Image calmaListeKapakResmi() {
    if (_muzikler.isNotEmpty) {
      String resimUrl = _muzikler[0]['image'];
      if (resimUrl.isNotEmpty) {
        return Image.network(resimUrl);
      } else {
        return Image.asset("assets/image/muzik_notasi.png");
      }
    } else {
      return Image.asset("assets/image/muzik_notasi.png");
    }
  }

  ListView sarkiListele() {
    return ListView.builder(
        itemCount: _muzikler.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text(
              "${index + 1}",
              style: TextStyle(color: beyaz(), fontSize: 20),
            ),
            title: Text(
              "${_muzikler[index]['title']}",
              style: TextStyle(
                  color: beyaz(), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              //_audioService.playTrack(index);
              onTrackTap(index);
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
