import 'package:musica/database/security.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class UserCRUD {
  final DatabaseHelper _dbHelper;
  UserCRUD(this._dbHelper);

  // Kullanıcı ekleme, şifreyi hashleme ile birlikte
  Future<int> createUser(String username, String password, String firstName,
      String lastName) async {
    final db = await _dbHelper.database;

    // Security sınıfını kullanarak şifreyi hashle
    final hashedPassword = Security.hashPassword(password);

    // Hashlenmiş şifre ile kullanıcı bilgilerini oluştur
    final user = {
      'username': username,
      'password': hashedPassword,
      'first_name': firstName, // Kullanıcıdan alınan isim
      'last_name': lastName, // Kullanıcıdan alınan soyisim
    };

    // Kullanıcıyı veritabanına ekle
    return await db.insert('users', user);
  }

  // Kullanıcıları sorgulama
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await _dbHelper.database;
    return await db.query('users');
  }

  Future<int?> getUserId(String username) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      columns: ['id'],
      where: 'username = ?',
      whereArgs: [username],
    );
    
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
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

  Future<List<Map<String, dynamic>>> getUserIdByUsername(
      String username) async {
    final db = await _dbHelper.database;
    // Burada 'password' sütunu da dahil edilmeli
    return await db.query(
      'users',
      columns: ['id'], // 'password' sütunu eklenmeli
      where: 'username = ?',
      whereArgs: [username],
    );
  }


  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

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

Future<void> addSearchHistory(int userId, String query) async {
  final db = await _dbHelper.database;
  final existingQuery = await db.query(
    'search_history',
    where: 'user_id = ? AND query = ?',
    whereArgs: [userId, query],
  );

  // Eğer sorgu zaten varsa, tarihi güncelle
  if (existingQuery.isNotEmpty) {
    await db.update(
      'search_history',
      {'timestamp': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [existingQuery.first['id']],
    );
  } else {
    // Yoksa yeni bir kayıt oluştur
    await db.insert(
      'search_history',
      {'user_id': userId, 'query': query, 'timestamp': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

  Future<List<Map<String, dynamic>>> getSearchHistory(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'search_history',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return maps;
  }

  Future<void> deleteSearchHistory(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'search_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  factory CurrentUser() => _instance;

  CurrentUser._internal();

  int? _userId;

  void login(int userId) {
    _userId = userId;
  }

  void logout() {
    _userId = null;
  }

  int? get userId => _userId;
}
