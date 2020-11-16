import 'package:anad_magicar/bloc/car/confirm/confirm_car.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/swipe_button.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/viewmodel/car_info_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/car/role_sheet.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/magicar_appbar.dart';
import 'package:anad_magicar/widgets/magicar_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/utils/dart_helper.dart';

class CarWidgetFactory extends StatefulWidget {


  int carCounts;
  Function addCar;
  Function toggle;
  Function showAccessable;
  List<CarInfoVM> cars;
  bool isForAccessable;
  @override
  CarWidgetFactoryState createState() {
    // TODO: implement createState
    return CarWidgetFactoryState();
  }

  CarWidgetFactory({
    @required this.cars,
    @required this.carCounts,
    @required this.addCar,
    @required this.toggle,
    @required this.isForAccessable,
    @required this.showAccessable
  });
}

class CarWidgetFactoryState extends State<CarWidgetFactory> {


  bool hasInternet=true;

  _deleteCarToUser(int userId,int carId) async{
    ServiceResult result=await restDatasource.deletecarToUser(userId, carId);
    if(result!=null)
    {
      centerRepository.showFancyToast(result.Message,true);
    }
    else
    {
      centerRepository.showFancyToast(Translations.current.hasErrors(),false);
    }
  }

  _showBottomSheetAcceptRole(BuildContext cntext,int carId,int userId)
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return new ChangeRoleSheet(
            user: null,
            userId: userId,
            changeRole: (userId,roleId) {
              confirmCarBloc.add(new LoadConfirmCarEvent(
                  userId,
                  carId,
                  roleId,
                  context,
                  Constants.CAR_TO_USER_STATUS_CONFIRMED_TAG));
            },
          ) ;
        });
  }
  List<Widget> getCarsTiles(List<CarInfoVM> cars) {
    List<Widget> list = [];
    if (cars != null) {
      for (CarInfoVM c in cars) {
        //Car car=centerRepository.getCars().where((cr)=>cr.carId==c.CarId).toList().first;
        String name = DartHelper.isNullOrEmptyString(c.brandTitle);
        String desc=DartHelper.isNullOrEmptyString(c.Description);
        String carId=c.carId.toString();
        String modelTitle=DartHelper.isNullOrEmptyString(c.modelTitle);
        String detailTitle=DartHelper.isNullOrEmptyString(c.modelDetailTitle);
        String fromDate=DartHelper.isNullOrEmptyString( c.fromDate);
        bool isAdmin=c.isAdmin;
        int statusId=c.CarToUserStatusConstId;
        list.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ListTile(
                  title:Card(
                    margin: new EdgeInsets.only(
                        left: 2.0, right: 2.0, top: 5.0, bottom: 5.0),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white,width: 0.0),
                      borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                    ),
                   // color: Colors.white70,
                    elevation: 0.0,
                    child:
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.only(right: 10.0,left: 10.0),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text( Translations.current.carId(),style: TextStyle(fontSize: 18.0)),
                              Text( carId,style: TextStyle(fontSize: 20.0)),
                            ],
                          ),
                        ),
    new Padding(
    padding: const EdgeInsets.only(
    left: 10.0,
    right: 10.0
    ),
    child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(Translations.current.carTitle(),style: TextStyle(fontSize: 18.0)),
                            Text(name ,style: TextStyle(fontSize: 18.0)),
                          ],
                        ),
    ),
    new Padding(
    padding: const EdgeInsets.only(
    left: 10.0,
    right: 10.0
    ),
    child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(Translations.current.carModelTitle(),style: TextStyle(fontSize: 18.0)),
                            Text(modelTitle ,style: TextStyle(fontSize: 18.0)),
                          ],
                        ),
    ),
    new Padding(
    padding: const EdgeInsets.only(
    left: 10.0,
    right: 10.0
    ),
    child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(Translations.current.carModelDetailTitle(),style: TextStyle(fontSize: 18.0)),
                            Text(detailTitle ,style: TextStyle(fontSize: 18.0)),
                          ],
                        ),
    ),
    new Padding(
    padding: const EdgeInsets.only(
    left: 10.0,
    right: 10.0
    ),
    child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(Translations.current.startDate() ,style: TextStyle(fontSize: 18.0)),
                            Text(fromDate,style: TextStyle(fontSize: 18.0), ),
                          ],
                        ),
    ),
                      ],
                    ),
                  ),
                  subtitle: Text(  Translations.current.description()+' : '+ DartHelper.isNullOrEmptyString( desc)),
                  trailing: Container(width: 0.0,height: 0.0,)
              ),
              widget.isForAccessable ? FlatButton(child:
              Text(Translations.current.showAccessablActions(),
                style: TextStyle(color: Colors.green,fontSize: 18.0),),onPressed: (){
                    widget.showAccessable(c.carId,c.userId);
              },) :
                  Container(width: 0.0,height: 0.0,),
              Container(
                height: 48.0,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    isAdmin && statusId==Constants.CAR_TO_USER_STATUS_WAITING_TAG ?   Container(
                      width: 100.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          border: Border.all(color: Colors.pinkAccent,width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      child:
                    FlatButton(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(Translations.current.confirm(),style:TextStyle(fontSize: 10.0)),
                      onPressed: () {
                        if(isAdmin) {
                         /* confirmCarBloc.add(new LoadConfirmCarEvent(
                              c.userId,
                              c.carId,

                              context,
                              Constants.CAR_TO_USER_STATUS_CONFIRMED_TAG));*/
                         _showBottomSheetAcceptRole(context, c.carId, c.userId);
                        }
                      },
                    ) ) :
                    Container(width: 0.0,height: 0.0,),
                   /* isAdmin ?   Container(
                      width: 100.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          border: Border.all(color: Colors.pinkAccent,width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      child:   FlatButton(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(Translations.current.delete(),style:TextStyle(fontSize: 12.0,color: Colors.white)),
                      onPressed: () {
                            _deleteCarToUser(c.userId, c.carId);
                      },
                    ) ) :
                    Container(width: 0.0,height: 0.0,)*/
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
    return list;
  }


  Widget createBody(List<CarInfoVM> cars,
      bool connection)
  {

    return
      Stack(
        overflow: Overflow.visible,
        children: <Widget> [
          new Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
           // color: Color(0xfffefefe),
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
                padding: EdgeInsets.all(1),
                child:
                Column(children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            leading: Text(Translations.current.car(),
                                style: Theme.of(context).textTheme.subhead),
                            trailing: Text(widget.carCounts.toString(),
                                style:
                                Theme.of(context).textTheme.headline),
                            onTap: () {
                              /*Navigator.of(context).pushNamed('/addcar',arguments: new AddCarVM(notyBloc : null,
                                fromMainApp: true));*/
                            },
                          ),

                        ),

                        Card(

                          child:
                          ExpansionTile(
                              title: Text(Translations.current.carsNo()+ " ( " +
                                  widget.carCounts.toString() +
                                  " ) "),
                              children: getCarsTiles(cars)),
                        ) /*: Card(
                        child: ExpansionTile(
                            title: Text(Translations.current.carsNo()+ " ( " +
                                _carCounts.toString() +
                                " ) "),
                            children: getCarsTiles(cars)),
                      ),*/

                      ],
                    ),
                  ),
                ],
                ),
              ),
            ) :
            NoDataWidget(),
          ),
          Positioned(
            child:
            new MagicarAppbar(

              backgroundColorAppBar: Colors.transparent,
              title: new MagicarAppbarTitle(
                //image: Image.asset(name),
                currentColor: Colors.blueAccent,
                actionIcon: null,//Icon(Icons.add_circle_outline,color: Colors.redAccent,size: 20.0,),
                actionFunc: null,//widget.addCar,
              ),

              actionsAppBar: hasInternet ? null : [
                new Row(
                  children: <Widget>[
                    Image.asset('assets/images/no_internet.png'),
                  ],
                )
              ],
              elevationAppBar: 0.0,
              iconMenuAppBar: Icon(Icons.arrow_back,color: Colors.blueAccent,),
              toggle: widget.toggle ,
            ),
          ),
        ],
      );
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return createBody(widget.cars, true);
  }

}
