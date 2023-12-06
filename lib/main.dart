import 'package:flutter/material.dart';
import 'package:musica/alt_sayfalar/ayarlar_p.dart';
import 'package:musica/alt_sayfalar/calma_listesi_p.dart';
import 'package:musica/alt_sayfalar/favoriler_p.dart';
import 'package:musica/alt_sayfalar/son_dinlenenler_p.dart';
import 'package:musica/alt_sayfalar/tum_sarkilar_p.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/arama_sayfasi.dart';
import 'package:musica/modeller/login_screen.dart';
import 'package:musica/modeller/register_screen.dart';
import 'package:musica/play_music_sayfasi.dart';
import 'package:musica/profil_sayfasi.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
          '/': (context) => const LoginScreen(),
        '/PlayMusic':(context) => const PlayMusic(),
        '/AramaSayfasi':(context) => const Arama_Sayfasi(),
        '/RegisterScreen':(context) =>  const RegisterScreen(),
        '/AnaSayfa':(context) => const AnaSayfa(),
        '/ProfilSayfasi':(context) => const ProfilSayfasi(),
        '/TumSarkilar': (context) => const TumSarkilarSayfasi(),
        '/CalmaListesi': (context) => const CalmaListesi(),
        '/SonDinlenenler':(context) => const SonDinlenenler(),
        '/Favoriler':(context) => const Favoriler(),
        '/Ayarlar':(context) => const Ayarlar()
      },
    );
  }
}
