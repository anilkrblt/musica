import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayerControls extends StatelessWidget {
  final AudioService audioService;

  const MusicPlayerControls({required this.audioService, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            onChanged: (value) {
              audioService.seek(Duration(seconds: value.toInt()));
            },
            value: audioService.currentPosition.inSeconds.toDouble(),
            min: 0,
            max: audioService.totalDuration.inSeconds.toDouble(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () => audioService.previousTrack(),
              ),
              IconButton(
                icon: Icon(audioService.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (audioService.isPlaying) {
                    audioService.pause();
                  } else {
                    audioService.play(audioService.play("url") as String);
                  }
                },
              ),
             
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () => audioService.nextTrack(),
              ),
            ],
          ),
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
  bool get isMusicPlaying => _isPlaying && _audioPlayer.state != PlayerState.completed;

  List<String> _playlist = []; 
  int _currentTrackIndex = 0; 

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

  void setPlaylist(List<String> playlist) {
    _playlist = playlist;
    _currentTrackIndex = 0; 
  }

  Future<void> playTrack(int index) async {

    if (index >= 0 && index < _playlist.length) {
      _currentTrackIndex = index; 
      await play(_playlist[index]);
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
    if (_currentTrackIndex < _playlist.length - 1) {
      playTrack(_currentTrackIndex + 1);
    }
  }

  void previousTrack() {
    if (_currentTrackIndex > 0) {
      playTrack(_currentTrackIndex - 1);
    }
  }

}
