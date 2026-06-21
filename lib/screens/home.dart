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
    Future <void> loadTotalIncome()async {
  final total = await IncomeDB.getTotalIncome();
  setState(() {
      totalIncome = total;
    });
}


Future <void> loadTotalExpense()async{
  final total = await ExpenseDB.getTotalExpense();
  setState(() {
    totalExpense=total;
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('PaisaMate'),backgroundColor: Color.fromARGB(80, 0, 4, 255)),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Row(
          children: [
            Expanded(child: InkWell(
              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>IncomeScreen(),
                                ),
                                
                                );
                                loadTotalIncome();


              },
              child: Card(
              child: SizedBox(height: 100,
              child: Center(
                child: Text('Income'),
              ),),
            ) ,
            )
            ,),
            SizedBox(width: 10,),
            Expanded(child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
                

              },
              child: Card(
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Text('Expense'),
                ),
              ),
            ),

            )
            
            
            
            
            ),
          ],
        ),
        SizedBox(height:10 ,),
        InkWell(
          onTap: (){

          },
          child:Card(
  child: SizedBox(
    width: double.infinity,
    height: 150,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder<double>(
          valueListenable: totalIncomeNotifier,
          builder: (context, income, child) {
            return Text(
              'Income: ₹${income.toStringAsFixed(2)}',
            );
          },
        ),
        ValueListenableBuilder<double>(
          valueListenable: totalExpenseNotifier,
          builder: (context, expense, child) {
            return Text(
              'Expense: ₹${expense.toStringAsFixed(2)}',
            );
          },
        ),
        ValueListenableBuilder<double>(
  valueListenable: totalIncomeNotifier,
  builder: (context, income, child) {
    return ValueListenableBuilder<double>(
      valueListenable: totalExpenseNotifier,
      builder: (context, expense, child) {
        final balance = income - expense;

        return Text(
          'Balance: ₹ ${balance.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  },
)
      ],
    ),
  ),
)
        ) ,
        
        SizedBox(height: 10,),
        Text('Smart Management',style: TextStyle(fontSize: 30,fontStyle:FontStyle.italic,color: const Color.fromARGB(255, 255, 0, 0) ),),
        Row(
          children: [
            Expanded(child: InkWell(
              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenAlerts(),
                                ),
                                
                                );
                                loadTotalIncome();


              },
              child: Card(
              child: SizedBox(height: 100,
              child: Center(
                child: Text('Smart Alerts'),
              ),),
            ) ,
            )
            ,)
            
          ],

        )

        
        
        ],
        
      ),
      
      
      ),
      
      ),


      
      
      
      
      
      
      );
      
    
  }
}