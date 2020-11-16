import 'package:flutter/material.dart';

class MyMaterialButton extends StatelessWidget {

  String title;
  String closeTitle;
  bool isCancel=false;
  VoidCallback onTap;

  MyMaterialButton({Key key, this.title, this.closeTitle, this.onTap,this.isCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(
        builder: (context) {
          return MaterialButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: this.isCancel!=null && this.isCancel ? Colors.redAccent :  Colors.blueAccent,
              child: Text(this.title,style: TextStyle(color: this.isCancel!=null && this.isCancel ? Colors.white : Colors.white),),
              onPressed: () async {
                Navigator.pop(context);
               if(this.onTap!=null) this.onTap();

              }
          );
        });
  }
}
