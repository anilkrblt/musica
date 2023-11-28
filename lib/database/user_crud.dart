import 'package:musica/database/security.dart';
import 'database_helper.dart';

class UserCRUD {
  final DatabaseHelper _dbHelper;
  UserCRUD(this._dbHelper);

  // Kullanıcı ekleme, şifreyi hashleme ile birlikte
  Future<int> createUser(String username, String password, String firstName, String lastName) async {
    final db = await _dbHelper.database;

    // Security sınıfını kullanarak şifreyi hashle
    final hashedPassword = Security.hashPassword(password);

    // Hashlenmiş şifre ile kullanıcı bilgilerini oluştur
    final user = {
      'username': username,
      'password': hashedPassword,
      'first_name': firstName, // Kullanıcıdan alınan isim
      'last_name': lastName,   // Kullanıcıdan alınan soyisim
    };

    // Kullanıcıyı veritabanına ekle
    return await db.insert('users', user);
  }

  // Kullanıcıları sorgulama
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await _dbHelper.database;
    return await db.query('users');
  }

Future<List<Map<String, dynamic>>> getUsersByUsername(String username) async {
  final db = await _dbHelper.database;
  // Burada 'password' sütunu da dahil edilmeli
  return await db.query(
    'users',
    columns: ['id', 'username', 'password'], // 'password' sütunu eklenmeli
    where: 'username = ?',
    whereArgs: [username],
  );
}

  // Kullanıcı güncelleme
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Kullanıcı silme
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> verifyUser(String username, String password) async {
    final List<Map<String, dynamic>> users = await getUsersByUsername(username);

    if (users.isEmpty) {
      // Kullanıcı bulunamadı, uygun bir hata mesajı göster
      
      return false;
    }

    if (users.isNotEmpty) {
      // Kullanıcı adı var, şimdi şifreyi doğrula
      final user = users.first;
      return Security.verifyPassword(user['password'], password);
    }
    // Kullanıcı adı mevcut değil
    return false;
  }

  Future<bool> isUserExists(String username) async {
    final List<Map<String, dynamic>> users = await getUsersByUsername(username);
    return users.isNotEmpty;
  }
}
