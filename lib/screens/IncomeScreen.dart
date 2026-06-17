import 'package:flutter/material.dart';
import 'package:paisamate/db/income_db.dart';
import 'package:paisamate/functions/Income_functions.dart';
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
        title: Text('PaisaMate'),

      ),
      body: Padding(padding: EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            controller:amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller:sourceController,
            decoration: InputDecoration(
              labelText: 'Income Source',
            ),
          ),
          TextField(
            controller:dateController,
            decoration: InputDecoration(
              labelText: 'Date',
            ),

          ),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: ()async{
            final income = IncomeModel(amount: double.parse(amountController.text),
             source: sourceController.text, date: dateController.text);
             await IncomeDB.addIncome(income);
             await refreshTotalIncome();
             loadIncome();
            Navigator.pop(context);

          }, child: Text('Add')),
          Expanded(child: ListView.builder(itemCount: IncomeList.length,
          itemBuilder: (context,index){
            final income = IncomeList[index];


            return Card(
              child: ListTile(
                leading: Icon(Icons.currency_rupee),
                title:Text(income.source),
                subtitle: Text(income.date),
                trailing: Text('₹${income.amount}'),
              ),
            );
          }))

        ],
        
      ),),
    );
  }
}