import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/database/user_crud.dart';

class ProfilSayfasi extends StatefulWidget {
  final String name;
  const ProfilSayfasi({super.key, required this.name});

  @override
  State<ProfilSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  final songCRUD = SongCRUD(DatabaseHelper.instance);
  final userId = CurrentUser().userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: renk3(),
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
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: genelTema(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Card(
                    shadowColor: Colors.black,
                    elevation: 10,
                    color: renk2(),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/tr/8/83/DarthVader.JPG',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Text(
                              " ${widget.name}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 30),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Son Dinlenenler",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 25),
                Expanded(flex: 8, child: sonDinlenenSarkilariListele())
              ],
            ),
          ),
        ));
  }

  FutureBuilder<List<Map<String, dynamic>>> sonDinlenenSarkilariListele() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: songCRUD.getRecentPlayed(userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // Veri varsa bu kısmı doldur
          var recentPlayed = snapshot.data!;
          return ListView.builder(
            itemCount: recentPlayed.length,
            itemBuilder: (context, index) {
              var song = recentPlayed[index];

              // Burada şarkı bilgilerini gösteren bir widget döndür
              return ListTile(
                textColor: Colors.white,
                title: Text(song['name']),
                subtitle: Text(song['artist']),
                leading: Image.network(song['image']),
                trailing: IconButton(onPressed: (){
                  
                }, icon: const Icon(Icons.favorite)),
                onTap: () {
                  // Burada müziği çalabilirsiniz
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Hata oluştu: ${snapshot.error}');
        } else {
          return const Text('Son dinlenen müzikler yok veya yüklenemedi');
        }
      },
    );
  }
}

BoxDecoration genelTema3() => const BoxDecoration(
      gradient: LinearGradient(
        end: Alignment.bottomLeft,
        begin: Alignment.centerRight,
        tileMode: TileMode.mirror,
        colors: [
          Color.fromARGB(255, 50, 29, 112), // En koyu renk
          Color.fromARGB(255, 203, 109, 46), // Beyaz renk (geçiş sonu)
        ],
      ),
    );
Color beyaz() => const Color.fromARGB(255, 255, 255, 255);
