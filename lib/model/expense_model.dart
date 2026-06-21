
class ExpenseModel {
  int ? id;
  double amount;
  String spent;
  String date;
  ExpenseModel({
    this.id,
    required this.amount,
    required this.spent,
    required this.date,
  });

  Map<String,dynamic>toMap(){
    return{
      'id':id,
      'amount':amount,
      'spent':spent,
      'date':date,

    };



  }

    factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      amount: map['amount'],
      spent: map['spent'],
      date: map['date'],
    );
  }


}