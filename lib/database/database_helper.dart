
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user_crud.dart';
import 'song_crud.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // CRUD sınıflarının örneklerini oluşturun
  late final UserCRUD userCRUD;
  late final SongCRUD songCRUD;

  DatabaseHelper._init() {
    userCRUD = UserCRUD(this);
    songCRUD = SongCRUD(this);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('musicApp.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

 Future _createDB(Database db, int version) async {
  const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  const textType = 'TEXT NOT NULL';
  const integerType = 'INTEGER NOT NULL';

  // User tablosunu oluştur
  await db.execute('''
    CREATE TABLE users (
      id $idType,
      first_name $textType,
      last_name $textType,
      username $textType UNIQUE,
      password $textType
    );
  ''');

  // Song tablosunu oluştur
  await db.execute('''
    CREATE TABLE songs (
      id $idType,
      title $textType,
      artist $textType,
      album $textType,
      duration $integerType,
      genre $textType
    );
  ''');

  // Playlist tablosunu oluştur
  await db.execute('''
    CREATE TABLE playlists (
      id $idType,
      user_id $integerType,
      name $textType,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
    );
  ''');

  // PlaylistSongs ilişkisel tablosunu oluştur
  await db.execute('''
    CREATE TABLE playlist_songs (
      playlist_id $integerType,
      song_id $integerType,
      FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
      FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
    );
  ''');

  // Favorites tablosunu oluştur
  await db.execute('''
    CREATE TABLE favorites (
      user_id $integerType,
      song_id $integerType,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
      FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
    );
  ''');

  // Settings tablosunu oluştur
  await db.execute('''
    CREATE TABLE settings (
      user_id $integerType,
      setting_key $textType,
      setting_value $textType,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
    );
  ''');
}

  // Ana DatabaseHelper sınıfında CRUD işlemleri yok artık, bunlar ilgili CRUD sınıflarına taşındı.

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
