import 'dart:io';

import 'package:commission_counter/datasource/local/model/commission_model.dart';
import 'package:commission_counter/datasource/local/model/order_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "commission_counter.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await Future.wait([
        db.execute(
          "CREATE TABLE ${OrderModel.tableName} ("
          "id TEXT PRIMARY KEY,"
          "store_owner_id TEXT,"
          "store_id TEXT,"
          "admin_id TEXT,"
          "currency TEXT,"
          "updated_at TEXT,"
          "created_at TEXT,"
          "amount REAL"
          ")",
        ),
        db.execute(
          "CREATE TABLE ${CommissionModel.tableName} ("
          "id TEXT PRIMARY KEY,"
          "store_owner_id TEXT,"
          "store_id TEXT,"
          "admin_id TEXT,"
          "currency TEXT,"
          "updated_at TEXT,"
          "created_at TEXT,"
          "amount REAL,"
          "agent_id TEXT,"
          "customer_id TEXT,"
          "order_id TEXT,"
          "seat INTEGER,"
          "name TEXT"
          ")",
        ),
      ]);
    });
  }

  Future createOrder(
    OrderModel orderModel,
    List<CommissionModel> commissions,
  ) async {
    final db = await database;

    Batch batch = db.batch();

    batch.insert(
      OrderModel.tableName,
      orderModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    commissions.forEach((commissionsItem) {
      batch.insert(
        CommissionModel.tableName,
        commissionsItem.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    batch.commit();
  }

  Future<void> updateOrder(
    OrderModel orderModel,
    List<CommissionModel> commissions,
  ) async {
    final db = await database;
    Batch batch = db.batch();

    /// Update order
    batch.update(
      OrderModel.tableName,
      orderModel.toJson(),
      where: "id = ?",
      whereArgs: [orderModel.id],
    );

    /// Delete old commission
    batch.delete(
      CommissionModel.tableName,
      where: "order_id = ?",
      whereArgs: [orderModel.id],
    );

    /// Add new commission
    commissions.forEach((commissionsItem) {
      batch.insert(
        CommissionModel.tableName,
        commissionsItem.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    batch.commit();
  }

  Future<List<OrderModel>> getAllOrderByStoreId(String storeId) async {
    final db = await database;
    var res = await db.query(
      OrderModel.tableName,
      where: "store_id = ?",
      whereArgs: [storeId],
    );
    List<OrderModel> list =
        res.isNotEmpty ? res.map((c) => OrderModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<CommissionModel>> getCommissionsByOrderId(String orderId) async {
    final db = await database;
    var res = await db.query(
      CommissionModel.tableName,
      where: "order_id = ?",
      whereArgs: [orderId],
    );
    List<CommissionModel> list = res.isNotEmpty
        ? res.map((c) => CommissionModel.fromJson(c)).toList()
        : [];
    return list;
  }
}
