/*
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:flutter/material.dart';


class ShoppingCartAppBarIcon extends StatefulWidget {
  ShoppingCartAppBarIcon();

  @override
  ShoppingCartAppBarIconState createState() => ShoppingCartAppBarIconState();
}

class ShoppingCartAppBarIconState extends State<ShoppingCartAppBarIcon> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: StreamBuilder(
        stream:
            BlocProvider.of<GlobalBloc>(context).shoppingCartBloc.cartStream,
        initialData: null,
        builder: (context, snapshot) {
          int count = 0;
          if (snapshot.hasData) {

          }
          return Chip(
            label: Text(count.toString()),
            backgroundColor: Colors.transparent,
            avatar: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
        // );
      },
    );
  }
}*/
