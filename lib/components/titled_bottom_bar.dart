import 'package:flutter/material.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titled Bar',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Item> items = [
    Item('Home', Icons.home),
    Item('Search', Icons.search),
    Item('Bag', Icons.card_travel),
    Item('Orders', Icons.shopping_cart),
    Item('Profile', Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Titled Bottom Bar"),
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
        items: items,
      ),
    );
  }
}


class TitledBottomNavigationBar extends StatefulWidget {
  final List<Item> items;

  const TitledBottomNavigationBar({Key key, this.items}) : super(key: key);

  @override
  _TitledBottomNavigationBarState createState() => _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState
    extends State<TitledBottomNavigationBar>
    with SingleTickerProviderStateMixin{

  List<Item> get items => widget.items;
  int selectedIndex = 0;
  static const double BAR_HEIGHT = 60;
  static const double INDICATOR_HEIGHT = 2;
  static const double INDICATOR_WIDTH = 10;
  double width = 0;
  double indicatorAlignX = 0;

  Duration duration = Duration(milliseconds: 270);

  @override
  void initState() {
    // select a default item
    _select(selectedIndex);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      height: BAR_HEIGHT,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10
            )
          ]
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: INDICATOR_HEIGHT,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item){
                var index = items.indexOf(item);
                return GestureDetector(
                  onTap: ()=> setState((){
                    _select(index);
                  }),

                  child: _buildItemWidget(item, index == selectedIndex),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: width,
            child: AnimatedAlign(
              alignment: Alignment(indicatorAlignX, 0),
              curve: Curves.linear,
              duration: duration,
              child: Container(
                color: Colors.black,
                width: width/items.length,
                height: INDICATOR_HEIGHT,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _select(int index) {
    selectedIndex = index;
    indicatorAlignX = -1 + (2 / (items.length - 1) * index);
  }

  Widget _buildItemWidget(Item item, bool isSelected){
    return Container(
      color: Colors.white,
      height: BAR_HEIGHT,
      width: width / items.length,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: isSelected ? 0.0 : 1.0,
            duration: duration,
            curve: Curves.linear,
            child: Text(item.title),
          ),
          AnimatedAlign(
            duration: duration,
            alignment: isSelected ? Alignment.center : Alignment(0, 2.6),
            child: Icon(item.icon),
          ),
        ],
      ),
    );
  }
}

class Item{
  final String title;
  final IconData icon;

  Item(this.title, this.icon);
}