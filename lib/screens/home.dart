import 'package:flutter/material.dart';
import 'package:paisamate/db/expense.dart';
import 'package:paisamate/db/income_db.dart';
import 'package:paisamate/functions/Income_functions.dart';
import 'package:paisamate/functions/expense_function.dart';
import 'package:paisamate/screens/IncomeScreen.dart';
import 'package:paisamate/screens/expense_screen.dart';
import 'package:paisamate/screens/smartalerts.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

double totalIncome = 0;
double totalExpense = 0;

class _ScreenHomeState extends State<ScreenHome> {
  Future<void> loadTotalIncome() async {
    final total = await IncomeDB.getTotalIncome();

    setState(() {
      totalIncome = total;
    });
  }

  Future<void> loadTotalExpense() async {
    final total = await ExpenseDB.getTotalExpense();

    setState(() {
      totalExpense = total;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTotalIncome();
    loadTotalExpense();
    refreshTotalIncome();
    refreshTotalExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(166, 60, 63, 248),
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'lib/assets/pngegg (22) 1.png',
            fit: BoxFit.contain,
          ),
        ),
        title: const Text(
          'PaisaMate',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Money Management',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 5,
                color: const Color.fromARGB(255, 220, 214, 255),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Stack(
                    
                    children: [ Positioned(left: 40,top:30, child:ValueListenableBuilder<double>(
                          valueListenable: totalIncomeNotifier,
                          builder: (context, income, child) {
                            return Text(
                              'Income : ₹${income.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 81, 255),
                                  
                              ),
                            );
                          },
                        ),
                    ),

                          Positioned(left: 40,top:90, child:ValueListenableBuilder<double>(
                          valueListenable: totalExpenseNotifier,
                          builder: (context, expense, child) {
                            return Text(
                              'Expense : ₹${expense.toStringAsFixed(2)}',

                              style: const TextStyle(
                                  
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 248, 52, 52),
                                  
                              ),
                            );
                          },
                        ),),
                      

                       

                        const SizedBox(height: 20),
                        Positioned(left: 40,top: 150,child:ValueListenableBuilder<double>(
                          valueListenable: totalIncomeNotifier,
                          builder: (context, income, child) {
                            return ValueListenableBuilder<double>(
                              valueListenable: totalExpenseNotifier,
                              builder: (context, expense, child) {
                                final balance = income - expense;

                                return Text(
                                  'Balance : ₹${balance.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                );
                              },
                            );
                        
                          },
                        ),
                  )],
                    ),
                  ),
                ),
              const SizedBox(height: 50),

Center(
  child: Column(
    children: [
      SizedBox(
        width: 200,
        height: 75,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IncomeScreen(),
              ),
            );

            loadTotalIncome();
          },
          child: Card(
            shape: RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(20) ,
  ),
            color: Color.fromARGB(255, 85, 201, 255),
            child: Center(
              child: Text(
                'Income',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 10),

      SizedBox(
        width: 200,
        height: 75,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseScreen(),
              ),
            );

            loadTotalExpense();
          },
          child:  Card(
            shape: RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(20) ,
  ),
            color: Color.fromARGB(255, 85, 201, 255),
            child: Center(
              child: Text(
                'Expense',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 10),

      SizedBox(
        width: 200,
        height: 75,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenAlerts(),
              ),
            );
          },
          child:  Card(
            shape: RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(20) ,
  ),
            color: Color.fromARGB(255, 85, 201, 255),
            
            child: Center(
              child: Text(
                'Smart Alerts',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),
              
  
              
            ],
          ),
        ),
      ),
    );
  }
}