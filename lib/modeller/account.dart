import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/profil_sayfasi.dart';

class Giris extends StatefulWidget {
  const Giris({super.key});

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: renk3(),
        actions:  [
          Container(
            margin: EdgeInsets.only(right: 10, ),
            child:
            Tema().isDarkModeEnabled
                ? IconButton(
              icon: Icon(Icons.wb_sunny, color: beyaz()), // Gece modu açıkken gözüken ikon
              onPressed: () {
                setState(() {
                  Tema().isDarkModeEnabled = false;
                });
              },
            )
                : IconButton(
              icon: Icon(Icons.nightlight_round, color: beyaz()), // Gece modu kapalıyken gözüken ikon
              onPressed: () {
                setState(() {
                  Tema().isDarkModeEnabled = true;
                });
              },
            ),
          ),]
      ),
      body: Container(
        decoration: genelTema(),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
                flex: 6, child: Image.network("https://picsum.photos/200/300")),
            Expanded(
                flex: 3,
                child: Container(
                  // ignore: sort_child_properties_last
                  child: Text(
                    "Milyonlarca şarkı.\n      Tek adres.",
                    style: TextStyle(
                        color: beyaz(),
                        fontSize: 40,
                        fontWeight: FontWeight.w900),
                  ),
                  margin: const EdgeInsets.only(top: 30),
                )),
            // Container()
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 55, right: 55),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Hemen katıl.",
                            style: TextStyle(
                                color: beyaz(),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/RegisterScreen');
                              },
                              child:  Padding(
                                padding: EdgeInsets.all(17.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.person_add_alt_1_rounded, color: renk3()),
                                    Text(
                                      "Hesap oluştur",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: renk3()
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Zaten bir hesabın var mı?",
                            style: TextStyle(
                                color: beyaz(),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/LoginScreen');
                                },
                                child:  Padding(
                                  padding: EdgeInsets.all(17.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.person, color: renk3(),),
                                      Text(
                                        "Giriş yap",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          color: renk3()
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
