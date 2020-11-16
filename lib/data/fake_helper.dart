/*
import 'dart:async';

import 'package:anad_magicar/models/viewmodel/exercise_program.dart';
import 'package:anad_magicar/models/viewmodel/food_program.dart';
import 'package:anad_magicar/models/viewmodel/myprograms_vm.dart';
import 'package:anad_magicar/models/viewmodel/program_detail.dart';
import 'package:anad_magicar/models/viewmodel/request.dart';
import 'package:anad_magicar/models/viewmodel/user.dart';



class Helper {
 static User createUser()
  {
    User user=User(1,
        "reza",
        "123456",
        "Reza",
        "Nader",
        "test2gmail.com",
        "30",
        "09121234567",
        "1",
        "A+",
        "",
        1,
        1,
        "185",
        "70",
        "20",
        "25",
        "10",
        "15",
        "20",
        "20", "", "", "");
    return user;
  }

  static List<MyProgramsVM> getExercisePrograms()
  {

    Requests requests=Requests(1,1,1,1,"","","برنامه تمرینی بابت مسابقات",1,1,"",1,false);
    //ExercisePrograms exercisePrograms=ExercisePrograms( 1,  1, "jjjjjjjjjj","", "برنامه تمرینی بابت مسابقات");
    FoodPrograms foodPrograms=FoodPrograms(1, 1, "برنامه رژیمی بابت مسابقات", "", "برنامه رژیمی بابت مسابقات");
    ProgramDetails programDetails=ProgramDetails(1, 1, 1, 1, 1, 20, 60);
    MyProgramsVM p1= MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
    MyProgramsVM p2= MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
    MyProgramsVM p3= MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
    MyProgramsVM p4= MyProgramsVM(programLevel: "مبتدی",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
    MyProgramsVM p5= MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
    MyProgramsVM p6= MyProgramsVM(programLevel: "مبتدی",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);

    List<MyProgramsVM> result=[p1,p2,p3,p4,p5,p6];
    return result;
  }

 static List<MyProgramsVM> getFoodPrograms()
 {
   Requests requests=Requests(1,1,1,1,"","","برنامه تمرینی بابت مسابقات",1,1,"",1,true);
   ExercisePrograms exercisePrograms=ExercisePrograms( 1,  1, "ttttttttttt","", "برنامه تمرینی بابت مسابقات");
   FoodPrograms foodPrograms=FoodPrograms(1, 1, "برنامه رژیمی بابت مسابقات", "", "برنامه رژیمی بابت مسابقات");
   ProgramDetails programDetails=ProgramDetails(1, 1, 1, 1, 1, 20, 60);
   //MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
   MyProgramsVM p1= MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
   MyProgramsVM p2= MyProgramsVM(programLevel: "مبتدی",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
   MyProgramsVM p3= MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
   MyProgramsVM p4= MyProgramsVM(programLevel: "مبتدی",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
   MyProgramsVM p5= MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
   MyProgramsVM p6= MyProgramsVM(programLevel: "پیشرفته",exercisePrograms: exercisePrograms,foodPrograms: foodPrograms,programDetails: programDetails,request: requests);
   List<MyProgramsVM> result=[p1,p2,p3,p4,p5,p6];
    return result;
 }
}
*/
