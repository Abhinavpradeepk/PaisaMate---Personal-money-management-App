import 'package:flutter/widgets.dart';
import 'package:paisamate/db/expense.dart';
ValueNotifier<double> totalExpenseNotifier = ValueNotifier(0);
Future<void> refreshTotalExpense() async {
  final total = await ExpenseDB.getTotalExpense();
  totalExpenseNotifier.value = total;
}