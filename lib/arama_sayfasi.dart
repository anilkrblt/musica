import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:audioplayers/audioplayers.dart';
import 'package:musica/alt_sayfalar/favoriler_p.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/database/user_crud.dart';
import 'package:musica/play_music_sayfasi.dart';
import 'package:musica/profil_sayfasi.dart';
import 'spotify_service.dart';

// ignore: camel_case_types
class Arama_Sayfasi extends StatefulWidget {
  final String username;
   Arama_Sayfasi({ super.key, required this.username,});

  @override
  State<Arama_Sayfasi> createState() => _Arama_SayfasiState();
}

// ignore: camel_case_types
class _Arama_SayfasiState extends State<Arama_Sayfasi> {
  TextEditingController _searchController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _tracks = [];
  List<Map<String, dynamic>> _calmaListeleri = [];
  final userId = CurrentUser().userId;
  List<String> aramaGecmisi = [];
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  late bool isInPlaylist;
  Future<void> _calmaListeleriniGetir() async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);
    try {
      final playlist = await songCRUD.getPlaylists(userId!);
      setState(() {
        _calmaListeleri = List<Map<String, dynamic>>.from(playlist);
      });
    } catch (e) {
      print('Veritabanı hatası: $e');
    }
  }

  Future<void> _searchTracks() async {
    //aramaGecmisi.add(_searchController.text);
    int? userId = CurrentUser().userId;
    _addSearchHistoryToDatabase(userId!, _searchController.text);
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

  Future<void> _addSearchHistoryToDatabase(int userId, String query) async {
    final userCRUD = UserCRUD(DatabaseHelper.instance);
    try {
      await userCRUD.addSearchHistory(userId, query);
      _loadSearchHistory();
    } catch (e) {
      print('Arama geçmişi eklenirken hata oluştu: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _playPreview(String previewUrl, track) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text('Çalma Listesine Ekle'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      title: const Text('Çalma Listesi Seçin'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int index = 0;
                              index < _calmaListeleri.length;
                              index++)
                            ListTile(
                              leading: const Icon(Icons.music_note),
                              title: Text(_calmaListeleri[index]['name']),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _calmaListesineEkle(track, index);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Kapat'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _loadFavoriSarkilar();
    _calmaListeleriniGetir();
    _loadSearchHistory();
  }

  late Set<String> _favoriSarkilar = {};
  late Set<String> yeniFav = {};
  late Set<String> eskiFav = {};

  Future<void> _loadSearchHistory() async {
    final dbHelper = DatabaseHelper.instance;
    final userCRUD = UserCRUD(dbHelper);
    int? userId = CurrentUser().userId;
    try {
      final history = await userCRUD.getSearchHistory(userId!);
      setState(() {
        aramaGecmisi = history.map((e) => e['query'] as String).toList();
      });
    } catch (e) {
      print('Arama geçmişi yüklenirken hata: $e');
    }
  }

  void _deleteSearchHistory(int index) async {
    final dbHelper = DatabaseHelper.instance;
    final userCRUD = UserCRUD(dbHelper);

    int? userId = CurrentUser().userId;

    if (userId == null) {
      print('Kullanıcı girişi yapılmamış.');
      return;
    }

    String query = aramaGecmisi[index];

    try {
      final history = await userCRUD.getSearchHistory(userId);
      final historyItem = history.firstWhere(
        (e) => e['query'] == query,
        orElse: () => {},
      );

      if (historyItem.isNotEmpty) {
        int id = historyItem['id'];
        await userCRUD.deleteSearchHistory(id);
        setState(() {
          aramaGecmisi.removeAt(index);
        });
      }
    } catch (e) {
      print('Arama geçmişi silinirken hata: $e');
    }
  }

  Future<void> _loadFavoriSarkilar() async {
    final songCRUD = SongCRUD(DatabaseHelper.instance);
    final favoriSarkilar = await songCRUD.getFavoriteSongs();
    yeniFav =
        favoriSarkilar.map((sarki) => sarki['spotify_id'].toString()).toSet();
    if (yeniFav != eskiFav) {
      setState(() {
        _favoriSarkilar = favoriSarkilar
            .map((sarki) => sarki['spotify_id'].toString())
            .toSet();
      });
    }
  }

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

  void _calmaListesineEkle(Map<String, dynamic> song, index) async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);
    final List<Map<String, dynamic>> playlists =
        await songCRUD.getPlaylists(userId!);

    if (playlists.isNotEmpty) {
      final int playlistId = playlists[index]['id'];

      try {
        await songCRUD.addSongToPlaylist(playlistId, song);
        print('Şarkı çalma listesine eklendi');
      } catch (e) {
        print('Hata oluştu: $e');
      }
    } else {
      print('Çalma listesi bulunamadı');
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadFavoriSarkilar();
    return Scaffold(
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              autofocus: true,
              controller: _searchController,
              focusNode: _focusNode,
              onSubmitted: (value) => _searchTracks(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: const Icon(Icons.clear)),
                fillColor: Colors.white,
                filled: true,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'Müzik ya da sanatçı ara',
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: genelTema(),
        child: Column(
          children: [
            if (_isFocused) aramaGecmisiTamami(),
            muzikleriListele(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                padding: EdgeInsets.only(right: 50),
                icon: Icon(
                  Icons.favorite_border_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Favoriler( username: widget.username,control: 1),
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
      ),
    );
  }

  Expanded aramaGecmisiTamami() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            aramaGecmisiYazisi(),
            aramaGecmisiniGoruntule(),
          ],
        ),
      ),
    );
  }

  Expanded muzikleriListele() {
    return Expanded(
      flex: 5,
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
                  '${track['artist']} - ${track['duration']}',
                  style: const TextStyle(color: Colors.white),
                ),
                leading: Image.network(track['image']),
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
                    if (track.containsKey('id') && track['id'] != null) {
                      _favoriDegistir(track);
                    } else {
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
                              sarkiId: track['id'],
                              sarkiAd: track['name'],
                              sanatciAd: track['artist'],
                              sure: track['duration'],
                              sarkUrl: track['previewUrl'],
                              image: track['image'],
                            )),
                  );
                },
                onLongPress: () {
                  _playPreview(track['previewUrl'], track);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Padding aramaGecmisiYazisi() {
    return Padding(
      padding: const EdgeInsets.only(left: 17.0),
      child: Text("Arama geçmişi",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: beyaz(), fontSize: 27, fontWeight: FontWeight.bold)),
    );
  }

  Expanded aramaGecmisiniGoruntule() {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
            itemCount: aramaGecmisi.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  setState(() {
                    _searchController =
                        TextEditingController(text: aramaGecmisi[index]);
                  });
                },
                title: Text(
                  aramaGecmisi[index],
                  style: TextStyle(fontSize: 20, color: beyaz()),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: beyaz()),
                  onPressed: () {
                    setState(() {
                      _deleteSearchHistory(index);
                      _loadSearchHistory();
                    });
                  },
                ),
              );
            }),
      ),
    );
  }
}
