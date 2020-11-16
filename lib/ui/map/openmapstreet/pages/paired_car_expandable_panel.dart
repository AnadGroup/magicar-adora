import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/send_data.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/model/apis/paired_car.dart';
import 'package:anad_magicar/model/apis/slave_paired_car.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';

class PairedCarsExpandPanel extends StatefulWidget {

  ApiPairedCar pairedCar;
  int carId;
  //Map<int,List<Map<String,dynamic>>> cars;
  NotyBloc<Message> changePairedNoty;
  List<ApiPairedCar> cars;
  List<ApiPairedCar> pcars;

  PairedCarsExpandPanel({Key key,this.changePairedNoty, this.pairedCar,this.cars,this.pcars, this.carId}) : super(key: key);

  @override
  PairedCarsExpandPanelState createState() {
    // TODO: implement createState
    return new PairedCarsExpandPanelState();
  }
}

class PairedCarsExpandPanelState extends State<PairedCarsExpandPanel> {

  bool isRead=false;
  List<ApiPairedCar> groupedCars=new List();
  List<int> carIds=new List();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate=false;
  ApiMessage newPaired;


  Widget createCollapsed(ApiPairedCar car,int carsCount) {
    return  new Padding(padding: EdgeInsets.only(right: 10.0),
      child:
      Column(
        children: <Widget>[
          createHeader(car),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(DartHelper.isNullOrEmptyString( carsCount.toString()),style: TextStyle(fontSize: 16.0),)

            ],
          ),
        ],
      ),);

  }

  addCarToPaired(ApiPairedCar car,int type) async {
    if(type!=Constants.ROWSTATE_TYPE_UPDATE)
      car.PairedCarId=0;
    var result=await restDatasource.savePairedCar(car);
    if(result!=null) {
      centerRepository.showFancyToast(result.Message,true);
      if( result.IsSuccessful){
        centerRepository.showFancyToast(result.Message,true);
        widget.changePairedNoty.updateValue(new Message(type:'CAR_PAIRED'));
      }
      else {
        centerRepository.showFancyToast(result.Message,false);
      }
    } else {
      centerRepository.showFancyToast('خطا در تایید خودرو...',false);
    }
  }
  _deleteCarFromPaired(int masterId,int  secondCar,) async{
    // var result=await restDatasource.savePairedCar(car);
    List<int> carIds=[secondCar];
    var result=await restDatasource.deletePairedCars(masterId, carIds);
    if(result!=null){
      if(result.IsSuccessful){
        centerRepository.showFancyToast(result.Message,true);
        // setState(() {

       // pairedChangedNoty.updateValue(new Message(type: 'CAR_PAIRED'));
        //});
      }else{
        centerRepository.showFancyToast(result.Message,false);
      }
    }
  }
  _showCarPairedActions(int carId,BuildContext context){
    showModalBottomSheetCustom(context: context ,
        mHeight: 0.70,
        builder: (BuildContext context) {
          return new Container(
            height: 250.0,
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child : Padding(
                        padding: EdgeInsets.only(bottom: 20.0, right: 10.0,left: 10.0),
                        child:
                        Button(clr: Colors.pinkAccent,wid:150.0,title: Translations.current.confirm(),),),
                      onTap: (){
                        if(widget.pcars!=null && widget.pcars.length > 0) {
                          var ppcar = widget.pcars.where((p) => p.SecondCar.carId == carId).toList();
                          if(ppcar!=null && ppcar.length > 0) {
                            ApiPairedCar pairedCar = new ApiPairedCar(
                                PairedCarId: ppcar.first.PairedCarId,
                                MasterCarId: ppcar.first.MasterCar.carId,
                                SecondCarId: ppcar.first.SecondCar.carId,
                                FromDate: ppcar.first.FromDate,
                                ToDate: DateTimeUtils.getDateJalali(),
                                FromTime: ppcar.first.FromTime,
                                ToTime: DateTimeUtils.getTimeNow(),
                                Description: null,
                                IsActive: true,
                                RowStateType: Constants.ROWSTATE_TYPE_UPDATE,
                                CarIds: null,
                                master: null,
                                slaves: null);
                            addCarToPaired(pairedCar, Constants.ROWSTATE_TYPE_UPDATE);
                          }
                          /*if (carsSlavePairedList != null &&
                  carsSlavePairedList.length > 0) {

                var cpaired = carsSlavePairedList.where((c) =>
                c.CarId == car.CarId).toList();
                if (cpaired != null && cpaired.length > 0) {


                }
              }*/
                         // Navigator.pop(context);
                        }

                      },),
                    /*GestureDetector(
                      child : Padding(
                        padding: EdgeInsets.only(bottom: 20.0, right: 10.0,left: 10.0),
                        child:
                        Button(clr: Colors.pinkAccent,wid:150.0,title: Translations.current.delete(),),),
                      onTap: (){

                        _deleteCarFromPaired(car.masterId,car.CarId);
                        Navigator.pop(context);
                      },),*/

                  ],
                ),

                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child :Button(clr: Colors.pinkAccent,wid:150.0,title: Translations.current.navigateToCurrent(),),
                      onTap: (){
                        Navigator.pop(context);
                        navigateToCarSelected(0,true, car.CarId,true);
                      },),
                    GestureDetector(
                      child :Button(clr: Colors.pinkAccent,wid:150.0,title: 'محل جاری خودرو',),
                      onTap: (){
                        Navigator.pop(context);
                        navigateToCarSelected(0,true, car.CarId,false);
                      },),
                  ],
                ),*/



              ],
            ),
          );
        });
  }
  Widget createExpanded(List<ApiPairedCar> cars) {
    return  Container(
      height: 250.0,
      child:
      ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: cars.length,
        itemBuilder: (context, index) {
          String carPelaq='';
          String model='';
          String detail='';
          String brand ='';
          if(centerRepository.getCars()!=null && centerRepository.getCars().length>0){
            var carFound=centerRepository.getCars().where((c)=> c.carId == cars[index].SecondCar.carId).toList();
            if(carFound!=null && carFound.length>0){
              Car cr =carFound.first;
              carPelaq=cr.pelaueNumber ?? '';
              model=cr.carModelTitle ?? '';
              detail=cr.carModelDetailTitle ?? '';
              brand= cr.brandTitle ?? '';
            }
          }
          return
            Card(
              margin: new EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 8.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xffe5e5e5).withOpacity(0.4), width: 0.0),
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              child:
              GestureDetector(
                onTap: () {
                    if(!cars[index].IsActive)
                      _showCarPairedActions(cars[index].SecondCar.carId, context);
                },
                child:
                new Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: cars[index].IsActive ? Colors.lightBlue.withOpacity(0.4) :
                    Color(0xffe5e5e5).withOpacity(0.4),
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(5.0)),
                  ),
                  child:
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
                        child:
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(Translations.current.carId(),
                              style: TextStyle(fontSize: 16.0),),
                            new Padding(
                              padding: EdgeInsets.only(right: 10.0, left: 5.0),
                              child: Text(cars[index].SecondCar.carId.toString(),
                                style: TextStyle(fontSize: 16.0),
                                overflow: TextOverflow.fade, softWrap: true,),),
                          ],),),
                      new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
                        child:
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(right: 10.0, left: 20.0),
                              child:
                              Text(DartHelper.isNullOrEmptyString(brand), style: TextStyle(
                                  fontSize: 16.0),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,),),
                          ],
                        ),),
                      new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
                        child:
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DartHelper.isNullOrEmptyString(model),
                              style: TextStyle(fontSize: 16.0),),
                            Text(
                              DartHelper.isNullOrEmptyString(DartHelper.isNullOrEmptyString(detail)),
                              style: TextStyle(fontSize: 16.0),),
                          ],
                        ),
                      ),
                      new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
                        child:
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(Translations.current.carpelak(),
                              style: TextStyle(fontSize: 16.0),),
                            new Padding(
                              padding: EdgeInsets.only(right: 10.0, left: 5.0),
                              child: Text(DartHelper.isNullOrEmptyString(carPelaq),
                                style: TextStyle(fontSize: 16.0),
                                overflow: TextOverflow.fade, softWrap: true,),),
                          ],),),
                      new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
                        child:
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(Translations.current.carcolor(),
                              style: TextStyle(fontSize: 16.0),),
                            new Padding(
                              padding: EdgeInsets.only(right: 10.0, left: 5.0),
                              child: Text(DartHelper.isNullOrEmptyString(cars[index].SecondCar.colorTitle),
                                style: TextStyle(fontSize: 16.0),
                                overflow: TextOverflow.fade, softWrap: true,),),
                          ],),),
                    ],
                  ),
                ),
              ),
            );
        },
      ),
    );
  }

  Widget createHeader(ApiPairedCar car) {
    var carinfo=centerRepository.getCars().where((c)=>c.carId==car.master).toList();
    Car c;
    if(carinfo!=null && carinfo.length>0){
      c=carinfo.first;
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[


        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(right: 10.0,left: 10.0),
              child: Text(Translations.current.carToRequestForPair()),),
            new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
              child: Container(
                width: 22.0,
                height: 22.0,
                child:

            new Padding(padding: EdgeInsets.only(right: 10.0,left: 10.0),
              child:
              Text(DartHelper.isNullOrEmptyString(c.pelaueNumber)) ),),),

          ],
        ),
        new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                ),
                child:
                 Text(Translations.current.carPairedCounts(),style: TextStyle(color: Colors.white,fontSize: 12.0),),
                ),
              Text(car.slaves!=null ? car.slaves.length.toString() : '0',style: TextStyle(color: Colors.white,fontSize: 12.0),),
            ],
          ),
        ),
      ],
    );

  }

  changeSmsStatus(ApiMessage message) async {
    var result=await restDatasource.changeMessageStatus(message.MessageId, ApiMessage.MESSAGE_STATUS_AS_READ_TAG);
    if(result!=null){
      if(result.IsSuccessful){
        setState(() {
          isRead=true;
        });
      }
      else
      {
        setState(() {
          isRead=false;
        });
      }
    }
  }









  @override
  void initState() {

    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.cars.length,
      itemBuilder: (context, index) {
       // int masterId=widget.cars[index].master;
        //List<SlavedCar> newList=widget.cars[index].slaves;
        List<ApiPairedCar> newList=widget.pcars;//.where((p)=> p.IsActive==false).toList();
        ApiPairedCar pairedCar=widget.pcars[index];
        return
          ExpandableNotifier(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: ScrollOnExpand(
                child: Card(
                  color: Colors.white.withOpacity(0.2),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expandable(
                        collapsed: createCollapsed(pairedCar,newList.length),
                        expanded: createExpanded(newList),
                      ),

                      Divider(height: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Builder(
                            builder: (context) {
                              var controller = ExpandableController.of(context);

                              return FlatButton(
                                child: controller.expanded ? Icon(
                                    Icons.arrow_drop_up) :
                                Icon(Icons.arrow_drop_down_circle),
                                onPressed: () {
                                  controller.toggle();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
      },
    );
  }
}
