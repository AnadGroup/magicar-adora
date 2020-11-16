/*
import 'dart:io';

import 'package:anad_magicar/models/message.dart';
import 'package:anad_magicar/models/viewmodel/shopping_cart_product_vm.dart';



class ShoppingCart {
  List<ShoppingCartProductVM> products = [];
  double priceNet;
  Message message;
  double countAmount;

  void addProduct(ShoppingCartProductVM p) {


  }

  void remProduct(ShoppingCartProductVM p) {
    if(products!=null &&
    products.length>0)
    {
       List<ShoppingCartProductVM> item_in_cart=null;//products.where((s) => s.code==p.code).toList();
        if(item_in_cart!=null &&
        item_in_cart.length>0)
        {
          int indx=products.indexOf(item_in_cart[0]);
          if(indx>-1)
          {
            if(products[indx].count>0){
              products[indx].count=p.count;
             // repository.getListOfProductsInShoppingList()[indx].count=p.count;
            }
            else{
              products.removeAt(indx);
              //repository.getListOfProductsInShoppingList().removeAt(indx);
            }
          }
          else{
            //products.remove(p);
          }      
       }
    }
    //products.remove(p);
  }

  void addMessage(Message msg)
  {
    message=msg;

  }
  void calculate() {
    priceNet = 0;
    
    countAmount = 0;
    products.forEach((p) {
      //priceNet +=((num.parse( p.priceB).toDouble())*p.count);
      countAmount += p.count;
    });
  }

  void clear() {
    products = [];
    priceNet = 0;
    //priceGross = 0;
    countAmount = 0;
  }
}*/
