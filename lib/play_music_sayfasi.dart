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
      bottomNavigationBar: SizedBox(
        height: 300,
        child: BottomAppBar(
          child: Container(
            decoration: genelTema(),
            child: Column(
              children: [
                Slider(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/ProfilSayfasi');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline_outlined,
                          size: 50,
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
                      IconButton(
                        icon: const Icon(
                          Icons.skip_next_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/ProfilSayfasi');
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: EdgeInsets.only(right: 200, top: 60),
                      icon: const Icon(
                        Icons.settings,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/ProfilSayfasi');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: IconButton(
                        icon: const Icon(
                          Icons.downloading_outlined,
                          size: 35,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/ProfilSayfasi');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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

BoxDecoration genelTema2() => const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
