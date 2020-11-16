
import 'package:flutter/material.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/widgets/drawer/circular_image.dart';

class MenuScreen extends StatelessWidget{

  final String imageUrl = "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg";

  final int registerId=0;
  final int helpId=10;
  final int searchId=20;
  final int shopId=30;
  final int basketId=40;
  final int myProgramsId=50;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 62, left: MediaQuery.of(context).size.width/2.9,bottom: 8,
          right: 32),
      color: Color(0xff454dff),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircularImage(
                  NetworkImage(imageUrl),
                ),
              ),
              Text(Translations.of(context).userName(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Spacer(),
          Column(
            children: createMenuList(context).map((item) {
              return ListTile(
                onTap: (){
                  if(item.id==registerId)
                    {
                      Navigator.pushReplacementNamed(context, '/register');
                    }
                  else if(item.id==myProgramsId)
                    {
                      Navigator.pushReplacementNamed(context, '/myprograms');
                    }
                },
                leading: Icon(item.icon, color: Colors.white, size: 20,),
                title: Text(item.title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              );
            }).toList(),
          ),

          Spacer(),

          ListTile(
            onTap: (){},
            leading: Icon(Icons.settings, color: Colors.white, size: 20,),
            title: Text(Translations.of(context).settings(),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white
                )),),
          ListTile(
            leading: Icon(Icons.headset_mic, color: Colors.white, size: 20,),
            title: Text(Translations.of(context).support(),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white
                )),),
        ],
      ),
    );
  }

  List<MenuItem> createMenuList(BuildContext context){
    final List<MenuItem> options = [
      MenuItem(Icons.person_add, Translations.of(context).register(),context,registerId),
      MenuItem(Icons.search, Translations.of(context).search(),context,searchId),
      MenuItem(Icons.shopping_basket, Translations.of(context).basket(),context,basketId),
      //MenuItem(Icons.transfer_within_a_station, Translations.of(context).coach(),context,-1),
      //MenuItem(Icons.list, Translations.of(context).myPrograms(),context,myProgramsId),
      MenuItem(Icons.help, Translations.of(context).help(),context,helpId),

    ];
    return options;
  }
}


class MenuItem{
  int id;
  String title;
  IconData icon;
  BuildContext context;
  MenuItem(this.icon, this.title,this.context,this.id);

}
