import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {

  bool noCarCount;
  Image backImage;
  NoDataWidget({Key key,this.noCarCount,this.backImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(padding: EdgeInsets.only(top: 78.0),
        child:
      Card(
      color: Color(0xfffefefe) ,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
          side: BorderSide(color: Colors.white,width: 0.5)),
      child: new Center(
        child: (noCarCount==null || !noCarCount) ?
        Container(
          width:MediaQuery.of(context).size.width * 0.70,
          height: MediaQuery.of(context).size.height * 0.50,
          child: new Center(
              child: Text(Translations.current.noDatatoShow(),style: TextStyle(fontSize: 14.0,color: Colors.pinkAccent),) ) ) :
           Column(
             children: <Widget>[
               Container(
                 width : MediaQuery.of(context).size.width * 0.70,
                 height : MediaQuery.of(context).size.height * 0.50,
           child:
               Image.asset('assets/images/car.png'),
               ),
               Text(Translations.current.noCarExist())
             ],
           ) ,
      ),
      ),
    );
  }
}
