import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/play_music_sayfasi.dart';
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
        backgroundColor: renk2(),
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
                        fontSize: 35,
                        fontWeight: FontWeight.w900),
                  ),
                  margin: EdgeInsets.only(top: 30),
                )),
            // Container()
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 55, right: 55),
                child: Container(
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
                                child: const Padding(
                                  padding: EdgeInsets.all(17.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.person_add_alt_1_rounded),
                                      Text(
                                        "Hesap oluştur",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
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
                                  child: const Padding(
                                    padding: EdgeInsets.all(17.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.person),
                                        Text(
                                          "Giriş yap",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
