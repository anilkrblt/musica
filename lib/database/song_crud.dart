import 'package:musica/database/database_helper.dart';

class SongCRUD {
  final DatabaseHelper _dbHelper;

  SongCRUD(this._dbHelper);

  // Yeni bir şarkı ekleme
  Future<int> createSong(Map<String, dynamic> song) async {
    final db = await _dbHelper.database;
    // Şarkı eklerken 'is_favorite' sütununu da ekleyin (varsayılan olarak 0)
    final songWithFavorite = {
      ...song,
      'is_favorite': 0, // Varsayılan olarak favori olarak işaretlenmedi
    };
    return await db.insert('songs', songWithFavorite);
  }

  // Şarkıları sorgulama
  Future<List<Map<String, dynamic>>> getSongs() async {
    final db = await _dbHelper.database;
    return await db.query('songs');
  }

  // Favori şarkıları sorgulama
  Future<List<Map<String, dynamic>>> getFavoriteSongs() async {
    final db = await _dbHelper.database;
    return await db.query('songs', where: 'is_favorite = ?', whereArgs: [1]);
  }

  // Şarkı güncelleme
  Future<int> updateSong(int id, Map<String, dynamic> song) async {
    final db = await _dbHelper.database;
    return await db.update(
      'songs',
      song,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Şarkı silme
  Future<int> deleteSong(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Şarkıyı veritabanına ekleyen veya güncelleyen fonksiyon
  Future<void> addOrUpdateSong(
      Map<String, dynamic> song, bool isFavorite) async {
    final db = await _dbHelper.database;
    final spotifyId = song['spotify_id'] ?? song['id'];
    final existingSong = await db
        .query('songs', where: 'spotify_id = ?', whereArgs: [spotifyId]);

    if (existingSong.isEmpty) {
      // Şarkı veritabanında yoksa yeni bir kayıt oluştur
      final newSong = {
        'spotify_id': spotifyId,
        'title': song['name'],
        'artist': song['artist'],
        'album': song['album'],
        'duration': song['duration'],
        'image': song['image'],
        'is_favorite': isFavorite ? 1 : 0,
      };
      await db.insert('songs', newSong);
    } else {
      // Şarkı zaten varsa sadece is_favorite'i güncelle
      await db.update(
        'songs',
        {'is_favorite': isFavorite ? 1 : 0},
        where: 'spotify_id = ?',
        whereArgs: [spotifyId],
      );
    }
  }
}
