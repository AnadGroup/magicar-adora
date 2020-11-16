import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/basic/message_bloc.dart';
import 'package:anad_magicar/bloc/register/profile_bloc.dart';
import 'package:anad_magicar/bloc/search/SearchBloc.dart';
import 'package:anad_magicar/bloc/search/index.dart' as bloc2;
import 'package:anad_magicar/bloc/shopcart/shoppingcart_bloc.dart';

class GlobalBloc implements BlocBase {

  ProfileBloc profileBloc;
  MessageBloc messageBloc;
  //SearchBloc searchBloc;
  //bloc2.SearchBloc searchEventBloc;
  GlobalBloc() {
    //shoppingCartBloc = ShoppingCartBloc();
    messageBloc = MessageBloc();
    //searchBloc=SearchBloc();
    profileBloc=new ProfileBloc();
    //searchEventBloc=new bloc2.SearchBloc();
  }

  void dispose() {
    //shoppingCartBloc.dispose();
    messageBloc.dispose();
    //searchBloc.dispose();
    profileBloc.dispose();
  }
}