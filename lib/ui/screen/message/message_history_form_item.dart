import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/car_action_log.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/utils/dart_helper.dart';

class MessageHistoryItem extends StatelessWidget {

  CarActionLog carActionLog;

  MessageHistoryItem({Key key, this.carActionLog}) : super(key: key);
  String iconURL='assets/images/action.png';

  @override
  Widget build(BuildContext context) {

    if(carActionLog.ActionId!=null)
       iconURL=ActionsCommand.getActionIconURL(carActionLog.ActionId);
    else
      iconURL='assets/images/action.png';
    if(iconURL==null || iconURL.isEmpty){
      iconURL='assets/images/action.png';
    }
    return new Card(
      margin: new EdgeInsets.only(
          left: 5.0, right: 5.0, top: 2.0, bottom: 5.0),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black54, width: 0.0),
          borderRadius: BorderRadius.circular(8.0)),
      elevation: 0.0,
      child:
      new Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: Color(0xffe0e0e0),
          borderRadius: new BorderRadius.all(
              new Radius.circular(5.0)),
        ),
        child:
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
        new Padding(padding: EdgeInsets.only(right: 10.0,left: 10.0,),
        child:
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
        Text(Translations.current.actionUsername()),
              Text(DartHelper.isNullOrEmptyString( carActionLog.UserName))
            ],),),
            new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(Translations.current.messageTitle(),
                    style: TextStyle(fontSize: 16.0),),
                  new Padding(padding: EdgeInsets.only(right: 10.0, left: 5.0),
                    child: Text(carActionLog.ActionTitle,
                      style: TextStyle(fontSize: 16.0),
                      overflow: TextOverflow.fade, softWrap: true,),),
                  new Padding(padding: EdgeInsets.only(right: 10.0, left: 20.0),
                    child: Container(
                      width: 34.0,
                      height: 34.0,
                      child:
                      Image.asset(iconURL,
                        color: Colors.pinkAccent,),),),

                ],
              ),
            ),
            /*new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    carActionLog.PlanTitle, style: TextStyle(fontSize: 16.0),)
                ],
              ),),*/
            new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              new Row(children: <Widget>[
              ],
              ),),
            new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(right: 10.0, left: 20.0),
                    child:
                    Text(carActionLog.ActionDate,
                      style: TextStyle(fontSize: 16.0),),),
                  // Text(carActionLogs[index].ActionTitle,style: TextStyle(fontSize: 14.0),)

                ],
              ),),
          ],
        ),
      ),
    );
  }
}

