

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
        leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
      Navigator.pop(context);
    },
    
  ),
        backgroundColor: const Color.fromARGB(166, 60, 63, 248),
        actions: <Widget> [IconButton(onPressed: (){
          showAboutDialog(context: context,applicationName: 'PaisaMate',applicationVersion: '1.0.0',applicationIcon:Image.asset('lib/assets/pngegg (22) 1.png',width: 48,height: 48,),
          children: [
    const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text('Developed by Abhinav Pradeep'),
      
    ),
  ],
        

          ); 

        }, icon:Icon(Icons.info_outlined))],

        title: const Text(
          'PaisaMate',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
  padding: const EdgeInsets.all(15),
  child: Column(
    children: [
      const SizedBox(height: 30),

      const Text(
        'Add Expense',
        style: TextStyle(
          fontSize: 24,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),

      SizedBox(
        height: 400,
        child: Align(
          alignment: Alignment.center,
          child: Card(
            margin: const EdgeInsets.only(top: 40),
            color: const Color.fromARGB(255, 193, 199, 255),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  TextField(
                    controller: expenseController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter amount',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: expenseSpent,
                    decoration: InputDecoration(
                      labelText: 'Spent For',
                      hintText: 'Enter category',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: expenseDate,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Enter date',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      
                      minimumSize: const Size(140, 50),
                    ),
                    onPressed: () async {
                      final amount =
                          double.tryParse(expenseController.text);

                      if (amount == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter a valid amount',
                            ),
                          ),
                        );
                        return;
                      }

                      final expense = ExpenseModel(
                        amount: amount,
                        spent: expenseSpent.text,
                        date: expenseDate.text,
                      );

                      await ExpenseDB.addExpense(expense);
                      await loadExpenses();

                      totalExpenseNotifier.value =
                          await ExpenseDB.getTotalExpense();

                      totalIncomeNotifier.value =
                          await IncomeDB.getTotalIncome();

                      expenseController.clear();
                      expenseSpent.clear();
                      expenseDate.clear();
                    },
                    child: const Text('Add',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 20),

      const Text(
        'Expense List',
        style: TextStyle(
          fontSize: 24,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),

      Expanded(
        child: ListView.builder(
          itemCount: ExpenseList.length,
          itemBuilder: (context, index) {
            final expense = ExpenseList[index];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.currency_rupee),
                title: Text(
                  expense.spent,
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  expense.date,
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹${expense.amount}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        if (expense.id != null) {
                          await ExpenseDB.deleteExpense(expense.id!);

                          await loadExpenses();

                          totalExpenseNotifier.value =
                              await ExpenseDB.getTotalExpense();

                          totalIncomeNotifier.value =
                              await IncomeDB.getTotalIncome();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  ),
),
    );
  }
}