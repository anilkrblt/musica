// ignore_for_file: sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names
//ana sayfa
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:musica/alt_sayfalar/calma_listesi_p.dart';
import 'package:musica/alt_sayfalar/favoriler_p.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/modeller/music_tur_playlist.dart';
import 'package:musica/modeller/song_model.dart';
import 'package:musica/play_music_sayfasi.dart';
import 'package:musica/profil_sayfasi.dart';

// ignore: depend_on_referenced_packages
// SpotifyService classınızı buraya ekleyin veya ayrı bir dosyada tutun ve burada import edin.
class AnaSayfa extends StatefulWidget {
  final String username;
  const AnaSayfa({super.key, required this.username});
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<Song> songs = Song.songs;
  bool isPlaying = false;
  final TextEditingController _searchController = TextEditingController();

  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }
  void navigateToPage(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: PageView(
          controller: _pageController,
          children: [
        Sayfam(
          widget: widget,
          searchController: _searchController,
          songs: songs,
          userName: widget.username,
        ),
        Favoriler(control: 0,),
        ProfilSayfasi(
          name: widget.username,
        )
      ],
          onPageChanged: onPageChanged,
      ),
        bottomNavigationBar: BottomAppBar(
          color: renk3(),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                padding: EdgeInsets.only(right: 50),
                icon:  Icon(
                  _currentPageIndex == 0 ?  Icons.home : Icons.home_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  navigateToPage(0);
                },
              ),
              IconButton(
                padding:  EdgeInsets.only(right: 50),
                icon:  Icon(
                  _currentPageIndex == 1 ? Icons.favorite: Icons.favorite_border,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  navigateToPage(1);
                },
              ),
              IconButton(
                icon:  Icon(
                  _currentPageIndex == 2 ? Icons.person: Icons.person_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  navigateToPage(2);
                },
              ),

            ],

          ),
        )
    );
  }
}

class Sayfam extends StatefulWidget {
  const Sayfam({
    super.key,
    required this.widget,
    required TextEditingController searchController,
    required this.songs,
    required this.userName,
  }) : _searchController = searchController;

  final AnaSayfa widget;
  final TextEditingController _searchController;
  final List<Song> songs;
  final String userName;

  @override
  State<Sayfam> createState() => _SayfamState();
}


class _SayfamState extends State<Sayfam> {
  late String calmaListeAdi = '';
  final TextEditingController _playlistNameController = TextEditingController();
  List<Map<String, dynamic>> _calmaListeleri = [];

  Future<void> _calmaListeleriniGetir() async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);
    try {
      final playlist = await songCRUD.getPlaylists();
      setState(() {
        _calmaListeleri = List<Map<String, dynamic>>.from(playlist);
      });
    } catch (e) {
      print('Veritabanı hatası: $e');
    }
  }

  void calmaListesiOlustur() {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çalma Listesi Önizlemesi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _playlistNameController,
              decoration: const InputDecoration(
                labelText: 'Çalma  Listesi Adı',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                calmaListeAdi = _playlistNameController.text;
                int playlistId = await songCRUD.createPlaylist(widget.userName,
                    calmaListeAdi, "https://picsum.photos/200/300");

                setState(() {
                  Map<String, dynamic> yeniCalmaListesi = {
                    'id': playlistId,
                    'userName': widget.userName,
                    'name': calmaListeAdi,
                    'resimUrl': 'https://picsum.photos/200/300',
                  };
                  _calmaListeleri.add(yeniCalmaListesi);
                });

                Navigator.of(context).pop();
              },
              child: Text('Oluştur'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Kapat'),
            onPressed: () {
              _playlistNameController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _calmaListeleriniGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Switch(
            value: Tema().isDarkModeEnabled,
            onChanged: (value) {
              setState(() {
                Tema().isDarkModeEnabled = value;
              });
            },
          )
        ],
       // title: const Center(child: Text('Musica')),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          (ProfilSayfasi(name: widget.widget.username))));
            },
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/tr/8/83/DarthVader.JPG',
              ),
            ),
          ),
        ),
        /* actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () => Navigator.pushNamed(context, '/AramaSayfasi'),
          ),
        ],*/
        backgroundColor: Color.fromARGB(255, 117, 23, 239),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: genelTema(),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.only(
                    right: 100,
                  ),
                  //padding: EdgeInsets.only(top: 3),
                  child: ZamanMetni(
                    name: widget.widget.username,
                  )),
            ),
            Expanded(
              flex: 2,
              child: Container(

                  margin: EdgeInsets.only(bottom: 0, top:10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/AramaSayfasi');
                    },
                    child: AbsorbPointer(
                      absorbing:
                      true, // AbsorbPointer'ı true olarak ayarlayarak dokunma etkisizleştirilir.
                      child: Container(
                        child: TextField(
                          controller: widget._searchController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                            ),
                            hintText: 'Müzik ya da sanatçı ara',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),

            Expanded(
              flex: 7,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(right: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 34,
                        child: Text(
                          "  Trend Müzikler",
                          style: TextStyle(
                            fontSize: 20,
                            color: beyaz(),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Expanded(
                      child: SizedBox(
                        height: 150,
                        child: Stack(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.only(right: 5),
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.songs.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 200,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              right: 5), // Padding'i kaldır
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          backgroundColor: Colors
                                              .transparent, // Düğme arka planını saydam yap
                                          elevation: 0, // Gölgeyi kaldır
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              20), // Resmi yuvarlat
                                          child: Image.asset(
                                            widget.songs[index].coverUrl,
                                            fit: BoxFit
                                                .cover, // Resmi tamamen kaplayacak şekilde ayarla
                                          ),
                                        ),
                                        onPressed: () {}, // Boş bir fonksiyon
                                      ),
                                      Positioned(
                                        child: Card(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          (TurCalmaListesi(
                                                            turIndex: index,
                                                          ))));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 7,
                                                      child: Center(
                                                        child: Text(
                                                          widget.songs[index]
                                                              .title,
                                                          style: TextStyle(
                                                              color: renk2(),
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Icon(
                                                          Icons.play_circle,
                                                          color: renk2(),
                                                          size: 33,
                                                        )),
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                ),
                                              ),
                                            ),
                                          ),
                                          color:
                                              Colors.white70.withOpacity(0.8),
                                        ),
                                        width: 150,
                                        height: 50,
                                        bottom: 10,
                                        left: 25,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  calmaListesiOlustur();
                },
                child: Text('Çalma Listesi Oluştur'),
              ),
            ),
            // var olan çalma listelerini yükle

            Expanded(
              flex: 9,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _calmaListeleri.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Playlists(_calmaListeleri[index]);
                  }),
            ),
          ],
        ),
      ),

    );
  }

  Card Playlists(Map<String, dynamic> title) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shadowColor: Colors.black,
      elevation: 10,
      color: renk2(),
      child: ListTile(
        onLongPress: () => _showPlaylistOptions(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CalmaListesi(
                      calmaListeAdi: title['name'],
                      calmaListeId: title['id'],
                    )),
          );
        },
        title: Text(
          title['name'] ?? '',
          style: TextStyle(
              color: beyaz(), fontWeight: FontWeight.bold, fontSize: 17),
        ),
        leading: calmaListesiResmi(),
        trailing: IconButton(
          icon: Icon(Icons.play_circle, color: beyaz()),
          onPressed: () {},
        ),
      ),
    );
  }

  Image calmaListesiResmi() {
    String resimUrl = "https://picsum.photos/200/${(Random().nextInt(100)+ 200)}";
    String resimUrl2 = "https://e7.pngegg.com/pngimages/892/491/png-clipart-musical-note-music-musical-note-angle-rectangle.png";
 return Image.asset('assets/image/muzik_notasi.png');
  }

  void _showPlaylistOptions(Map<String, dynamic> playlist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Çalma Listesi İşlemleri"),
          content: Text("Çalma listesi üzerinde ne yapmak istiyorsunuz?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yeniden Adlandır"),
              onPressed: () {
                Navigator.of(context).pop();
                _renamePlaylist(playlist);
               
               
              },
            ),
            TextButton(
              child: Text("Sil"),
              onPressed: () {
                Navigator.of(context).pop();
                _deletePlaylist(playlist['id']);
              },
            ),
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _renamePlaylist(Map<String, dynamic> playlist) {
    TextEditingController newNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Çalma Listesini Yeniden Adlandır"),
          content: TextField(
            controller: newNameController,
            decoration: InputDecoration(hintText: "Yeni ad"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Tamam"),
              onPressed: () async {
                // Çalma listesinin adını güncelle
                if (newNameController.text.isNotEmpty) {
                  final songCRUD = SongCRUD(DatabaseHelper.instance);
                  await songCRUD.updatePlaylistName(
                      playlist['id'], newNameController.text);

                  // Başarılı işlem sonrası kullanıcıya bilgi verme ve listeyi yenileme
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Çalma listesi adı güncellendi')),
                  );
                   _calmaListeleriniGetir();
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePlaylist(int playlistId) async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);

    try {
      await songCRUD.deletePlaylist(playlistId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çalma listesi başarıyla silindi')),
      );

      // Çalma listelerini yeniden yükleme veya güncelleme işlemi
      _calmaListeleriniGetir();
      // Örneğin, _loadPlaylists();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çalma listesi silinirken bir hata oluştu: $e')),
      );
    }
  }
}

Color renk() => const Color.fromARGB(255, 101, 3, 54);
Color renk2() => Tema().isDarkModeEnabled
    ? Color.fromARGB(255, 117, 23, 239)
    : Colors.white12;

Color renk3() => Tema().isDarkModeEnabled
    ? Color.fromARGB(255, 117, 23, 239)
    : Colors.black;

BoxDecoration genelTema() => Tema().isDarkModeEnabled
    ? BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 117, 23, 239), // En koyu renk
      Color.fromARGB(255, 169, 158, 255),

          /// Beyaz renk (geçiş sonu)
        ],
      ),
    ): BoxDecoration(color: Colors.black);
  
    


//search bar bu amk
class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        color: Colors.grey[900], // Veya tercih ettiğiniz bir renk
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                // Oynatma işlevselliği
              },
            ),
            const Text("Şarkı Adı - Sanatçı Adı"), // Dinamik şarkı bilgileri
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                // Durdurma işlevselliği
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ZamanMetni extends StatelessWidget {
  final String name;

  const ZamanMetni({super.key, required this.name});

  String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour < 12) {
      return 'Günaydın $name';
    } else if (hour < 18) {
      return 'İyi günler $name';
    } else {
      return 'İyi geceler $name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getGreeting(),
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      textAlign: TextAlign.left,
    );
  }
}

class Tema {
  static final Tema _singleton = Tema._internal();
  factory Tema() {
    return _singleton;
  }
  Tema._internal();
  bool isDarkModeEnabled = true;
}
