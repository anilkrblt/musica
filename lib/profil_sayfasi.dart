import 'package:flutter/material.dart';

import 'ana_sayfa.dart';

class ProfilSayfasi extends StatefulWidget {
  const ProfilSayfasi({super.key});

  @override
  State<ProfilSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          padding: EdgeInsets.only(top: 2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: genelTema3(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80, left: 50),
                child: Row(
                  children: [  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/tr/8/83/DarthVader.JPG',
                    ),
                  ),
                    Container(
                      margin: EdgeInsets.only(left: 55, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            "İsim", style: TextStyle(color: Colors.white,fontSize: 30),

                          ),
                          Text(
                            "Kullanıcı adı", style: TextStyle(color: Colors.white,fontSize: 15),

                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
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
              )

            ],
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


Color beyaz() => Color.fromARGB(255, 255, 255, 255);