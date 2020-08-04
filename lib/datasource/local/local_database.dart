import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  String _dbName = 'app.db';

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  _copyDbIfNeed() async {
//    try {
//      Directory documentsDirectory = await getApplicationDocumentsDirectory();
//      String path = join(documentsDirectory.path, _dbName);
//
//      if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
//        ByteData data = await rootBundle.load(join('assets', _dbName));
//        List<int> bytes =
//            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//        await new File(path).writeAsBytes(bytes);
//      }
//    } catch (e) {
//      AppLogger.e(e);
//    }
  }

//
  initDB() async {
    await _copyDbIfNeed();

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {});
  }

//  Future<List<LocalAddress>> getAllProvince() async {
//    try {
//      final db = await database;
//      var res = await db.query('province');
//      List<LocalAddress> list = res.isNotEmpty
//          ? res.map((c) => LocalAddress.fromJson(c)).toList()
//          : [];
//      return list;
//    } catch (error) {
//      AppLogger.e(error);
//      return [];
//    }
//  }
//
//  Future<List<LocalAddress>> getDistrictByProvinceCode(
//      String provinceCode) async {
//    final db = await database;
//    var res = await db.query('district',
//        where: "province_code = ?", whereArgs: [provinceCode]);
//    List<LocalAddress> list =
//        res.isNotEmpty ? res.map((c) => LocalAddress.fromJson(c)).toList() : [];
//    return list;
//  }
//
//  Future<List<LocalAddress>> getTownByDistrictCode(String districtCode) async {
//    final db = await database;
//    var res = await db
//        .query('town', where: "district_code = ?", whereArgs: [districtCode]);
//    List<LocalAddress> list =
//        res.isNotEmpty ? res.map((c) => LocalAddress.fromJson(c)).toList() : [];
//    return list;
//  }
}
