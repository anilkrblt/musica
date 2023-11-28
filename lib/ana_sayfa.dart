import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

// SpotifyService classınızı buraya ekleyin veya ayrı bir dosyada tutun ve burada import edin.
class SpotifyService {
  final String _clientId = 'd9b578117ffc4b9fbf1f5553a7a72051';
  final String _clientSecret = '50032f2b81ee4d46b8cbfc31d9fc5816';
  final String _baseUrl = 'https://api.spotify.com/v1';

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Access token could not be retrieved');
    }
  }

  Future<List<dynamic>> searchTrack(String query) async {
    final accessToken = await _getAccessToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/search?q=$query&type=track'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['tracks']['items']; // API'nin döndürdüğü şarkı listesi.
    } else {
      throw Exception('Lütfen bir müzik ya da sanatçı giriniz.....');
    }
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _trackNames = [];

  Future<void> _searchTracks() async {
    final spotifyService =
        SpotifyService(); // SpotifyService nesnesi oluşturuldu.

    try {
      final query = _searchController.text;
      final results = await spotifyService.searchTrack(
          query); // spotifyService nesnesi kullanılarak arama yapılıyor.
      setState(() {
        _trackNames = results.map((track) => track['name'].toString()).toList();
      });
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchTracks,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) => _searchTracks(),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'Müzik ya da sanatçı ara',
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 109, 75, 231), // En koyu renk
              Color.fromARGB(255, 176, 162, 230), // Beyaz renk (geçiş sonu)
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: _trackNames.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: renk()),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 109, 75, 231), // En koyu renk
                      Color.fromARGB(
                          255, 176, 162, 230), // Beyaz renk (geçiş sonu)
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ListTile(
                  title: Text(
                    _trackNames[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Text(
                    'Resim',
                  ),
                  subtitle: Text('Sanatcı + muzik suresi',
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.favorite_outline),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              padding: EdgeInsets.only(right: 50),
              icon: const Icon(
                Icons.home_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/ProfilSayfasi');
              },
            ),
            IconButton(
              padding: EdgeInsets.only(right: 50),
              icon: const Icon(
                Icons.favorite_border_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/ProfilSayfasi');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.person_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/ProfilSayfasi');
              },
            ),
          ],
        ),
        color: renk(),
      ),
    );
  }

  Color renk() => Color.fromARGB(255, 83, 62, 158);
}
