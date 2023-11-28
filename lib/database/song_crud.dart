
import 'package:musica/database/database_helper.dart';

class SongCRUD {
  final DatabaseHelper _dbHelper;

  SongCRUD(this._dbHelper);

  // Yeni bir şarkı ekleme
    Future<int> createSong(Map<String, dynamic> song) async {
    final db = await _dbHelper.database;
    return await db.insert('songs', song);
  }

  // Şarkıları sorgulama
  Future<List<Map<String, dynamic>>> getSongs() async {
    final db = await _dbHelper.database;
    return await db.query('songs');
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
}
