



import 'package:paisamate/model/expense_model.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDB{
  static Future <Database> database()async{
    return openDatabase(
      'expense.db',
      version:1,
      onCreate: (db,version) async{
        await db.execute('''
        CREATE TABLE expense(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        spent TEXT,
        date TEXT
        
        )
                     


                     '''
        );
      },
    );
  }
  static Future <void> addExpense(ExpenseModel expense)async{
    final db = await database();
    await db.insert('expense', expense.toMap(),);
  }

  static Future <List<ExpenseModel>> getAllExpense()async{
    final db = await database();
    final values = await db.query('expense');
    return values .map((e)=> ExpenseModel.fromMap(e)).toList();
  }

static Future<double> getTotalExpense()async{
    final db =  await database();
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expense'
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  static Future<void> deleteExpense(int id) async {
    final db = await database();
    await db.delete(
      'expense',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
