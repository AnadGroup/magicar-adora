import 'dart:async';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:file/file.dart';
import 'package:flutter/widgets.dart';
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/register/ProfileCart.dart';
import 'package:anad_magicar/bloc/shopcart/shoppingcart.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class ProfileBloc implements BlocBase {
  static const String TAG = "ProfileBloc";

  ProfileCart profile = ProfileCart();
  Message message=new Message();
  /// Sinks
  Sink<User> get addition => itemAdditionController.sink;
  final itemAdditionController = StreamController<User>();

  Sink<User> get substraction => itemSubtractionController.sink;
  final itemSubtractionController = StreamController<User>();


  Sink<Message> get addMessage => messageController.sink;
  final messageController=StreamController<Message>();

  /// Streams
  Stream<ProfileCart> get profileStream => _profile.stream;
  final _profile = BehaviorSubject<ProfileCart>();

  Stream<Message> get cartMessageStream => _cartMessage.stream;
  final _cartMessage = BehaviorSubject<Message>();


  ProfileBloc() {
    itemAdditionController.stream.listen(handleItemUpdate);
    itemSubtractionController.stream.listen(handleItemRem);
    messageController.stream.listen(handleMessage);
    //checkoutCartController.stream.listen(checkOutcart);
  }

  ///
  /// Logic for product added to shopping cart.
  ///
  void handleItemUpdate(User item) async {
    Logger(TAG).info("Add product to the shopping cart");
    if(message==null)
      {
        message=new Message();
      }
  /* int res=await profile.updateStudent(item);
   if(res>0) {
      if(centerRepository.profileImage!=null)
        {
          UserRepository userRepository=new UserRepository();
        int res=await userRepository.uploadProfileImage();
        if(res>0)
          {
            profile.addMessage(new Message(text: 'PROFILE_UPDATED', type: 'success'));
            message=new Message(text: 'PROFILE_UPDATED', type: 'success');
          }
        else
          {
            profile.addMessage(new Message(text: 'PROFILE_UPDATED', type: 'success'));
            message=new Message(text: 'PROFILE_UPDATED', type: 'success');
          }
        }

   }
   else
     {
       profile.addMessage(new Message(text: 'PROFILE_UPDATED', type: 'failed'));
       message=new Message(text: 'PROFILE_UPDATED', type: 'failed');
     }*/
    _profile.add(profile);
   addMessage.add(message);
   /* _cartMessage.add(message);*/
    return;
  }

  ///
  /// Logic for product removed from shopping cart.
  ///
  void handleItemRem(User item) {
    Logger(TAG).info("Remove product from the shopping cart");
    return;
  }

  void handleMessage(Message msg)
  {
    message=msg;
    profile.addMessage(msg);
    _cartMessage.add(msg);
  }
  ///
  /// Clears the shopping cart
  ///
  void clearCart() {
    //cart.clear();
  }




  @override
  void dispose() {
    itemAdditionController.close();
    itemSubtractionController.close();
   // checkoutCartController.close();
  }
}
