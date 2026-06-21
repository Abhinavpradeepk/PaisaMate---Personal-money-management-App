class AlertModel {
  int ? id;
  String type;
  double amount;
  String dueDate;
  AlertModel({
    this.id,
    required this.type,
    required this.amount,
    required this.dueDate
  });



  Map<String,dynamic>toMap(){
    return{
      'id':id,
      'type':type,
      'amount':amount,
      'dueDate':dueDate,
    };
  }
  factory AlertModel.fromMap(Map<String,dynamic>map){
    return AlertModel(
        id: map['id'],
        type:map['type'],
        amount:map['amount'],
        dueDate:map['dueDate'],
    );
  }
}
