/*

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:anad_magicar/bloc/shopcart/cart.dart';
import 'package:anad_magicar/bloc/shopcart/cart_model.dart';
import 'package:anad_magicar/bloc/shopcart/checkout_cart.dart';
import 'package:anad_magicar/data/database_helper.dart';
import 'package:anad_magicar/models/shopcart_model.dart';


class CartBloc extends Bloc<CartEvent,CartState> {

  int count=0;
  double amount=0;
  String code;
  CheckOutCart _checkOutCart;



  StreamSubscription<CartModel> _cartSubscription;

CartBloc({@required CheckOutCart checkOutCart})
{
  this._checkOutCart=checkOutCart;
}

  @override
  CartState get initialState => Start(count, amount,code);

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if(event is Start)
    {
      yield* _mapStartToState(event);
    }
    if(event is IncrementEvent)
    {
      yield* _mapIncrementToState(event);
    }
    if(event is DecrementEvent)
    {
      yield* _mapDecrementToState(event);
    }
    if(event is ResetCartEvent)
    {
      yield* _mapResetCartToState(event);
    }
  }
  
  Stream<CartState> _mapStartToState(IncrementEvent event) async* {
      yield Updating(event.count,event.amount,event.code);
      //_cartSubscription?.cancel();
      CartModel cm= new CartModel(count: event.count,amount: event.amount,code: event.code);
      if(cm.count>0 && cm.amount>0) {
        databaseHelper.saveShopCart(new ShopCartModel(count: cm.count,amount: cm.amount,code: cm.code));
      yield Finished(event.count,event.amount,event.code);
      }
      else
       yield Finished(event.count,event.amount,event.code);
  }
  Stream<CartState> _mapIncrementToState(IncrementEvent event) async* {
      yield Updating(event.count,event.amount,event.code);
     // _cartSubscription?.cancel();
      CartModel cm= new CartModel(count: event.count,amount: event.amount,code: event.code);
      if(cm.count>0 && cm.amount>0)
      {
        
        databaseHelper.updateShopCartByCode(new ShopCartModel(count: cm.count,amount: cm.amount,code: cm.code));

      yield Finished(event.count,event.amount,event.code);
      }
      else
       yield Finished(event.count,event.amount,event.code);
  }

 Stream<CartState> _mapDecrementToState(DecrementEvent event) async* {
      yield Updating(event.count,event.amount,event.code);
      //_cartSubscription?.cancel();
      CartModel cm= new CartModel(count: event.count,amount: event.amount,code: event.code);
      if(cm.count>0 && cm.amount>0){
      databaseHelper.updateShopCartByCode(new ShopCartModel(count: cm.count,amount: cm.amount,code: cm.code));

      yield Finished(event.count,event.amount,event.code);
 }
      else
       yield Finished(event.count,event.amount,event.code);
  }

  Stream<CartState> _mapResetCartToState(ResetCartEvent event) async* {
      yield Updating(event.count,event.amount,event.code);
      _cartSubscription?.cancel();
      CartModel cm= new CartModel(count: event.count,amount: event.amount);
      if(cm.count>0 && cm.amount>0)
      yield Update(0,0,event.code);
      else
       yield Finished(0,0,event.code);
  }
  }*/
