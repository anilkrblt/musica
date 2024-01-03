import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

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


  Future<List<Map<String, dynamic>>> loadRockTracks(String tur) async {
    SpotifyService spotifyService = SpotifyService();
    try {
      var playlists = await spotifyService.getPlaylistsByGenre(tur);
      if (playlists.isNotEmpty) {
        var randomPlaylist = playlists[Random().nextInt(playlists.length)];
        String playlistId = randomPlaylist['id'];

        var randomTracks =
            await spotifyService.getRandomTracksFromPlaylist(playlistId, 20);

        List<Map<String, dynamic>> trackDetails = [];
        for (var item in randomTracks) {
          var trackInfo = item['track'];
          trackDetails.add({
            'id': trackInfo['id'],
            'name': trackInfo['name'],
            'artist': trackInfo['artists'][0]['name'],
            'image': trackInfo['album']['images'][0]['url'],
            'duration': _formatDuration(
                Duration(milliseconds: trackInfo['duration_ms'])),
            'previewUrl': trackInfo['preview_url'],
          });
        }
        return trackDetails;
      } else {
        return []; // Çalma listesi boş ise boş liste dön
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return []; // Hata durumunda boş liste dön
    }
  }
  Future<List<dynamic>> getPlaylistsByGenre(String genre) async {
    final accessToken = await _getAccessToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/browse/categories/$genre/playlists'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['playlists']['items']; 
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

Future<List<dynamic>> getPlaylistTracks(String playlistId) async {
  final accessToken = await _getAccessToken();
  final response = await http.get(
    Uri.parse('$_baseUrl/playlists/$playlistId/tracks'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<dynamic> tracks = data['items'];
    List<dynamic> validTracks = tracks.where((track) {
      return track['track']['preview_url'] != null;
    }).toList();

    return validTracks;
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}



  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<List<dynamic>> getRandomTracksFromPlaylist(
      String playlistId, int count) async {
    final tracks = await getPlaylistTracks(playlistId);
    final random = Random();

    if (tracks.length <= count) {
      return tracks;
    }

    final randomTracks = <dynamic>{};
    while (randomTracks.length < count) {
      randomTracks.add(tracks[random.nextInt(tracks.length)]);
    }

    return randomTracks.toList();
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
    List<dynamic> tracks = data['tracks']['items'];
    List<dynamic> validTracks = tracks.where((track) {
      return track['preview_url'] != null;
    }).toList();

    return validTracks;
  } else {
    throw Exception('Hata!!!');
  }
}

}
