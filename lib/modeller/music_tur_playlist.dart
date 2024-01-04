// ignore_for_file: unnecessary_string_interpolations, sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/database/user_crud.dart';
import 'package:musica/music_player.dart';
import 'package:musica/profil_sayfasi.dart';
import 'song_model.dart';
import 'package:musica/spotify_service.dart';

// ignore: must_be_immutable
class TurCalmaListesi extends StatefulWidget {
  int turIndex;


  TurCalmaListesi({super.key, required this.turIndex});
  @override
  State<TurCalmaListesi> createState() => _TurCalmaListesiState();
}

class _TurCalmaListesiState extends State<TurCalmaListesi> {
  List<Map<String, dynamic>> calinacakMuzikler = [];
  final userId = CurrentUser().userId;
  late final AudioService _audioService = AudioService();
  final spotifyService = SpotifyService();

  Future<List<Map<String, dynamic>>>? tracksFuture;
  late Set<String> _favoriSarkilar = {};
  void _favoriDegistir(Map<String, dynamic> track) async {
    final songCRUD = SongCRUD(DatabaseHelper.instance);
    final trackId = track['id'];
    setState(() {
      if (_favoriSarkilar.contains(trackId)) {
        _favoriSarkilar.remove(trackId);

        // Şarkıyı favorilerden çıkar
        songCRUD.addOrUpdateSong(track, false);
      } else {
        _favoriSarkilar.add(trackId);
        // Şarkıyı favorilere ekle
        songCRUD.addOrUpdateSong(track, true);
        print('favorilere eklendi');
      }
    });
  }

  void _addPlaylist() async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);

    songCRUD.doluOynatmaListesiOlustur(
        userId!, Song.songs[widget.turIndex].title, calinacakMuzikler);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Çalma listesi eklendi')),
    );
  }

  Future<void> loadAndSetTracks() async {
    var tracks = calinacakMuzikler;
    var trackUrls =
        tracks.map((track) => track['previewUrl']).whereType<String>().toList();
    print("$tracks");
    _audioService.setPlaylist(trackUrls, tracks);
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
  void initState() {
    super.initState();
    // loadRockTracks fonksiyonunu burada çağır ve gelecekteki veriyi sakla
    tracksFuture =
        spotifyService.loadRockTracks(Song.songs[widget.turIndex].title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _audioService.isPlaying
          ? MusicPlayerControls(audioService: _audioService)
          : null,
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
        actions: [
          IconButton(
            onPressed: () {
              _addPlaylist();
            },
            icon: Icon(Icons.playlist_add, color: beyaz(), ),
            iconSize: 45,
          )
        ],
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
              child: Image.network(
                'https://picsum.photos/200/300',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            //Butonlar
            Expanded(
              flex: 2,
              child: Container(
               // margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "${Song.songs[widget.turIndex].title}",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: beyaz()),
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
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
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
                                                  color: renk2(),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.shuffle,
                                              color: renk2(),
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
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17.0),
                                        ),
                                        primary: renk2(), // Arka plan rengi
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
          //  SizedBox(width: 10),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: sarkilariListele(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sarkilariListele() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: tracksFuture,
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var sarkilar = snapshot.data!;
          calinacakMuzikler = sarkilar;
          loadAndSetTracks();
          return ListView.builder(
            itemCount: sarkilar.length,
            itemBuilder: (context, index) {
              var sarki = sarkilar[index];

              return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: TextStyle(color: beyaz(), fontSize: 20),
                ),
                title: Text(
                  sarki['name'],
                  style: TextStyle(
                      color: beyaz(),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  onTrackTap(index);
                },
                subtitle: Text(
                  "${sarki['artist']} - ${sarki['duration']}",
                  style: TextStyle(color: beyaz(), fontSize: 18),
                ),
                trailing: IconButton(
                  icon: Icon(
                    _favoriSarkilar.contains(sarki['id'])
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _favoriSarkilar.contains(sarki['id'])
                        ? beyaz()
                        : beyaz(),
                  ),
                  onPressed: () {
                    if (sarki.containsKey('id') && sarki['id'] != null) {
                      _favoriDegistir(sarki);
                    } else {
                      // ignore: avoid_print
                      print('Track data: $sarki');
                    }
                  },
                ),
              );
            },
          );
        } else {
          return Text('Veri yok');
        }
      },
    );
  }
}
