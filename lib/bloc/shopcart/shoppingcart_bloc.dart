/*
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/shopcart/shoppingcart.dart';
import 'package:anad_magicar/models/message.dart';
import 'package:anad_magicar/models/shopcart_model.dart';
import 'package:anad_magicar/models/viewmodel/shopping_cart_product_vm.dart';
import 'package:logging/logging.dart';

import 'package:rxdart/rxdart.dart';

class ShoppingCartBloc implements BlocBase {
  static const String TAG = "ShoppingCartBloc";

  ShoppingCart cart = ShoppingCart();
  Message message=new Message();
  /// Sinks
  Sink<ShoppingCartProductVM> get addition => itemAdditionController.sink;
  final itemAdditionController = StreamController<ShoppingCartProductVM>();

  Sink<ShoppingCartProductVM> get substraction => itemSubtractionController.sink;
  final itemSubtractionController = StreamController<ShoppingCartProductVM>();

  Sink<BuildContext> get checkout => checkoutCartController.sink;
  final checkoutCartController = StreamController<BuildContext>();

  Sink<Message> get addMessage => messageController.sink;
  final messageController=StreamController<Message>();

  /// Streams
  Stream<ShoppingCart> get cartStream => _cart.stream;
  final _cart = BehaviorSubject<ShoppingCart>();

  Stream<Message> get cartMessageStream => _cartMessage.stream;
  final _cartMessage = BehaviorSubject<Message>();


  ShoppingCartBloc() {
    itemAdditionController.stream.listen(handleItemAdd);
    itemSubtractionController.stream.listen(handleItemRem);
    messageController.stream.listen(handleMessage);
    checkoutCartController.stream.listen(checkOutcart);
  }

  ///
  /// Logic for product added to shopping cart.
  ///
  void handleItemAdd(ShoppingCartProductVM item) {
    Logger(TAG).info("Add product to the shopping cart");
    cart.addProduct(item);
    cart.calculate();
    ShopCartModel shopCartModel=new ShopCartModel();
    shopCartModel.amount=0;
    shopCartModel.catKey=item.catKey;
    shopCartModel.count=item.count;
    shopCartModel.code='';
   // databaseHelper.saveShopCart(shopCartModel);
    _cart.add(cart);
    return;
  }

  ///
  /// Logic for product removed from shopping cart.
  ///
  void handleItemRem(ShoppingCartProductVM item) {
    Logger(TAG).info("Remove product from the shopping cart");
    cart.remProduct(item);
   // databaseHelper.deleteShopCartByCode(item.code);
    cart.calculate();
    _cart.add(cart);
    return;
  }

  void handleMessage(Message msg)
  {
    message=msg;
    cart.addMessage(msg);
    _cart.add(cart);
  }
  ///
  /// Clears the shopping cart
  ///
  void clearCart() {
    cart.clear();
  }

void loadItemsInCart() async {
  List<ShopCartModel> itemsInCart=new List();
  ////itemsInCart= await databaseHelper.getShopCartItems();
  if(itemsInCart!=null && itemsInCart.length>0)
  {
    //ShoppingCartBloc _shopBloc=BlocProvider.of<GlobalBloc>(context).shoppingCartBloc;
    itemsInCart.forEach((i)  {
    ShoppingCartProductVM temp_model=ShoppingCartProductVM.fromShopCartModel(i);
    //temp_model.name=temp_model.getNameFromMap(i.catKey, i.code);
    addition.add(temp_model);
  }
    );
  }
}

  void checkOutcart(BuildContext context)
    {


        
    }
  @override
  void dispose() {
    itemAdditionController.close();
    itemSubtractionController.close();
    checkoutCartController.close();
  }
}*/
