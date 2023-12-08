// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:musica/profil_sayfasi.dart';

// ignore: depend_on_referenced_packages
// SpotifyService classınızı buraya ekleyin veya ayrı bir dosyada tutun ve burada import edin.
class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  bool isPlaying = false;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () => Navigator.pushNamed(context, '/AramaSayfasi'),
          ),
        ],
        backgroundColor: renk(),
      ),
      body: Stack(children: [
        Container(
          decoration: genelTema(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Örnek için liste öğe sayısı.

                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Padding'i kaldır
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          backgroundColor: Colors
                              .transparent, // Düğme arka planını saydam yap
                          elevation: 0, // Gölgeyi kaldır
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20), // Resmi yuvarlat
                          child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Stainer.jpg/640px-Stainer.jpg',
                            fit: BoxFit
                                .cover, // Resmi tamamen kaplayacak şekilde ayarla
                          ),
                        ),
                        onPressed: () => {}, // Boş bir fonksiyon
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: renk(),
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
                Navigator.pushNamed(context, '/ProfilSayfasi');
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
                Navigator.pushNamed(context, '/ProfilSayfasi');
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
          Color.fromARGB(255, 255, 183, 206), // En koyu renk
          Color.fromARGB(255, 101, 3, 54), // Beyaz renk (geçiş sonu)
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