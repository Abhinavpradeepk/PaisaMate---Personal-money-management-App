
import 'package:paisamate/model/alert_model.dart';
import 'package:sqflite/sqflite.dart';

class AlertDB{
  static Future <Database>database()async{
    return openDatabase(
      'alert.db',
      version: 1,
      onCreate: (db,version)async{
        await db.execute(''' 
        CREATE TABLE alerts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        type TEXT,
        dueDate TEXT
        )
        ''');
      }
    );
  }
  
  static Future <void> addAlert(AlertModel alert)async{
    try {
      final db = await database();
      await db.insert('alerts', alert.toMap());
    } catch (e) {
      throw Exception('Failed to save alert: $e');
    }
  }
  
  static Future <List<AlertModel>>getAllAlerts()async{
    try {
      final db = await database();
      final values = await db.query('alerts', orderBy: 'dueDate ASC');
      return values.map((e)=> AlertModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch alerts: $e');
    }
  }
  
  static Future<void> deleteAlert(int id) async {
    try {
      final db = await database();
      await db.delete('alerts', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete alert: $e');
    }
  }
}