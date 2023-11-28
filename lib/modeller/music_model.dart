// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui';

class Muzik {
  String isim;
  String id;
  String sanatci;
  AudioElement dosya;
  Image resim;
  Muzik(
      {required this.isim,
      required this.id,
      required this.sanatci,
      required this.dosya,
      required this.resim});
}
