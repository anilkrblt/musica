// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
// SpotifyService classınızı buraya ekleyin veya ayrı bir dosyada tutun ve burada import edin.
class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Bozuka')),
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 50, // Dairenin yarıçapını ayarlar
              backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/tr/8/83/DarthVader.JPG'),
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
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
              Container(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Örnek için liste öğe sayısı.

                  itemBuilder: (context, index) {
                    return Container(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Padding'i kaldır
                          shape: RoundedRectangleBorder(
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
              padding: EdgeInsets.only(right: 50),
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
              padding: EdgeInsets.only(right: 50),
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

Color renk() => Color.fromARGB(255, 101, 3, 54);
BoxDecoration genelTema() => const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 8, 0, 0), // En koyu renk
          Color.fromARGB(255, 175, 22, 124), // Beyaz renk (geçiş sonu)
        ],
      ),
    );
