import 'package:musica/database/database_helper.dart';

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


  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final db = await _dbHelper.database;
    return await db.query('playlists');
  }


  Future<int> createPlaylist(String userName, String name, String image) async {
    final db = await _dbHelper.database;

    int playlistId = await db.insert(
        'playlists', {'user_name': userName, 'name': name, 'image': image});
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


Future<void> addSongToPlaylist(int playlistId, Map<String, dynamic> song) async {
  final db = await _dbHelper.database;
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
      'is_favorite': song.containsKey('is_favorite') ? (song['is_favorite'] ? 1 : 0) : 0,
    };
    await db.insert('songs', newSong);
  }
  final result = await db.insert(
    'playlist_songs', {'playlist_id': playlistId, 'song_id': songId});
  print("$result added to playlist_songs");
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
    await db.insert('recent_played', {
      'user_id': userId,
      'track_id': song['id'],
      'name': song['name'],
      'artist': song['artist'],
      'image': song['image'],
      'duration': song['duration'],
      'previewUrl': song['previewUrl']
    });
  }


  Future<List<Map<String, dynamic>>> getRecentPlayed(int userId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'recent_played',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC' // En son eklenenleri ilk sırada göster
    );
  }
}

