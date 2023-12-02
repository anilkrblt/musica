import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';

class PlayMusic extends StatefulWidget {
  const PlayMusic({super.key});

  @override
  State<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: EdgeInsets.only(right: 200, top: 150),
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
                      padding: const EdgeInsets.only(top: 150),
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
}
