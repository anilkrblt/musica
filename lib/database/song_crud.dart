import 'package:musica/database/database_helper.dart';
import 'package:musica/database/user_crud.dart';

class SongCRUD {
  final DatabaseHelper _dbHelper;
  SongCRUD(this._dbHelper);

  Future<int> createSong(Map<String, dynamic> song) async {
    final db = await _dbHelper.database;
    final songWithFavorite = {
      ...song,
      'is_favorite': 0,
    };
    return await db.insert('songs', songWithFavorite);
  }

  Future<List<Map<String, dynamic>>> getSongs() async {
    final db = await _dbHelper.database;
    return await db.query('songs');
  }


  Future<bool> isSongInPlaylist(int playlistId, String songId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'playlist_songs',
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, songId],
    );
    return result.isNotEmpty;
  }


  Future<List<Map<String, dynamic>>> getFavoriteSongs() async {
    final db = await _dbHelper.database;
    return await db.query('songs', where: 'is_favorite = ?', whereArgs: [1]);
  }

  Future<int> updateSong(int id, Map<String, dynamic> song) async {
    final db = await _dbHelper.database;
    return await db.update(
      'songs',
      song,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSong(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addOrUpdateSong(
      Map<String, dynamic> song, bool isFavorite) async {
    final db = await _dbHelper.database;
    final spotifyId = song['spotify_id'] ?? song['id'];
    final existingSong = await db
        .query('songs', where: 'spotify_id = ?', whereArgs: [spotifyId]);

    if (existingSong.isEmpty) {
      final newSong = {
        'spotify_id': spotifyId,
        'title': song['name'],
        'artist': song['artist'],
        'album': song['album'],
        'duration': song['duration'],
        'image': song['image'],
        'sarkiUrl': song['previewUrl'],
        'is_favorite': isFavorite ? 1 : 0,
      };
      await db.insert('songs', newSong);
    } else {
      await db.update(
        'songs',
        {'is_favorite': isFavorite ? 1 : 0},
        where: 'spotify_id = ?',
        whereArgs: [spotifyId],
      );
    }
  }

  Future<List<Map<String, dynamic>>> getPlaylists(int userId) async {
    final db = await _dbHelper.database;
    return await db
        .query('playlists', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> createPlaylist(
      int userId, String userName, String name, String image) async {
    final db = await _dbHelper.database;
    int playlistId = await db.insert('playlists', {
      'user_id': userId,
      'user_name': userName,
      'name': name,
      'image': image
    });
    return playlistId;
  }

  Future<List<Map<String, dynamic>>> findSongsByPlaylist(int playlistId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
    SELECT 
      songs.spotify_id, 
      songs.title, 
      songs.artist, 
      songs.album, 
      songs.duration, 
      songs.image, 
      songs.sarkiUrl
    FROM playlist_songs
    INNER JOIN songs ON songs.spotify_id = playlist_songs.song_id
    WHERE playlist_songs.playlist_id = ?
  ''', [playlistId]);

    return List<Map<String, dynamic>>.from(result);
  }

  void doluOynatmaListesiOlustur(
      int userId, String tur, List<Map<String, dynamic>> songs) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await _dbHelper.database;
    final songCRUD = SongCRUD(dbHelper);
    final userCRUD = UserCRUD(dbHelper);

    final List<Map<String, dynamic>> users =
        await userCRUD.getUsernameByUserId(userId);
    final String userName = users.isNotEmpty
        ? users.first['username'] as String
        : 'Bilinmeyen Kullanıcı';
    String playlistName = "Yeni $tur Playlistim";
    String playlistImage = "assets/image/muzik_notasi1";
    int playlistId = await songCRUD.createPlaylist(
        userId, userName, playlistName, playlistImage);
    for (var song in songs) {
      final songId = song['id'];
      final existingSong = await db.query(
        'songs',
        where: 'spotify_id = ?',
        whereArgs: [songId],
      );
      if (existingSong.isEmpty) {
        final newSong = {
          'spotify_id': songId,
          'title': song['name'],
          'artist': song['artist'],
          'album': song['album'],
          'duration': song['duration'],
          'image': song['image'],
          'sarkiUrl': song['previewUrl'],
          'is_favorite': song.containsKey('is_favorite')
              ? (song['is_favorite'] ? 1 : 0)
              : 0,
        };
        await db.insert('songs', newSong);
      }
      final result = await db.insert(
          'playlist_songs', {'playlist_id': playlistId, 'song_id': songId});
    }
  }

Future<void> addSongToPlaylist(int playlistId, Map<String, dynamic> song) async {
  final db = await _dbHelper.database;
  final songId = song['id'];

  // Şarkının 'songs' tablosunda olup olmadığını kontrol et
  final existingSong = await db.query(
    'songs',
    where: 'spotify_id = ?',
    whereArgs: [songId],
  );

  // Eğer şarkı 'songs' tablosunda yoksa, ekle
  if (existingSong.isEmpty) {
    final newSong = {
      'spotify_id': songId,
      'title': song['name'],
      'artist': song['artist'],
      'album': song['album'],
      'duration': song['duration'],
      'image': song['image'],
      'sarkiUrl': song['previewUrl'],
      'is_favorite': song.containsKey('is_favorite') ? (song['is_favorite'] ? 1 : 0) : 0,
    };
    await db.insert('songs', newSong);
  }

  // Şarkının zaten çalma listesinde olup olmadığını kontrol et
  final existingPlaylistSong = await db.query(
    'playlist_songs',
    where: 'playlist_id = ? AND song_id = ?',
    whereArgs: [playlistId, songId],
  );

  // Eğer şarkı çalma listesinde yoksa, ekle
  if (existingPlaylistSong.isEmpty) {
    final result = await db.insert(
      'playlist_songs', {'playlist_id': playlistId, 'song_id': songId});
    print("$result added to playlist_songs");
  }
}


  Future<void> removeSongFromPlaylist(int playlistId, String songId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'playlist_songs',
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, songId],
    );
  }

  Future<void> deletePlaylist(int playlistId) async {
    final db = await _dbHelper.database;
    await db.delete('playlists', where: 'id = ?', whereArgs: [playlistId]);
    await db.delete('playlist_songs',
        where: 'playlist_id = ?', whereArgs: [playlistId]);
  }

  Future<void> updatePlaylistName(int playlistId, String newName) async {
    final db = await _dbHelper.database;
    await db.update(
      'playlists',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [playlistId],
    );
  }

 Future<void> addRecentPlayed(Map<String, dynamic> song, int userId) async {
  final db = await _dbHelper.database;
  var trackId = song['id'] ?? song['spotify_id'];
  var result = await db.query(
    'recent_played',
    where: 'user_id = ? AND track_id = ?',
    whereArgs: [userId, trackId],
  );
  if (result.isEmpty) {
    await db.insert('recent_played', {
      'user_id': userId,
      'track_id': trackId,
      'name': song['name'] ?? song['title'],
      'artist': song['artist'],
      'image': song['image'],
      'duration': song['duration'],
      'previewUrl': song['previewUrl']
    });
  }
}


  Future<List<Map<String, dynamic>>> getRecentPlayed(int userId) async {
    final db = await _dbHelper.database;
    return await db.query('recent_played',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'id DESC' // En son eklenenleri ilk sırada göster
        );
  }
}
