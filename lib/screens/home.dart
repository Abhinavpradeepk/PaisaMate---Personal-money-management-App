import 'package:flutter/material.dart';
import 'package:paisamate/db/income_db.dart';
import 'package:paisamate/functions/Income_functions.dart';
import 'package:paisamate/screens/IncomeScreen.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}
double totalIncome = 0;
class _ScreenHomeState extends State<ScreenHome> {
    Future <void> loadTotalIncome()async {
  final total = await IncomeDB.getTotalIncome();
  setState(() {
      totalIncome = total;
    });
}
  @override
    void initState() {
    super.initState();
    loadTotalIncome();
    refreshTotalIncome();
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
            
            
            
            
            )
          ],
        ),
        SizedBox(height:10 ,),
        InkWell(
          onTap: (){

          },
          child:Card(
          child:SizedBox(
            width: double.infinity,
            height: 150,
            child: Center(child:ValueListenableBuilder(
  valueListenable: totalIncomeNotifier,
  builder: (context, total, child) {
    return Text(
      '₹${total.toStringAsFixed(2)}',
      style: const TextStyle(fontSize: 30),
    );
  },
          ) ),),
            
          ),
        ) ,
        
        
        ],
        
      ),
      
      
      ),
      
      ),


      
      
      
      
      
      
      );
      
    
  }
}