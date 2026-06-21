

import 'package:flutter/material.dart';
import 'package:paisamate/db/expense.dart';
import 'package:paisamate/db/income_db.dart';
import 'package:paisamate/functions/Income_functions.dart';
import 'package:paisamate/functions/expense_function.dart';
import 'package:paisamate/model/expense_model.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final expenseController = TextEditingController();
    final expenseDate = TextEditingController();
      final expenseSpent = TextEditingController();
      List <ExpenseModel> ExpenseList= [];

Future<void> loadExpenses() async {
  final data = await ExpenseDB.getAllExpense();

  setState(() {
    ExpenseList = data;
  });
}

  @override
  void initState() {
  super.initState();
  loadExpenses();
  
}
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaisaMate'),

      ),
      body:Padding(padding: EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            controller: expenseController,
            decoration: InputDecoration(
              labelText: 'Amount'
            ),
            keyboardType: TextInputType.number,
            
          ),
          TextField(
            controller: expenseSpent,
            decoration: InputDecoration(
              labelText: 'Spent For'
            ),
            
          ),
          TextField(
            controller: expenseDate,
            decoration: InputDecoration(
              labelText: 'Date',
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: ()async{
                        final expense = ExpenseModel(amount: double.parse(expenseController.text),
             spent: expenseSpent.text, date: expenseDate.text);
             await ExpenseDB.addExpense(expense);
             await loadExpenses();
             totalExpenseNotifier.value = await ExpenseDB.getTotalExpense();
             totalIncomeNotifier.value = await IncomeDB.getTotalIncome();
             
             
            Navigator.pop(context);

          }, child: Text('Add')),
          Expanded(child: ListView.builder(itemCount: ExpenseList.length,
            itemBuilder: (context,index){
            final expense = ExpenseList[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.currency_rupee),
                title: Text(expense.spent),
                subtitle: Text(expense.date),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹${expense.amount}'),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        if (expense.id != null) {
                          await ExpenseDB.deleteExpense(expense.id!);
                          await loadExpenses();
                          totalExpenseNotifier.value = await ExpenseDB.getTotalExpense();
                          totalIncomeNotifier.value = await IncomeDB.getTotalIncome();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }))

        ],
      ),)
    );
  }
}