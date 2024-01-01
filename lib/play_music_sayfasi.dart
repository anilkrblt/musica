import 'package:audioplayers/audioplayers.dart';
import 'package:marquee/marquee.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';


// ignore: must_be_immutable
class PlayMusic extends StatefulWidget {
  final String sarkiAd;
  final String sanatciAd;
  final String sure;
  final String sarkUrl;
  final String image;
  PlayMusic(
      {required this.sarkiAd,
      required this.sanatciAd,
      required this.sure,
      required this.sarkUrl,
      required this.image,
      Key? key})
      : super(key: key);

  @override
  State<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  late String sarkiAdi;
  late String sanatciAdi;
  late String sarkiSuresi;
  late String sarkiUrl;
  late String sarkiImage;
  late double _maxSliderValue;
  late AudioPlayer audioPlayer;
  Color dominantColor =
      Colors.blue; //başlangıçta hata vermesin diye değer atadım
  Color vibrantColor = Colors.blue;
  late PaletteGenerator _generator;
  static BoxDecoration? bd;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    sarkiAdi = widget.sarkiAd;
    sanatciAdi = widget.sanatciAd;
    sarkiSuresi = widget.sure;
    sarkiUrl = widget.sarkUrl;
    sarkiImage = widget.image;
    _maxSliderValue = _maxValueBul(sarkiSuresi);
    arkaPlanRengi();
  }

  void arkaPlanRengi() async {
    _generator =
        await PaletteGenerator.fromImageProvider((NetworkImage(sarkiImage)));
    dominantColor = _generator.dominantColor!.color;
    vibrantColor = _generator.vibrantColor!.color;
    setState(() {
      bd = BoxDecoration(
          gradient: LinearGradient(
        colors: [dominantColor, vibrantColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ));
    });
  }

  void _oynat() async {
    await audioPlayer.play(UrlSource(widget.sarkUrl));
    setState(() {
      _isPlaying = true;
    });
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _maxSliderValue = d.inSeconds.toDouble();
      });
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _sliderValue = p.inSeconds.toDouble();
      });
    });
  }

  void _durdur() async {
    await audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  double _sliderValue = 0.0;
  bool _isPlaying = false;
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dominantColor,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: renk1(),
            size: 38,
          ),
          onPressed: () {
            _isPlaying = false;
            Navigator.pop(context, _isPlaying);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: renk1(),
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: bd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 6,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.transparent, Colors.black],
                    stops: [0.0, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  sarkiImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ListTile(
                  title: sarkiAdi.length < 10
                      ? Text(sarkiAdi,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                      : Marquee(
                          text: "$sarkiAdi ",
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                  subtitle: Text(sanatciAdi,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white60)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  width: 350,
                  height: 150,
                  margin: const EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      slider(),
                      Text(
                        //buraya alternetif çözüm bul
                        '${_formatDuration(_sliderValue)}                                               ${_formatDuration(_maxSliderValue)}',
                        style: const TextStyle(
                            fontSize: 20, color: Colors.white60),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Geri(),
                            IconButton(
                              icon: Icon(
                                _isPlaying
                                    ? Icons.pause_circle_outline
                                    : Icons.play_circle_outline_outlined,
                                size: 70,
                                color: _isPlaying ? Colors.white : Colors.white,
                              ),
                              onPressed: () {
                                if (_isPlaying) {
                                  _durdur();
                                } else {
                                  _oynat();
                                }
                              },
                            ),
                            const Ileri(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.only(left: 50, right: 50),
        color: vibrantColor,
        child: Row(
          children: [
            IconButton(
              padding: const EdgeInsets.only(right: 220),
              icon: const Icon(
                Icons.settings,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                // eğer önce dinlenen şarkı varsa önceki çalsın yoksa rengi gri olsun
              },
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.downloading_outlined,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  //Müziği downloads klasörüne indirsin
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Slider slider() {
    return Slider(
      thumbColor: Colors.white,
      activeColor: Colors.white,
      inactiveColor: renk1(),
      value: _sliderValue.clamp(0.0, _maxSliderValue),
      min: 0.0,
      max: _maxSliderValue,
      onChanged: (double value) {
        setState(() {
          _sliderValue = value;
        });
      },
    );
  }

  double _maxValueBul(String sarkiSuresi) {
    double toplamSure = 0.0;
    List<String> saatDakikaSaniye = sarkiSuresi.split(':');
    toplamSure = toplamSure + double.tryParse(saatDakikaSaniye[0])! * 60;
    toplamSure = toplamSure + double.tryParse(saatDakikaSaniye[1])!;
    return toplamSure;
  }
}

class Ileri extends StatelessWidget {
  const Ileri({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.skip_next_outlined,
        size: 50,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/ProfilSayfasi');
      },
    );
  }
}

class Geri extends StatelessWidget {
  const Geri({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.skip_previous_outlined,
        size: 50,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/ProfilSayfasi');
      },
    );
  }
}

String _formatDuration(double value) {
  final duration = Duration(seconds: value.round());
  return '${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
}


