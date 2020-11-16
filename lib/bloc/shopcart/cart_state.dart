
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {

  int count;
  double amount;
  String code;
  CartState(int count,double amount,String code, [List props = const []]) : super();
}

class Start extends CartState
{
  Start(int count,double amount,String code) : super(count,amount,code);
  @override
  String toString() => 'Start { count: $count , amount: $amount, code: $code}';
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class Updating extends CartState {
  int count;
  double amount;
  String code;
  Updating(int count,double amount,String code) : super(count,amount,code);
   @override
  String toString() => 'Updating { count: $count , amount: $amount, code: $code}';
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class Update extends CartState {
  int count;
  double amount;
String code;
  Update(int count,double amount,String code) : super(count,amount,code);
   @override
  String toString() => 'Update { count: $count , amount: $amount,code: $code}';
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class Remove extends CartState {
  int count;
  double amount;
  String code;
  Remove(int count,double amount,String code) : super(count,amount,code);
   @override
  String toString() => 'Remove { count: $count , amount: $amount,code: $code}';
  @override
  // TODO: implement props
  List<Object> get props => null;
}


class Finished extends CartState {
  int count;
  double amount;
String code;
  Finished(int count,double amount,String code) : super(count,amount,code);
   @override
  String toString() => 'Finished { count: $count , amount: $amount , code: $code}';
  @override
  // TODO: implement props
  List<Object> get props => null;
}

