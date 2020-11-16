import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_form.dart';
import 'package:anad_magicar/ui/screen/style/app_style.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';

class ServiceItem extends StatelessWidget {


  ApiService serviceItem;
  ServiceItem({Key key,this.serviceItem}) : super(key: key);
  bool isDurational=false;
  String serviceTypeTitle='';

  _onConfirmToDelete(ApiService sItem,BuildContext context,bool mode,int type) async {

    sItem.RowStateType=mode ? Constants.ROWSTATE_TYPE_UPDATE :
    Constants.ROWSTATE_TYPE_DELETE;
    if(!mode) {
      var result = await restDatasource.saveCarService(sItem);
      if (result != null) {
        if (result.IsSuccessful) {
          centerRepository.showFancyToast(result.Message,true);
          changeServiceNotyBloc.updateValue(new Message(type: 'SERVICE_DELETED',index: sItem.ServiceId));
        }
        else {
          centerRepository.showFancyToast(result.Message,false);
        }

        Navigator.pop(context);
      }
    }
    else{
      Navigator.pushNamed(context, RegisterServicePageState.route,arguments: new ServiceVM(carId: sItem.CarId,
          editMode: true, service: sItem));
    }
  }

  deleteService(ApiService sItem,BuildContext context,bool mode) async{

    if(mode) {
      Navigator.pushNamed(context, RegisterServicePageState.route,arguments: new ServiceVM(carId:sItem.CarId,
          editMode: true, service: sItem));
    } else {
      await animated_dialog_box.showScaleAlertBox(
          title: Center(child: Text(
              Translations.current.confimDelete())),
          context: context,
          firstButton: MaterialButton(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: Colors.white,
            child: Text(Translations.current.yes()),
            onPressed: () async {
              _onConfirmToDelete(sItem, context, mode, 0);
            },
          ),
          secondButton: MaterialButton(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: Colors.white,
            child: Text(Translations.current.no()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          icon: Icon(Icons.info_outline, color: Colors.red,),
          yourWidget: Container(
            child: Text(Translations.current.areYouSureToDelete()),
          ));
    }
  }


  _onUpdateService(ApiService sItem,BuildContext context,bool mode,int type) async {

    sItem.RowStateType= Constants.ROWSTATE_TYPE_UPDATE;
    sItem.ServiceStatusConstId=type;

    if(mode || type==Constants.SERVICE_DONE || type==Constants.SERVICE_NOTDONE) {
      Navigator.pushNamed(context, RegisterServicePageState.route,arguments: new ServiceVM(carId: sItem.CarId,
          editMode: true, service: sItem));
    } else {
      sItem.RowStateType= Constants.ROWSTATE_TYPE_DELETE;
      var result = await restDatasource.saveCarService(sItem);
      if (result != null) {
        if (result.IsSuccessful) {
          centerRepository.showFancyToast(result.Message,true);
         // RxBus.post(new ChangeEvent(type:"SERVICE",message: 'DELETED'));
          changeServiceNotyBloc.updateValue(new Message(type: 'SERVICE_DELETED',index: sItem.ServiceId));
        }
        else {
          centerRepository.showFancyToast(result.Message,false);
        }
      }
      Navigator.of(context).pop();
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double wid=MediaQuery.of(context).size.width*0.18;
    isDurational=serviceItem.serviceType.ServiceTypeConstId==Constants.SERVICE_TYPE_DURATIONALITY;
    if(isDurational) {
        serviceTypeTitle=Translations.current.serviceTypeIsDurational();
      }
    else{
      serviceTypeTitle=Translations.current.serviceTypeIsFunctionality();
    }
    Color backgroundColor=white;
    backgroundColor=serviceItem.ServiceStatusConstId==Constants.SERVICE_DONE ? Colors.greenAccent.withOpacity(0.5) :
    serviceItem.ServiceStatusConstId==Constants.SERVICE_NEAR ? Colors.amberAccent.withOpacity(0.5) :
    serviceItem.ServiceStatusConstId==Constants.SERVICE_CANCEL ? Colors.blueAccent.withOpacity(0.5) :
    serviceItem.ServiceStatusConstId==Constants.SERVICE_FAILD ? Colors.pinkAccent.withOpacity(0.5) :
        Colors.white;

    return Padding(
      padding: EdgeInsets.only(top: 5.0,left: 5.0,right: 5.0,bottom: 5.0),
      child: Card(
        elevation: 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          new Padding(padding: EdgeInsets.only(right: 1.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               Text(DartHelper.isNullOrEmptyString( serviceItem.serviceType.ServiceTypeTitle)),
              ],
            ),),
            new Padding(padding: EdgeInsets.only(right: 1.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(Translations.current.serviceType(),style: TextStyle(fontSize: 16.0),),
                  Text(serviceTypeTitle,style: TextStyle(fontSize: 16.0))
                ],
              ),),
        new Padding(padding: EdgeInsets.only(right: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.serviceDate(),style: TextStyle(fontSize: 16.0),),
                Text(DartHelper.isNullOrEmptyString(serviceItem.ServiceDate),style: TextStyle(fontSize: 16.0))
              ],
            ),),
       /* new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.alarmDate(),style: TextStyle(fontSize: 16.0),),
                Text(DartHelper.isNullOrEmptyString(serviceItem.AlarmDate),style: TextStyle(fontSize: 16.0)),
                Container(
                  width: 34.0,
                  height: 34.0,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child:  Image.asset('assets/images/scar2.png',color: Colors.pinkAccent),)
              ],
            ),),*/
        /*new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.alarmCount(),style: TextStyle(fontSize: 16.0),),
                Text(serviceItem.AlarmCount!=null ? DartHelper.isNullOrEmptyString(serviceItem.AlarmCount.toString()) : '',style: TextStyle(fontSize: 16.0))
              ],
            ),),*/
            new Padding(padding: EdgeInsets.only(right: 5.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
              alignment: Alignment.center,
                decoration: new BoxDecoration(
                 // color: Colors.indigo,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                ),
                child:
                  FlatButton(
                    child:
                    Button(title: Translations.current.edit(),color: Colors.pinkAccent.value,wid: wid,),
                    onPressed: (){ deleteService(serviceItem,context,true); },
                  ),),
              Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                //  color: Colors.indigo,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                ),
                child:
                  FlatButton(
                    child:
                  Button(title: Translations.current.delete(),color: Colors.pinkAccent.value,wid: wid,),
                    onPressed: (){ deleteService(serviceItem,context,false); },
                  ),),
                  Container(
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                     // color: Colors.indigo,
                      borderRadius: new BorderRadius.all(
                          new Radius.circular(5.0)),
                    ),
                    child:
                    FlatButton(
                      child:
                      Button(title: Translations.current.actionService(),color: Colors.pinkAccent.value,wid: wid,),
                      onPressed: () { _showBottomSheetActions(context); },
                    ),),
                ],
              ),),
          ],
        ),
       ),
      ),
    );
  }



  _showBottomSheetActions(BuildContext cntext, )
  {
    double wid=MediaQuery.of(cntext).size.width*0.60;
    showModalBottomSheetCustom(context: cntext ,
        mHeight: 0.55,
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        //color: Colors.indigo,
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(5.0)),
                      ),
                      child:
                      FlatButton(
                        child:
                        Button(title: Translations.current.done(),color: Colors.pinkAccent.value,wid: wid,),
                        onPressed: (){
                          Navigator.pop(context);
                          _onUpdateService(serviceItem,context,false,Constants.SERVICE_DONE);
                        },
                      ),),
                    ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                       // color: Colors.indigo,
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(5.0)),
                      ),
                      child:
                      FlatButton(
                        child:
                        Button(title: Translations.current.notDone(),color: Colors.pinkAccent.value,wid: wid,),
                        onPressed: (){
                          Navigator.pop(context);
                          _onUpdateService(serviceItem,context,false,Constants.SERVICE_NOTDONE); },
                      ),),],),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                       // color: Colors.indigo,
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(5.0)),
                      ),
                      child:
                      FlatButton(
                        child:
                        Button(title: Translations.current.cancel(),color: Colors.pinkAccent.value,wid: wid,),
                        onPressed: (){ _onUpdateService(serviceItem,context,false,Constants.SERVICE_CANCEL); },
                      ),),],),
                  ],
          );
        });
  }
}
