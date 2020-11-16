
part of extended_navbar_scaffold;
class ParallaxCardItem {
  ParallaxCardItem({
    this.title,
    this.body,
    this.background,
    this.data,
    this.backColor,
  });

  final String title;
  final String body;
  final Widget background;
  final Color backColor;
  final dynamic data;
}

class ParallaxCardsWidget extends StatelessWidget {
  ParallaxCardsWidget({
    @required this.item,
    @required this.pageVisibility,
  });

  final ParallaxCardItem item;
  final PageVisibility pageVisibility;

//   @override
//   _ParallaxCardsWidgetState createState() => _ParallaxCardsWidgetState();
// }

// class _ParallaxCardsWidgetState extends State<ParallaxCardsWidget> {

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    var categoryText = _applyTextEffects(
      translationFactor: 50.0,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Text(
          item.body,
          style: ktitleStyle.copyWith(
            color: Colors.black,
            // fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    var titleText = _applyTextEffects(
      translationFactor: 40.0,
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: Text(
          item.title,
          style: ksubtitleStyle.copyWith(
            color: Colors.black,
            // fontWeight: FontWeight.w700,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    return Positioned(
      // top: 5,
      bottom: 5.0,
      left: 10.0,
      // right: 10.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          categoryText,
          titleText,
        ],
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            // Colors.transparent,
            // Colors.black12,
            // Colors.black26,
            // Colors.black38,
            Colors.transparent,
            // Colors.black,
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 5.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.blueAccent,width: 2.0)
        ),
       // width: 50.0,
      child:
      ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          shadowColor:  item.backColor!=null ? item.backColor : Colors.white,
          elevation: 10,
          color: item.backColor!=null ? item.backColor : Colors.white.withOpacity(1.0),
          type: MaterialType.card,
          child:Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            fit: StackFit.expand,
            children: [
              Positioned(
               right: 0.0,

              child:
                  item.background,
              ),
                  // centerMarker,
                  imageOverlayGradient,
                  _buildTextContainer(context),

            ],
          ),

        ),
      ),
      ),
    );
  }
}
