// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:musica/alt_sayfalar/calma_listesi_p.dart';
import 'package:musica/alt_sayfalar/favoriler_p.dart';
import 'package:musica/arama_sayfasi.dart';
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
  //List<String> turListesi = ["Pop", "Rap", "Rock", "Jazz", "Türkü"];
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
        children: [anaSayfa(widget: widget, searchController: _searchController, songs: songs),Favoriler(control: 0,),ProfilSayfasi(name: widget.username,),
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
      )
    );

  }

}

class anaSayfa extends StatefulWidget {
  const anaSayfa({
    super.key,
    required this.widget,
    required TextEditingController searchController,
    required this.songs,
  }) : _searchController = searchController;

  final AnaSayfa widget;
  final TextEditingController _searchController;
  final List<Song> songs;

  @override
  State<anaSayfa> createState() => _anaSayfaState();
}

class _anaSayfaState extends State<anaSayfa> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              /*    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilSayfasi(name: widget.username,)));*/
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                  (ProfilSayfasi(name: widget.widget.username)
                  )
                  )
              );
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
        backgroundColor: renk3(),
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
              flex: 1,
              child: Container(
                  margin: EdgeInsets.only(right: 100,  ),
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
              flex: 6,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [SizedBox(
                      height: 34,
                      child: Text("  Trend müzikler", style: TextStyle(fontSize: 20, color:beyaz(), fontWeight: FontWeight.bold,), )),
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          ListView.builder(
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
                                        padding: EdgeInsets.zero, // Padding'i kaldır
                                        shape: const RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
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
                                          onTap:(){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => (TurCalmaListesi(turIndex: index ,)
                                                )
                                                )
                                            );
                                          } ,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 7,
                                                    child: Center(
                                                      child: Text(
                                                        widget.songs[index].title,
                                                        style: TextStyle(
                                                            color: renk3(),
                                                            fontSize: 25,
                                                            fontWeight:
                                                            FontWeight.w900),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Icon(
                                                        Icons.play_circle,
                                                        color: renk3(),
                                                        size: 33,
                                                      )),
                                                ],
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                              ),
                                            ),
                                          ),
                                        ),
                                        color: Colors.white70.withOpacity(0.8),
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
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("  Çalma listelerim", style: TextStyle(fontSize: 20, color: beyaz(), fontWeight: FontWeight.w700),  )),
                    Playlists("playlist 1"),
                    Playlists("playlist 2"),
                    Playlists("playlist 3"),



                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Card Playlists(title) {
    return Card(
      margin: EdgeInsets.only(bottom: 20, ),
      shadowColor: Colors.black,
      elevation: 10,
      color: renk2(),
      child: ListTile(
        title: Text(title, style: TextStyle(color: beyaz(), fontWeight: FontWeight.bold, fontSize: 17),),
        subtitle: Text("3 şarkı", style: TextStyle(color: beyaz(), ),),
        leading: Image.network("https://picsum.photos/200/300"),
        trailing: IconButton(icon:Icon(Icons.play_circle, color: beyaz()),

          onPressed: (){},  ),
      ),
    );
  }
}

Color renk1() =>  Color.fromARGB(255, 101, 3, 54);

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
)
    : BoxDecoration(color: Colors.black);


class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class ZamanMetni extends StatelessWidget {
  final String name;

  ZamanMetni({required this.name});

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
  bool isDarkModeEnabled = false;
}
