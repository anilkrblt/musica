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
    //deleteDb();
  }

  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'musicApp.db');

    // Veritabanını sil
    await deleteDatabase(path);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('musicApp.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path,
        version: 2,
        onCreate: _createDB,
        onUpgrade: _onUpgrade); // version 2 olarak güncellendi
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 'is_favorite' sütununu kontrol edin ve ekleyin
      var table = await db.rawQuery("PRAGMA table_info(songs)");
      var exists = table.any((row) => row['name'] == 'is_favorite');
      if (!exists) {
        await db.execute(
            'ALTER TABLE songs ADD COLUMN is_favorite INTEGER DEFAULT 0');
      }
    }
    if (oldVersion < 3) {
      // 'image' sütununu ekleyin
      await db.execute('ALTER TABLE songs ADD COLUMN image TEXT');
    }
    // Diğer sütun güncellemeleri için benzer ifadeler ekleyebilirsiniz.
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
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    spotify_id TEXT,
    title TEXT NOT NULL,
    artist TEXT NOT NULL,
    album TEXT,
    duration INTEGER,
    image TEXT, 
    sarkiUrl TEXT,
    is_favorite INTEGER NOT NULL DEFAULT 0
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
