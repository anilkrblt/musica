import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/play_music_sayfasi.dart';
import 'package:musica/profil_sayfasi.dart';
import 'package:sqflite/sqflite.dart';

class SpotifyService {
  final String _clientId = 'd9b578117ffc4b9fbf1f5553a7a72051';
  final String _clientSecret = '50032f2b81ee4d46b8cbfc31d9fc5816';
  final String _baseUrl = 'https://api.spotify.com/v1';

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Access token could not be retrieved');
    }
  }

  Future<List<dynamic>> searchTrack(String query) async {
    final accessToken = await _getAccessToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/search?q=$query&type=track'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['tracks']['items']; // API'nin döndürdüğü şarkı listesi.
    } else {
      throw Exception('Hata!!!');
    }
  }
}

// ignore: camel_case_types
class Arama_Sayfasi extends StatefulWidget {
  const Arama_Sayfasi({super.key});

  @override
  State<Arama_Sayfasi> createState() => _Arama_SayfasiState();
}

// ignore: camel_case_types
class _Arama_SayfasiState extends State<Arama_Sayfasi> {
  TextEditingController _searchController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _tracks = [];

  Future<void> _searchTracks() async {
    aramaGecmisi.insert(0, _searchController.text);
    final spotifyService =
        SpotifyService(); // SpotifyService nesnesi oluşturuldu.

    try {
      final query = _searchController.text;
      final results = await spotifyService.searchTrack(query);
      setState(() {
        _tracks = results.map((track) {
          var previewUrl = track['preview_url'];
          // Preview URL varsa kullan, yoksa null değer ata
          if (previewUrl == null || previewUrl.isEmpty) {
            previewUrl = null;
          }

          return {
            'id': track['id'],
            'name': track['name'],
            'artist': track['artists'][0]['name'],
            'image': track['album']['images'][0]['url'],
            'duration':
                _formatDuration(Duration(milliseconds: track['duration_ms'])),
            'previewUrl': previewUrl, // Preview URL bilgisini ekleyin
          };
        }).toList();
      });
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _playPreview(String previewUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Müzik Önizlemesi'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Şimdi oynatılıyor...'),
            // Burada AudioPlayer widget'ını yerleştirin
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Kapat'),
            onPressed: () {
              audioPlayer.stop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    if (previewUrl.isNotEmpty) {
      audioPlayer.play(UrlSource(previewUrl));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriSarkilar();
  }

  late Set<String> _favoriSarkilar =
      {}; // Favori şarkıların Spotify_ID'lerini saklar

  Future<void> _loadFavoriSarkilar() async {
    final songCRUD = SongCRUD(DatabaseHelper.instance);
    final favoriSarkilar = await songCRUD.getFavoriteSongs();
    print("Favori Şarkılar: $favoriSarkilar"); // Bu satırı ekleyin

    setState(() {
      _favoriSarkilar =
          favoriSarkilar.map((sarki) => sarki['spotify_id'].toString()).toSet();
    });
  }

  void _favoriDegistir(Map<String, dynamic> track) async {
    final songCRUD = SongCRUD(DatabaseHelper.instance);
    final trackId = track['id'];
    print(
        'favori degistir icinde trackID $trackId'); // buradaki track id aslında spotify_id
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

  List<String> aramaGecmisi = [];
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
        backgroundColor: renk2(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
            // padding: EdgeInsets.only(top: 30),
              child: TextField(
                autofocus: true,
                controller: _searchController, // Bu satırı ekleyin
                focusNode: FocusNode(),
                onSubmitted: (value) => _searchTracks(),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: Icon(Icons.clear)),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  hintText: 'Müzik ya da sanatçı ara',
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: genelTema(),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 17.0),
                      child: Text("Arama geçmişi",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: beyaz(),
                              fontSize: 27,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: ListView.builder(
                              itemCount: aramaGecmisi.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      _searchController = TextEditingController(
                                          text: aramaGecmisi[index]);
                                    });
                                  },
                                  title: Text(
                                    "${aramaGecmisi[index]}",
                                    style:
                                        TextStyle(fontSize: 20, color: beyaz()),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: beyaz()),
                                    onPressed: () {
                                      setState(() {
                                        aramaGecmisi.removeAt(index);
                                      });
                                    },
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                itemCount: _tracks.length,
                itemBuilder: (context, index) {
                  final track = _tracks[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      shadowColor: Colors.black,
                      elevation: 10,
                      color: renk2(),
                      child: ListTile(
                        title: Text(
                          track['name'], // Şarkı adı
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        subtitle: Text(
                          '${track['artist']} - ${track['duration']}', // Sanatçı adı ve süre
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: Image.network(track['image']), // Albüm resmi
                        trailing: IconButton(
                          icon: Icon(
                            _favoriSarkilar.contains(track['id'])
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _favoriSarkilar.contains(track['id'])
                                ? beyaz()
                                : beyaz(),
                          ),
                          onPressed: () {
                            if (track.containsKey('id') &&
                                track['id'] != null) {
                              _favoriDegistir(track);
                            } else {
                              // 'id' yok ya da null ise burada uygun bir işlem yapın
                              // ignore: avoid_print
                              print('Track data: $track');
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayMusic(
                                      sarkiAd: track['name'],
                                      sanatciAd: track['artist'],
                                      sure: track['duration'],
                                      sarkUrl: track['previewUrl'],
                                      image: track['image'],
                                    )),
                          );
                        },
                        onLongPress: () {
                          if (track['previewUrl'] == null) {
                            textYaz();
                          } else {
                            _playPreview(track['previewUrl']);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: renk2(),
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
                Icons.favorite_border_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/Favoriler');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.person_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/ProfilSayfasi');
              },
            ),
          ],
        ),
      ),
    );
  }

  void textYaz() {}
}
