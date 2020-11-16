

import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/actions.dart';
import 'package:anad_magicar/model/apis/current_user_accessable_action.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/factory/car/car.dart';
import 'package:anad_magicar/ui/factory/car/final_car.dart';
import 'package:anad_magicar/ui/factory/car/car.dart' as carW;

import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/magicar_appbar.dart';
import 'package:anad_magicar/widgets/magicar_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/model/cars/car.dart';
class FactoryCar {

  static FactoryCar _factoryCar=new FactoryCar._internal();

  static RestDatasource restDS;
  factory FactoryCar(){
    restDS=new RestDatasource();
    return _factoryCar;
  }


  FactoryCar._internal();



  Function _toggle;
  Function _addCar;
  Function _deleteCarToUser;
  Function _acceptCarToUser;
  Function (bool value) onActionChanged;
  bool hasInternet=true;
  List<AdminCarModel> cars;



  Future<List<AdminCarModel>> loadCarsToUserByUserId(int userId) async
    {
    List<AdminCarModel> carsToUser=new List();
    carsToUser=await restDS.getAllCarsByUserId(userId);
    if(carsToUser!=null &&
    carsToUser.length>0)
      return carsToUser;
    return null;
  }

  List<Widget> getCarsTiles(List<AdminCarModel> cars) {
    List<Widget> list = [];
    if (cars!=null) {
      for (AdminCarModel c in cars) {

        String name = DartHelper.isNullOrEmptyString(c.BrandTitle);
        String desc=DartHelper.isNullOrEmptyString(c.Description);
        String carId= c.CarId.toString();
        String modelTitle= DartHelper.isNullOrEmptyString(c.CarModelTitle);
        String detailTitle=DartHelper.isNullOrEmptyString(c.CarModelDetailTitle);
        String fromDate=DartHelper.isNullOrEmptyString( c.FromDate);
        bool isAdmin=c.IsAdmin;

        list.add( ListTile(

          title:Card(
            margin: new EdgeInsets.only(
                left: 2.0, right: 2.0, top: 5.0, bottom: 5.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white,width: 0.0),
              borderRadius: new BorderRadius.all(Radius.elliptical(1, 2)),
            ),
            color: Colors.white70,
            elevation: 0.0,
            child:
            new Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(Translations.current.carId()),
                    SizedBox(width: 5.0,),
                    Text( carId ),
                    SizedBox(width: 5.0,),
                    Text(c.IsActive ? Translations.current.active() : Translations.current.deactive())
                  ],
                ),
                Text( name + " - "+ modelTitle+' - '+detailTitle+ ' - '+ Translations.current.fromDate()+
                    " : "+fromDate,style: TextStyle(fontSize: 10.0),),
              ],
            ),
          ),
          subtitle: Text( ' # '+ Translations.current.description()+' : '+ DartHelper.isNullOrEmptyString( desc)),
          trailing: new Row(
            children: <Widget>[

              FlatButton(
                padding: EdgeInsets.only(left: 0, right: 0),
                child: Icon(Icons.verified_user,size: 28.0, color: Colors.red),
                onPressed: () {
                  _acceptCarToUser();
                },
              ),
              FlatButton(
                padding: EdgeInsets.only(left: 0, right: 0),
                child: Icon(Icons.delete_outline,size: 28.0, color: Colors.red),
                onPressed: () {
                  _deleteCarToUser();
                },
              ),
          FlatButton(
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Icon(Icons.check_circle_outline,size: 28.0, color: Colors.red),
            onPressed: () {
            },
          ),
            ],
          )
        ));
      }
    }
    return list;
  }

  List<Widget> getAccessToActionCarsTiles(
      List<CurrentUserAccessableActionModel> actions,
      List<AdminCarModel> cars) {
    List<Widget> list = [];
    if (actions!=null && cars!=null) {
      for (CurrentUserAccessableActionModel act in actions) {
        List<AdminCarModel> car = cars/*.where((c) => c.UserId == act.UserId)
            .toList()*/;
        if (car != null && car.length > 0) {
          ActionModel actModel=centerRepository.getActionByActionCode(act.accessableActions[0].ActionId);
          String actionName = DartHelper.isNullOrEmptyString(actModel.ActionTitle);
          String desc = DartHelper.isNullOrEmptyString(actModel.Description);
          bool active= actModel.IsActive;
          bool isAdmin = car[0].IsAdmin;

          list.add(ListTile(

              title: Card(
                margin: new EdgeInsets.only(
                    left: 2.0, right: 2.0, top: 5.0, bottom: 5.0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 0.0),
                  borderRadius: new BorderRadius.all(Radius.elliptical(1, 2)),
                ),
                color: Colors.white70,
                elevation: 0.0,
                child:
                new Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(actionName),
                        SizedBox(width: 5.0,),
                        Text(isAdmin
                            ? Translations.current.active()
                            : Translations.current.deactive())
                      ],
                    ),
                   SwitchListTile(
                     value: actModel.selected,
                     selected: actModel.selected,
                     onChanged: (value) { onActionChanged(value);}
                   )
                  ],
                ),
              ),
              subtitle: Text(
                  ' # ' + Translations.current.description() + ' : ' +
                      DartHelper.isNullOrEmptyString(desc)),
              trailing: new Row(
                children: <Widget>[

                  FlatButton(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Icon(
                        Icons.verified_user, size: 28.0, color: Colors.red),
                    onPressed: () {
                      _acceptCarToUser();
                    },
                  ),
                  FlatButton(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Icon(
                        Icons.delete_outline, size: 28.0, color: Colors.red),
                    onPressed: () {
                      _deleteCarToUser();
                    },
                  ),
                  FlatButton(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Icon(Icons.check_circle_outline, size: 28.0,
                        color: Colors.red),
                    onPressed: () {},
                  ),
                ],
              )
          ));
        }
      }
    }
    return list;
  }

  Widget createBody(List<AdminCarModel> cars,
      bool connection,
      bool appbar,
      BuildContext context)
  {

    int _carCounts=cars.length;
    return
      Stack(
        overflow: Overflow.visible,
        children: <Widget> [
          new Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            color: Color(0xfffefefe),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70.0),
                  bottomLeft: Radius.circular(3.0) ),
            ),
            child: cars!=null &&
                cars.length > 0 ? new Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 0.0,
                left: 2.0,
              ),
              child:
              Container(
                padding: EdgeInsets.all(16),
                child:
                Column(children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            leading: Text(Translations.current.car(),
                                style: Theme.of(context).textTheme.subhead),
                            trailing: Text(_carCounts.toString() + " ",
                                style:
                                Theme.of(context).textTheme.headline),
                            onTap: () {
                              Navigator.of(context).pushNamed('addcar',arguments: true);
                            },
                          ),

                        ),
                        connection ? Card(
                          child: ExpansionTile(
                              title: Text(Translations.current.carsNo()+ " ( " +
                                  _carCounts.toString() +
                                  " ) "),
                              children: getCarsTiles(cars)),
                        ) : Card(
                          child: ExpansionTile(
                              title: Text(Translations.current.carsNo()+ " ( " +
                                  _carCounts.toString() +
                                  " ) "),
                              children: getCarsTiles(cars)),
                        ),

                      ],
                    ),
                  ),
                ],
                ),
              ),
            ) :
            NoDataWidget(),
          ),
        appbar ?  Positioned(
            child:
            new MagicarAppbar(

              backgroundColorAppBar: Colors.transparent,
              title: new MagicarAppbarTitle(
                //image: Image.asset(name),
                currentColor: Colors.redAccent,
                actionIcon: Icon(Icons.add_circle_outline,color: Colors.redAccent,size: 20.0,),
                actionFunc: _addCar,
              ),

              actionsAppBar: hasInternet ? null : [
                new Row(
                  children: <Widget>[
                    Image.asset('assets/images/no_internet.png'),
                  ],
                )
              ],
              elevationAppBar: 0.0,
              iconMenuAppBar: Icon(Icons.arrow_back,color: Colors.redAccent,),
              toggle: _toggle ,
            ),
          ) :
            Container(width: 0,height: 0,),
        ],
      );
  }

  Widget createAccessToActionsForCar(BuildContext context,
      List<CurrentUserAccessableActionModel> accessToActions,
      List<AdminCarModel> cars)
  {
    return
      Stack(
        overflow: Overflow.visible,
        children: <Widget> [
          new Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            color: Color(0xfffefefe),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70.0),
                  bottomLeft: Radius.circular(3.0) ),
            ),
            child: cars!=null &&
                cars.length > 0 ? new Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 0.0,
                left: 2.0,
              ),
              child:
              Container(
                padding: EdgeInsets.all(16),
                child:
                Column(children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            leading: Text(Translations.current.car(),
                                style: Theme.of(context).textTheme.subhead),
                            trailing: Text(" ",
                                style:
                                Theme.of(context).textTheme.headline),
                            onTap: () {
                              Navigator.of(context).pushNamed('addcar',arguments: true);
                            },
                          ),

                        ),
                          Card(
                          child: ExpansionTile(
                              title: Text(Translations.current.accessToActions()),
                              children: getAccessToActionCarsTiles(accessToActions,cars)),
                        )
                      ],
                    ),
                  ),
                ],
                ),
              ),
            ) :
            NoDataWidget(),
          ),
        ],
      );
  }

  showCarsOnSheet(BuildContext contx)
   {
   showModalBottomSheetCustom(context: contx,
       builder: (BuildContext context){
          return new ListView(
            children: <Widget>[
              createBody(cars,
              hasInternet,
              false,
              context),
              Container(
                width: 50.0,
                child:
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
         child:
              Button(title: Translations.current.cancel(),
                  clr:Colors.amber,
                  color:Colors.amberAccent.value,),),),
            ],
          );


       });
  }


}


FactoryCar factoryCar=new FactoryCar();
