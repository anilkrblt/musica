import 'package:flutter/material.dart';

class ProfilSayfasi extends StatefulWidget {
  const ProfilSayfasi({super.key});

  @override
  State<ProfilSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const ListTile(
            leading: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.amber,
              child: Center(
                  child: Text(
                'User Profile Image',
                style: TextStyle(fontSize: 10),
              )),
            ),
            title: Text('UserName'),
            subtitle: Text('Username or something like'),
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Tüm Şarkılar'),
            subtitle: const Text('İndirilen müzik miktarı'),
            onTap: () {
              Navigator.pushNamed(context, '/TumSarkilar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_music_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Çalma listeleri'),
            subtitle: const Text('Çalma listesi miktarı'),
            onTap: () {
              Navigator.pushNamed(context, '/CalmaListesi');
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Favoriler'),
            subtitle: const Text('Favori miktarı'),
            onTap: () {
              Navigator.pushNamed(context, '/Favoriler');
            },
          ),
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Son dinlenenler'),
            subtitle: const Text('Son 1 hafta dinlenen farklı müzik miktarı'),
            onTap: () {
              Navigator.pushNamed(context, '/SonDinlenenler');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pushNamed(context, '/Ayarlar');
            },
          ),
        ],
      ),
    );
  }
}
