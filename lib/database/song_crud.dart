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

  // Favori olarak işaretleme
  Future<int> markAsFavorite(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'songs',
      {'is_favorite': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Favori işaretini kaldırma
  Future<int> removeFromFavorites(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'songs',
      {'is_favorite': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
