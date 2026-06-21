import 'package:paisamate/model/income_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class IncomeDB {
  static Future<Database> database() async {
    return openDatabase(
      
      'money.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE income(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            source TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  static Future<void> addIncome(IncomeModel income) async {
    final db = await database();

    await db.insert(
      'income',
      income.toMap(),
    );
  }

  static Future<List<IncomeModel>> getAllIncome() async {
    final db = await database();

    final values = await db.query('income');

    return values
        .map((e) => IncomeModel.fromMap(e))
        .toList();
  }

  static Future<double> getTotalIncome()async{
    final db =  await database();
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM income'
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  static Future<void> deleteIncome(int id) async {
    final db = await database();
    await db.delete(
      'income',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
