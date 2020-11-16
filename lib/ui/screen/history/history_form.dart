import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/model/apis/car_action_log.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/history/history_form_item.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:flutter/material.dart';

class HistoryForm extends StatefulWidget {

  int carId;
  NotyBloc<ChangeEvent> notyDateFilterBloc;
  HistoryForm({Key key,this.carId,this.notyDateFilterBloc}) : super(key: key);

  @override
  HistoryFormState createState() {
    return HistoryFormState();
  }
}

class HistoryFormState extends State<HistoryForm> {


  String fromDate='';
  String toDate='';

  Future<List<CarActionLog>> fcarActionLogs;
  List<CarActionLog> carActionLogs = new List();

  Future<List<CarActionLog>> getCarActionLog(String fromDate,
      String toDate) async {
    centerRepository.showProgressDialog(context, Translations.current.loadingdata());
    var result = await restDatasource.GetCarLog(widget.carId,DateTimeUtils.convertIntoDate( fromDate), DateTimeUtils.convertIntoDate(toDate));
    if (result != null) {
      centerRepository.dismissDialog(context);
      return result;
    }
    else{
      centerRepository.dismissDialog(context);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    var nowDate=Jalali.now();

    fromDate= DateTimeUtils.getDateJalali();
    toDate=DateTimeUtils.getDateJalali();
    fcarActionLogs=getCarActionLog(fromDate, toDate);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<ChangeEvent>(
      initialData: new ChangeEvent(
          fromDate:DateTimeUtils.getDateJalali(),
          toDate: DateTimeUtils.getDateJalali()),
      stream: widget.notyDateFilterBloc.noty ,
      builder: (context,snapshot) {
      if(snapshot.hasData && snapshot.data!=null) {
        return FutureBuilder<List<CarActionLog>>(
          future: fcarActionLogs,
          builder: (context, snapshot) {

            if (snapshot.hasData &&
                snapshot.data != null) {
              carActionLogs = snapshot.data;
              return Material(
                color: Color(0xfffefefe),
                child: new Card(
                  margin: new EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 4.0,
                  child:
                  new Container(
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      color: Color(0xfffefefe),
                      borderRadius: new BorderRadius.all(
                          new Radius.circular(5.0)),
                    ),
                    child:
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: carActionLogs.length,
                        itemBuilder: (context, index) {
                          return
                            HistoryItem(carActionLog: carActionLogs[index]);
                        }
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }
      else
        {
          //fcarActionLogs=getCarActionLog(fromDate, toDate)
          return Container();
        }
    },
    );
  }
}
