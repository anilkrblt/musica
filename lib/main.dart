import 'package:flutter/material.dart';
import 'package:musica/alt_sayfalar/ayarlar_p.dart';
import 'package:musica/alt_sayfalar/favoriler_p.dart';
import 'package:musica/alt_sayfalar/son_dinlenenler_p.dart';
import 'package:musica/alt_sayfalar/tum_sarkilar_p.dart';
import 'package:musica/arama_sayfasi.dart';
import 'package:musica/modeller/login_screen.dart';
import 'package:musica/modeller/register_screen.dart';

import 'modeller/account.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'MyCustomFont',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Giris(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/AramaSayfasi': (context) => const Arama_Sayfasi(),
        '/RegisterScreen': (context) => const RegisterScreen(),
        //'/AnaSayfa':(context) => const AnaSayfa(username: ),
        //'/ProfilSayfasi':(context) => const ProfilSayfasi(),

        '/TumSarkilar': (context) => const TumSarkilarSayfasi(),

        '/SonDinlenenler': (context) => const SonDinlenenler(),
        '/Favoriler': (context) =>  Favoriler(control: 0,),
        '/Ayarlar': (context) => const Ayarlar()
      },
    );
  }
}
