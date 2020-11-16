
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:anad_magicar/data/database_helper.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/user/user_details.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';


class ProfileCart {
  User user;
  //UserDetails userDetails;
  int studentId;
  Message message;
  UserRepository userRepository;

 Future<int> updateUser(User std) async
  {
    if(userRepository==null)
      userRepository=new UserRepository();
    /*if(std!=null)
      {
      int res=await userRepository.update(std);
      if(res>0)
        {
         int res2=await userRepository.fetchUpdate(std);
          return res2;
        }
      else
        {
          return 0;
        }
          }*/

    return 1;
  }

  void addMessage(Message msg)
  {
    message=msg;

  }
}
