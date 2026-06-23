import 'package:flutter/material.dart';
import 'package:paisamate/db/expense.dart';
import 'package:paisamate/db/income_db.dart';
import 'package:paisamate/functions/Income_functions.dart';
import 'package:paisamate/functions/expense_function.dart';
import 'package:paisamate/model/income_model.dart';
class IncomeScreen extends StatefulWidget {
  
  IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
final amountController = TextEditingController();

final sourceController = TextEditingController();

final dateController = TextEditingController();
List <IncomeModel> IncomeList= [];




  @override
  void initState(){
    super.initState();
    loadIncome();
  }
  Future <void> loadIncome()async{
    final data = await IncomeDB.getAllIncome();
    setState(() {
      IncomeList = data;
    });
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
      SizedBox(height: 30,),
      const Text(
                    'Add Income',
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
            margin: EdgeInsets.only(
              top: 40
              
            ),
          
            
            color: const Color.fromARGB(255, 193, 199, 255),
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              
            ),
            
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  
          
                  const SizedBox(height: 20),
          
                  TextField(
                    controller: amountController,
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
                    controller: sourceController,
                    decoration: InputDecoration(
                      labelText: 'Source',
                      hintText: 'Enter source',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 15),
          
                  TextField(
                    controller: dateController,
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
          
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(140, 50)
                        
                      ),
                      onPressed: () async {
                        final income = IncomeModel(
                          amount: double.parse(amountController.text),
                          source: sourceController.text,
                          date: dateController.text,
                        );
                              
                        await IncomeDB.addIncome(income);
                        await refreshTotalIncome();
                        await loadIncome();
                              
                        amountController.clear();
                        sourceController.clear();
                        dateController.clear();
                      },
                      child: const Text('Add',style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 20),
      Text('Income List',style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),),

      Expanded(
        child: ListView.builder(
          itemCount: IncomeList.length,
          itemBuilder: (context, index) {
            final income = IncomeList[index];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.currency_rupee),
                title: Text(income.source,style: TextStyle(
                  fontSize: 20,
                ),),
                subtitle: Text(income.date,style: TextStyle(
                  fontSize: 20,
                ),),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹${income.amount}',style: TextStyle(fontSize: 24,color: Colors.blue),),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        if (income.id != null) {
                          await IncomeDB.deleteIncome(income.id!);
                          await loadIncome();
                          await refreshTotalIncome();
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
  }} 