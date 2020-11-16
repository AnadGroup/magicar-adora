import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/car_action_log.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatefulWidget {

  CarActionLog carActionLog;
  HistoryItem({Key key,this.carActionLog}) : super(key: key);

  @override
  _HistoryItemState createState() {
    return _HistoryItemState();
  }
}

class _HistoryItemState extends State<HistoryItem> {


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
    return
          new Column(
          children: <Widget>[
          new Row(
          children: <Widget>[
            Text(widget.carActionLog.ActionTitle,style: TextStyle(fontSize: 14.0),)
          ],
          ),
          new Row(children: <Widget>[
            Text(widget.carActionLog.PlanTitle,style: TextStyle(fontSize: 14.0),)
          ],
          ),
          new Row(children: <Widget>[
          ],
          ),
          new Row(children: <Widget>[
            Text(widget.carActionLog.ActionDate,style: TextStyle(fontSize: 14.0),),
           // Text(carActionLogs[index].ActionTitle,style: TextStyle(fontSize: 14.0),)
          ],
          ),
          ],
          );

  }
}
