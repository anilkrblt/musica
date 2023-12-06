import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';

class PlayMusic extends StatefulWidget {
  const PlayMusic({Key? key}) : super(key: key);

  @override
  State<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  double _sliderValue = 0.0;
  double _maxSliderValue = 50.0;
  int _durationInSeconds = 60;
  Timer? _timer;
  bool _isPlaying = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 183, 206),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: renk(), size: 38,),
          onPressed: (){},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share,color: renk(), size: 30,),
            onPressed: (){},
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: genelTema(),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ListTile(
                title: Text("Şarkı adı", style: TextStyle(fontSize: 35,
                    fontWeight: FontWeight.bold, color: Colors.white )),
                subtitle: Text("Sanatçı", style: TextStyle(fontSize: 20,color: Colors.white60)),

              ),
            ),
            Center(

              child: Container(

                  child: Column(
                    children: [

                      slider(),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Geri(),
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
                                _pause();
                              } else {
                                _play();
                              }
                            },
                          ),
                          Ileri(),
                        ],
                      ) ,
                    ],
                  ),
                width: 350,
                height: 150,
                margin: EdgeInsets.only(top: 25),
              ),
            ),
          ],
        ),
      ),
     bottomNavigationBar: BottomAppBar(
       padding: EdgeInsets.only(left: 50,right: 50),
       color: renk(),
       child: Row(
         children: [
           IconButton(
             padding: EdgeInsets.only(right: 220),
             icon: const Icon(
               Icons.settings,
               size: 35,
               color: Colors.white,
             ),
             onPressed: () {
               Navigator.pushNamed(context, '/ProfilSayfasi');
             },
           ),
           IconButton(
             icon: const Icon(
               Icons.downloading_outlined,
               size: 35,
               color: Colors.white,
             ),
             onPressed: () {
               Navigator.pushNamed(context, '/ProfilSayfasi');
             },
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
                inactiveColor: renk(),
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

  void _play() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_sliderValue < _maxSliderValue) {
          _sliderValue += 0.1;
        } else {
          _timer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });

      if (_sliderValue >= _maxSliderValue) {
        _timer?.cancel();
        setState(() {
          _isPlaying = false;
        });
      }
    });
    setState(() {
      _isPlaying = true;
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
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

BoxDecoration genelTema2() => const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
