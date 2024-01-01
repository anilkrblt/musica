import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';

import 'play_music_sayfasi.dart';


class ProfilSayfasi extends StatefulWidget {
  final String name;
  const ProfilSayfasi({super.key, required this.name});

  @override
  State<ProfilSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
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
                    child: Container(
                      //margin: const EdgeInsets.only(top: 80, left: 50),
                      child: Row(
                        children: [
                           Expanded(flex: 2,
                             child: CircleAvatar(
                                                       radius: 60,
                                                       backgroundImage: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/tr/8/83/DarthVader.JPG',
                                                       ),
                                                     ),
                           ),
                          Expanded(flex: 3,
                            child: Container(
                              margin:  EdgeInsets.only(top: 30),
                              child:  Column(
                                children: [
                                  Text(
                                   " ${widget.name}", style: TextStyle(color: Colors.white,fontSize: 30),
                                  ),
                                  Text(
                                    "Kullanıcı adı", style: TextStyle(color: Colors.white,fontSize: 15),
                            
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3,
                  child: Card(
                    shadowColor: Colors.black,
                    elevation: 10,
                    margin: EdgeInsets.only(top: 30,),
                    color: renk2(),
                    child: Center(
                      child: Container(
                      margin: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Elemanları simetrik olarak düzenler
                          children: [
                            Column(
                              children: [
                                Text("Takip edilen", style: TextStyle(fontSize: 20, color: beyaz()),),
                                Text("31", style: TextStyle(fontSize: 35, color: beyaz(), fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Takipçi", style: TextStyle(fontSize: 20, color: beyaz()),),
                                Text("24", style: TextStyle(fontSize: 35, color: beyaz(), fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Beğeniler", style: TextStyle(fontSize: 20, color: beyaz()),),
                                Text("255", style: TextStyle(fontSize: 35, color: beyaz(), fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(flex : 8, child: SizedBox())

              ],
            ),
          ),
        )
    );
  }
}

BoxDecoration genelTema3() => const BoxDecoration(
  gradient: LinearGradient(
    end: Alignment.bottomLeft,
    begin: Alignment.centerRight,
    tileMode: TileMode.mirror,

    colors: [
      Color.fromARGB(255, 50, 29, 112),// En koyu renk
      Color.fromARGB(255, 203, 109, 46), // Beyaz renk (geçiş sonu)
    ],
  ),
);
Color beyaz() => const Color.fromARGB(255, 255, 255, 255);