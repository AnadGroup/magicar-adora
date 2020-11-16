
class CartModel {
  int count;
  double amount;
  String code;

  CartModel({this.count,this.amount,this.code});

CartModel.map(dynamic obj) {
  this.count=obj['count'];
  this.amount=obj['amount'];
  this.code=obj['code'];
}

}