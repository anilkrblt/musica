import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/play_music_sayfasi.dart';
import 'package:musica/profil_sayfasi.dart';

import 'song_model.dart';

class TurCalmaListesi extends StatefulWidget {
  int turIndex;
  TurCalmaListesi({super.key, required this.turIndex});

  @override
  State<TurCalmaListesi> createState() => _TurCalmaListesiState();
}

class _TurCalmaListesiState extends State<TurCalmaListesi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Çalma Listesi',textAlign: TextAlign.end, ),
      backgroundColor:renk2(),),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: genelTema(),
        child: Column(
          children: [
            Expanded(
              flex:5,
              child: Container(

                child: Image.network('https://picsum.photos/200/300', width: MediaQuery.of(context).size.width,),
               //margin: EdgeInsets.only(top: 20),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(top:5, bottom: 15),
                child: Column(children: [
                  Container(child: Text("${Song.songs[widget.turIndex].title}",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: beyaz()),),
                    margin: EdgeInsets.only(bottom: 10),),
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    child: Row(
                     // mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Stack(children: [

                          Container(
                            margin: EdgeInsets.only(left: 150),
                            child: ElevatedButton(onPressed: (){},

                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:   BorderRadius.circular(17.0),
                                  ),
                                ),

                                child: Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10,bottom:10),

                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Row(

                                      children: [
                                        Text("Karışık", style: TextStyle(fontSize: 20, color: renk2(), fontWeight: FontWeight.bold), ),
                                        Icon(Icons.shuffle, color: renk2(),),
                                      ],),
                                  ),
                                )),
                          ),
                          Positioned(
                            left: 20,
                            child: Container(
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: ElevatedButton(onPressed: (){},

                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:   BorderRadius.circular(17.0),
                                    ),
                                      primary: renk2(), // Arka plan rengi
                                      onPrimary: Colors.white// Yazı rengi,
                                    ,
                                  ),
                                  child: Container(

                                    padding: EdgeInsets.only(left: 20, right: 20, top: 10,bottom:10),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      children: [

                                        Text("Çal", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
                                        Icon(Icons.play_arrow, )
                                      ],),
                                  )),
                            ),
                          ),

                        ],


                        )

                    ],),
                  )

                ],),
              ),
            ),
            Expanded(

              flex: 5,
              child: Container(
                padding:EdgeInsets.only(left: 10, right: 10),
                child: ListView.builder(
                  itemCount:10,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Text("${index+1}", style: TextStyle(color: beyaz(),fontSize: 20),),
                      title: Text("Şarkı adı" , style: TextStyle(color: beyaz(),  fontSize: 24, fontWeight: FontWeight.bold),),
                      onTap: (){},
                      subtitle: Text("Sanatçı - süre" , style: TextStyle(color: beyaz(), fontSize: 18),),
                      trailing: IconButton(icon:Icon(Icons.more_vert, color: beyaz()),
                
                        onPressed: (){},  ),
                    );
                  }
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}