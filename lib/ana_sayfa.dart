// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:musica/arama_sayfasi.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Musica')),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilSayfasi()));
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
      body: Stack(children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: genelTema(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: ZamanMetni(
                    name: widget.username,
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/AramaSayfasi');
                    },
                    child: AbsorbPointer(
                      absorbing:
                          true, // AbsorbPointer'ı true olarak ayarlayarak dokunma etkisizleştirilir.
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: renk2(),
                            spreadRadius: 25, // Gölgeli alanın genişliği
                            blurRadius: 10, // Gölgeli alanın bulanıklığı
                            //offset: Offset(0),
                          )
                        ]),
                        child: TextField(
                          controller: _searchController,
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
              SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
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
                                    songs[index].coverUrl,
                                    fit: BoxFit
                                        .cover, // Resmi tamamen kaplayacak şekilde ayarla
                                  ),
                                ),
                                onPressed: () => {}, // Boş bir fonksiyon
                              ),
                              Positioned(
                                child: Card(
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
                                                songs[index].title,
                                                style: TextStyle(
                                                    color: renk2(),
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
                                                color: renk2(),
                                                size: 33,
                                              )),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
      ]),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 117, 23, 239),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              padding: const EdgeInsets.only(right: 50),
              icon: const Icon(
                Icons.home_sharp,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                //Navigator.pushNamed(context, '/ProfilSayfasi');
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
                Navigator.pushNamed(context, '/CalmaListesi');
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
}

Color renk() => const Color.fromARGB(255, 101, 3, 54);
BoxDecoration genelTema() => const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 117, 23, 239), // En koyu renk
          Color.fromARGB(255, 169, 158, 255),

          /// Beyaz renk (geçiş sonu)
        ],
      ),
    );

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
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.left,
    );
  }
}
