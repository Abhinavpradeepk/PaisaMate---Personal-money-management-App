

import 'package:flutter/widgets.dart';
import 'package:paisamate/db/income_db.dart';

ValueNotifier <double> totalIncomeNotifier = ValueNotifier(0);

Future <void> refreshTotalIncome()async{
  final total =await IncomeDB.getTotalIncome();
  totalIncomeNotifier.value = total;
}