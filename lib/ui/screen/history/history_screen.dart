import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/history/history_form.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/components/date_picker/flutter_datetime_picker.dart' as dtpicker;

class HistoryScreen extends StatefulWidget {

  int carId;
  GlobalKey<ScaffoldState> scaffoldKey;
  HistoryScreen({Key key,this.carId,this.scaffoldKey}) : super(key: key);

  @override
  HistoryScreenState createState() {
    return HistoryScreenState();
  }
}

class HistoryScreenState extends MainPage<HistoryScreen> {

  String route='/history';
  String fromDate='';
  String toDate='';

  NotyBloc<ChangeEvent> notyDateFilterBloc;

  _showBottomSheetPlans(BuildContext cntext)
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[


            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                FlatButton(
                  child: Button(wid: 40.0,color: Colors.indigoAccent.value,title: Translations.current.fromDate(),),
                  onPressed: (){
                    showFilterDate(true);
                  },
                ),
              FlatButton(
                child: Button(wid: 40.0,color: Colors.indigoAccent.value,title: Translations.current.fromDate(),),
                onPressed: (){
                  showFilterDate(false);
                },
              )
            ],
          ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Button(wid: 40.0,color: Colors.indigoAccent.value,title: Translations.current.doFilter(),),
                    onPressed: () {
                      notyDateFilterBloc.updateValue(new ChangeEvent(fromDate: fromDate,toDate: toDate));
                      Navigator.pop(context);

                    },
                  )
                ],
              )
            ],
          );

        });
  }
  showFilterDate(bool from) {

    var nowDate=Jalali.now();
    dtpicker.DatePicker.showDatePicker(context,
        theme: dtpicker.DatePickerTheme(
            cancelStyle:  TextStyle(fontFamily: 'IranSans',fontSize: 28.0,color: Colors.pinkAccent),
            itemStyle: TextStyle(fontFamily: 'IranSans',fontSize: 20.0),
            doneStyle: TextStyle(fontFamily: 'IranSans',fontSize: 28.0,color: Colors.green)
        ),
        showTitleActions: true,
        minTime: DateTime(1397, 1, 1),
        maxTime: DateTime(1410, 1, 1),
        onChanged: (date) {
          //print('change $date');
        }, onConfirm: (date) {
          //print('confirm $date');
          from ? fromDate=date.year.toString()+'/'+date.month.toString()+'/'+date.day.toString() :
              toDate=date.year.toString()+'/'+date.month.toString()+'/'+date.day.toString();

        }, currentTime: Jalali.now().toDateTime(), locale: dtpicker.LocaleType.fa);
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return route;
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return null;
  }

  @override
  getScafoldState(int action) {
    // TODO: implement getScafoldState
    if(action==1)
      widget.scaffoldKey.currentState.openDrawer();
    return null;
  }

  @override
  initialize() {
    // TODO: implement initialize
    scaffoldKey=widget.scaffoldKey;
    notyDateFilterBloc=new NotyBloc<ChangeEvent>();
    return null;
  }


  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return HistoryForm(carId: widget.carId,);
  }
  @override
  bool doBack() {
    // TODO: implement doBack
    return false;
  }

  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    List<Widget> actions=[

      IconButton(
        icon: Icon(Icons.date_range,color: Colors.indigoAccent,),
        onPressed: (){
          _showBottomSheetPlans(context);
        },
      ),
      Text('تاریخچه فرامین',style: TextStyle(fontSize: 15,color: Colors.white),),
    ];
    return actions;
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 2;
  }

  @override
  onBack() {
    // TODO: implement onBack
    return null;
  }

  @override
  bool showBack() {
    // TODO: implement showBack
    return true;
  }
  @override
  bool showMenu() {
    // TODO: implement showMenu
    return false;
  }
  @override
  Widget getTitle() {
    // TODO: implement getTitle
    return null;
  }
}
