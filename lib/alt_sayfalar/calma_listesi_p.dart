// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/song_crud.dart';
import 'package:musica/play_music_sayfasi.dart';
import 'package:musica/profil_sayfasi.dart';

class CalmaListesi extends StatefulWidget {
  final String calmaListeAdi;
  final int calmaListeId;
  const CalmaListesi(
      {required this.calmaListeAdi, required this.calmaListeId, super.key});

  @override
  State<CalmaListesi> createState() => _CalmaListesiState();
}

class _CalmaListesiState extends State<CalmaListesi> {
  late String playlist_adi;
  late int playlist_id;
  List<Map<String, dynamic>> _muzikler = [];
  @override
  void initState() {
    super.initState();
    playlist_adi = widget.calmaListeAdi;
    playlist_id = widget.calmaListeId;
    _muzikleriGetir();
  }

  Future<void> _muzikleriGetir() async {
    final dbHelper = DatabaseHelper.instance;
    final songCRUD = SongCRUD(dbHelper);
    try {
      final muzik = await songCRUD.findSongIdsByPlaylist(playlist_id);
      setState(() {
        _muzikler = List<Map<String, dynamic>>.from(muzik);
      });
    } catch (e) {
      print('Veritabanı hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("$_muzikler +++++++++++++++++++++++++++");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Çalma Listesi',
          textAlign: TextAlign.end,
        ),
        backgroundColor: renk2(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: genelTema(),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                child: Image.network(
                  'https://picsum.photos/200/300',
                  width: MediaQuery.of(context).size.width,
                ),
                //margin: EdgeInsets.only(top: 20),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 15),
                child: Column(
                  children: [
                    Text(
                      playlist_adi,
                      style: TextStyle(fontSize: 25),
                    ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 150),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17.0),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Karışık",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: renk2(),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                if (_muzikler.isNotEmpty) {
                                                  _muzikler.shuffle();
                                                  setState(() {});
                                                }
                                              },
                                              icon: Icon(Icons.shuffle,
                                                  color: renk2())),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            Positioned(
                              left: 20,
                              child: Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(17.0),
                                      ),
                                      primary: renk2(), // Arka plan rengi
                                      onPrimary: Colors.white // Yazı rengi,
                                      ,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                          bottom: 10),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Çal",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.play_arrow,
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: _muzikler.isNotEmpty
                    ? sarkiListele()
                    : TextButton(
                        child: Text("Şarklı Ekle"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/AramaSayfasi');
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView sarkiListele() {
    print("$_muzikler ++++++++++++++++++");
    return ListView.builder(
        itemCount: _muzikler.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text(
              "${index + 1}",
              style: TextStyle(color: beyaz(), fontSize: 20),
            ),
            title: Text(
              _muzikler[index]['title'],
              style: TextStyle(
                  color: beyaz(), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            onTap: () {},
            subtitle: Text(
              "${_muzikler[index]['artist']} - ${_muzikler[index]['duration'] % 60}",
              style: TextStyle(color: beyaz(), fontSize: 18),
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_vert, color: beyaz()),
              onPressed: () {
                //çalma listesinden kaldır
              },
            ),
          );
        });
  }
}
