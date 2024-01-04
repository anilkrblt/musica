// ignore_for_file: unnecessary_this

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:musica/ana_sayfa.dart';

class MusicPlayerControls extends StatefulWidget {
  final AudioService audioService;

  const MusicPlayerControls({required this.audioService, Key? key})
      : super(key: key);

  @override
  State<MusicPlayerControls> createState() => _MusicPlayerControlsState();
}

class _MusicPlayerControlsState extends State<MusicPlayerControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: renk2(),
      child: calanMuzik(),
    );
  }

  Widget calanMuzik() {
    return Card(
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: ListTile(
              title:
                  "${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]}"
                              .length <
                          15
                      ? Text(
                          widget.audioService.playlistDetay[widget.audioService
                              .currentTrackIndex]['title'], // Şarkı adı
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      : SizedBox(
                          height: 60,
                          child: Marquee(
                            text: "${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['title']}" ==
                                    'null'
                                ? "${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['name']}"
                                : "${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['title']}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            blankSpace: 30,
                          ),
                        ),
              subtitle: Text(
                '${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['artist']}',
                style: const TextStyle(color: Colors.black),
              ),
              leading: Image.network(widget.audioService
                      .playlistDetay[widget.audioService.currentTrackIndex]
                  ['image']),
            ),
          ),
          Flexible(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.audioService.previousTrack();
                    });
                  },
                  icon: const Icon(Icons.skip_previous))),
          Flexible(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  if (widget.audioService.isPlaying) {
                    widget.audioService.pause();
                  } else {
                    widget.audioService.play(widget.audioService
                        .playlist[widget.audioService.currentTrackIndex]);
                  }
                },
                icon: Icon(widget.audioService.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
              )),
          Flexible(
              flex: 1,
              child: IconButton(
                  onPressed: () => setState(() {
                        widget.audioService.nextTrack();
                      }),
                  icon: const Icon(Icons.skip_next)))
        ],
      ),
    );
  }
}

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool get isMusicPlaying =>
      _isPlaying && _audioPlayer.state != PlayerState.completed;

  List<String> playlist = [];
  List<Map<String, dynamic>> playlistDetay = [];
  int currentTrackIndex = 0;

  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioService._internal() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentPosition = newPosition;
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      nextTrack();
    });
  }

  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  void setPlaylist(
      List<String> newPlaylist, List<Map<String, dynamic>> newPlaylistDetay) {
    this.playlist = newPlaylist;
    this.playlistDetay = newPlaylistDetay;
    currentTrackIndex = 0;
  }

  Future<void> playTrack(int index) async {
    if (index >= 0 && index < playlist.length) {
      print("$index///////////////////");
      currentTrackIndex = index;
      await play(playlist[index]);
      // Şarkı oynatmaya başladığında _isPlaying'i güncelle
      _audioPlayer.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
        // Burada bir Flutter hatası olabilir çünkü bu callback, widget'ın durumunu güncelleyebilir.
        // Bu nedenle, bu callback içindeki kodu dikkatli kullanmalısınız.
      });
    }
  }

  Future<void> play(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  void pause() {
    _audioPlayer.pause();
  }

  void stop() {
    _audioPlayer.stop();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void nextTrack() {
    if (currentTrackIndex < playlist.length - 1) {
      playTrack(currentTrackIndex + 1);
    }
  }

  void previousTrack() {
    if (currentTrackIndex > 0) {
      playTrack(currentTrackIndex - 1);
    }
  }
}
