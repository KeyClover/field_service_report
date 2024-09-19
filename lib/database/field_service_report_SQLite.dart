import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FieldServiceDatabase {
  static final FieldServiceDatabase instance = FieldServiceDatabase._init();
  static Database? _database;

  FieldServiceDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('field_service.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE service_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        case_id INTEGER NOT NULL,
        is_installation INTEGER,
        is_reparation INTEGER,
        is_remove INTEGER,
        is_other INTEGER,
        other_text TEXT,
        is_magnetic_card_reader INTEGER,
        is_fuel_sensor INTEGER,
        is_temperature_sensor INTEGER,
        is_on_off_sensor INTEGER,
        is_other2 INTEGER,
        other_text2 TEXT
      )
    ''');
  }

  Future<void> saveServiceData(int caseId, Map<String, dynamic> data) async {
    final db = await database;
    final existingData = await getServiceData(caseId);
    
    if (existingData.isEmpty) {
      await db.insert('service_data', {...data, 'case_id': caseId});
    } else {
      await db.update(
        'service_data',
        {...data, 'case_id': caseId},
        where: 'case_id = ?',
        whereArgs: [caseId],
      );
    }
  }

  Future<Map<String, dynamic>> getServiceData(int caseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_data',
      where: 'case_id = ?',
      whereArgs: [caseId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return {};
  }
}
