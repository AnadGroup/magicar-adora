import 'dart:async';
import 'dart:io' as io;



import 'package:anad_magicar/model/join_car_model.dart';
import 'package:anad_magicar/model/shopcart_model.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:flutter/services.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';

//import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:path/path.dart';


import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {

  static final String JoindCar_TableName='JoindCar';

  static final DatabaseHelper _instance = new
  DatabaseHelper.internal();
  factory DatabaseHelper() {

   return _instance;
  }
  static Database _db;
  //SqfliteAdapter _adapter;
  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  /*SqfliteAdapter getAdapter() {
    return  _adapter;
  }*/

  initAdapter() async
  {
    /*var dbPath=await getDatabasesPath();
    if(_adapter==null) {
        _adapter = SqfliteAdapter(path.join(dbPath,'anad.db'), version: 1);
        _adapter.connect();
  }*/
  }
  initDb() async {
    io.Directory documentsDirectory = await
    getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "anad.db");
    var theDb = await openDatabase(path, version: 1, onCreate:
    _onCreate);
    return theDb;
  }


  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY autoincrement, UserName TEXT,Password TEXT,Mobile TEXT,Token TEXT,Admin INTEGER,IsActive BIT,Owner INTEGER)");

    await db.execute(
        "CREATE TABLE ShopCart(id INTEGER PRIMARY KEY autoincrement, Count TEXT,Amount TEXT,Code TEXT,CatKey TEXT)");

    await db.execute(
        "CREATE TABLE UserDetails(id INTEGER PRIMARY KEY autoincrement, FirstName TEXT,LastName TEXT,Code TEXT,PostalCode TEXT,Password TEXT,SocialNo TEXT,Tel TEXT,Mobile TEXT,Lat TEXT,Long TEXT,Address TEXT,Email TEXT)");

    await db.execute(
        "CREATE TABLE JoindCar(id INTEGER PRIMARY KEY autoincrement, UserName TEXT,Password TEXT,Mobile TEXT,BrandTitle TEXT,CarModelTitle TEXT,CarModelDetailTitle TEXT,UserId INTEGER,Admin INTEGER,IsActive BIT,CarId INTEGER)");

  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMapForSave());
    return res;
  }

  Future<int> saveJoindCars(JoinCarModel model) async {
    var dbClient = await db;
    int res = await dbClient.insert(JoindCar_TableName, model.toMap());
    return res;
  }


  Future<List<AdminCarModel>> getLastCarsJoint() async{
    List<AdminCarModel> finalResult=new List();
    var dbClient=await db;
    var res=await dbClient.query(JoindCar_TableName);
    finalResult=res.isNotEmpty ? res.map((sc) => AdminCarModel.fromMapForCarJoint(sc)).toList() : [] ;
    return finalResult;
  }

  Future saveShopCart(ShopCartModel sc) async {
    var dbClient = await db;
    var item=await dbClient.query('ShopCart',columns: ['Code','Count','Amount','CatKey'], where: 'Code = ?',whereArgs: [sc.code] );
    if(item.isNotEmpty)
    {
      return await updateShopCartByCode(sc);
    }
    else{
    var res = await dbClient.insert("ShopCart", sc.toMap());
    return res;
    }

  }



  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<int> deleteJoindCar(int carId) async {
    var dbClient = await db;
    int res = await dbClient.delete(JoindCar_TableName,where: carId.toString());
    return res;
  }

  Future<int> deleteUserDetails() async {
    var dbClient = await db;
    int res = await dbClient.delete("UserDetails");
    return res;
  }

  Future<int> deleteShopCart() async {
    var dbClient = await db;
    int res = await dbClient.delete("ShopCart");
    return res;
  }


  Future<int> deleteShopCartByCode(String code) async {
    var dbClient = await db;
    int res = await dbClient.delete("ShopCart",where: code);
    return res;
  }

Future updateShopCartByCode(ShopCartModel scm) async {
  // Map<String,dynamic> values=new Map();
  // values.putIfAbsent('Count', ()=> scm.count);
  // values.putIfAbsent('Amount', ()=> scm.amount);

    var dbClient = await db;
    var res = await dbClient.update("ShopCart",scm.toMap(), where: 'Code=?',whereArgs: [scm.code]);
    return res;
  }

Future<int> getCountShopCart() async {
    var dbClient = await db;
    int res = Sqflite
              .firstIntValue( await dbClient.rawQuery("Select Sum([CAST([Count] as INT)) as Counts From ShopCart",));
    return res;
  }

Future<double> getAmountShopCart() async {
    var dbClient = await db;
    List<Map<String,dynamic>> res = await dbClient.rawQuery("Select Sum(CAST([Amount] as DECIMAL)) as Amounts From ShopCart",);

    if(res.isNotEmpty)
      return res.map((a)=> SumAmounts.fromMap(a) ).toList()[0].amounts;
    else
      return 0;
  }



  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0 ? true : false;
  }

Future<List<ShopCartModel>> getShopCartItems() async
{
  List<ShopCartModel> finalResult=new List();
    var dbClient=await db;
    var res=await dbClient.query("ShopCart");
    finalResult=res.isNotEmpty ? res.map((sc) => ShopCartModel.fromMap(sc)).toList() : [] ;
    return finalResult;
  // if(res!=null && res.length>0 &&
  //     res.first!=null)
  // {
  //    res.forEach((f) =>
  //     final_result.add( ShopCartModel.fromMap(f)) );

  //     return final_result;
  // }
  // return null;
}
  Future<User> getUserInfo() async {
    var dbClient=await db;
    var res=await dbClient.query("User");
    if(res!=null ) {
      if (res.first != null) {
        RxBus.post(ChangeEvent(message: 'USER_LOADED'));
      }
      else {
        RxBus.post(ChangeEvent(message: 'USER_LOADED_ERROR'));
      }
    }
    else{
      RxBus.post(ChangeEvent(message: 'USER_LOADED_ERROR'));
    }
    return Future.value(User.fromMapForSave(res.first));
  }




}

class SumAmounts {
  double amounts=0;
  SumAmounts(this.amounts);
  factory SumAmounts.fromMap(Map<String,dynamic> obj)
  {
    return new SumAmounts(obj['Amounts']);
  }
}


DatabaseHelper databaseHelper=new DatabaseHelper();
