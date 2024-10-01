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

    return await openDatabase(
      path, 
      version: 2, 
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the license_no column to the existing table
      await db.execute('ALTER TABLE service_data ADD COLUMN license_no TEXT NOT NULL DEFAULT ""');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE service_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        case_id INTEGER NOT NULL,
        license_no TEXT NOT NULL,
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
        other_text2 TEXT,
        is_service_completed_yes INTEGER,
        is_service_completed_no INTEGER
      )
    ''');
  }

  Future<void> saveServiceData(int caseId, String licenseNo, Map<String, dynamic> data) async {
    final db = await database;
    final existingData = await getServiceData(caseId, licenseNo);
    
    if (existingData.isEmpty) {
      await db.insert('service_data', {...data, 'case_id': caseId, 'license_no': licenseNo});
    } else {
      await db.update(
        'service_data',
        {...data, 'case_id': caseId, 'license_no': licenseNo},
        where: 'case_id = ? AND license_no = ?',
        whereArgs: [caseId, licenseNo],
      );
    }
  }

  Future<Map<String, dynamic>> getServiceData(int caseId, String licenseNo) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_data',
      where: 'case_id = ? AND license_no = ?',
      whereArgs: [caseId, licenseNo],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return {};
  }
}
