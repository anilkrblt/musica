import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/profil_sayfasi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Music Player'),
        ),
        body: MusicPlayerControls(audioService: AudioService()),
      ),
    );
  }
}

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

      color: renk3(), // Change this to your desired color
      child: calanMuzik(),
    );
  }

  Widget calanMuzik() {
    return Dismissible(
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom:4),
        //decoration: genelTema(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            Icons.skip_previous,
            color: beyaz(),
            size: 40,
          ),
        ),
      ),
      secondaryBackground: Container(

        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(11),
        //decoration: genelTema(),
        child: Icon(
          Icons.skip_next,
          color: beyaz(),
          size: 40,
        ),
      ),
      key: Key(widget.audioService.currentTrackIndex.toString()),
      onDismissed: (direction) {
        setState(() {
          if (direction == DismissDirection.startToEnd) {
            // Swipe to the right
            widget.audioService.previousTrack();
          } else if (direction == DismissDirection.endToStart) {
            // Swipe to the left
            widget.audioService.nextTrack();
          }
        });
      },
      child: Card(
        color: renk3(), // Change this to your desired color
        child: Row(
          children: [
            Flexible(
              flex: 10,
              child: ListTile(
                title: "${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]}".length < 15
                    ? Text(
                  widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['title'],
                  style:  TextStyle(
                      color: beyaz(),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )
                    : SizedBox(
                  height: 35,
                  child: Marquee(
                    text: "${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['title']}" == 'null'
                        ? "${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['name']}"
                        : "${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['title']}",
                    style:  TextStyle(
                        color: beyaz(),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    blankSpace: 30,
                  ),
                ),
                subtitle: Text(
                  '${widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['artist']}',
                  style: TextStyle(color: beyaz(), fontSize: 15),
                ),
                leading: Image.network(widget.audioService.playlistDetay[widget.audioService.currentTrackIndex]['image']),
              ),
            ),

            Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.audioService.isPlaying) {
                        widget.audioService.pause();
                      } else {
                        widget.audioService.play(widget.audioService.playlist[widget.audioService.currentTrackIndex]);
                      }
                    });
                  },
                  icon: Icon(widget.audioService.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: beyaz(), size: 45,),
                ),
            ),
           Flexible(child: Row(children: [],), flex: 2,)
          ],
        ),
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
      currentTrackIndex = index;
      await play(playlist[index]);
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
