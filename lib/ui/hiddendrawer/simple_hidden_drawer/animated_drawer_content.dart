import 'package:flutter/material.dart';
import 'package:anad_magicar/ui/hiddendrawer/controllers/hidden_drawer_controller.dart';

class AnimatedDrawerContent extends StatefulWidget {
  final HiddenDrawerController controller;
  final Widget child;
  final bool isDraggable;
  final double slidePercent;
  final double verticalScalePercent;
  final double contentCornerRadius;
  final bool whithPaddingTop;
  final bool whithShadow;
  final bool enableScaleAnimin;
  final bool enableCornerAnimin;

  const AnimatedDrawerContent(
      {Key key,
      this.controller,
      this.child,
      this.isDraggable = true,
      this.slidePercent,
      this.verticalScalePercent,
      this.contentCornerRadius,
      this.whithPaddingTop = false,
        this.whithShadow = true,
        this.enableScaleAnimin = true,
        this.enableCornerAnimin = true})
      : assert(controller != null),
        super(key: key);

  @override
  _AnimatedDrawerContentState createState() => _AnimatedDrawerContentState();
}

class _AnimatedDrawerContentState extends State<AnimatedDrawerContent> {

  static const double WIDTH_GESTURE = 30.0;
  static const double HEIGHT_APPBAR = 80.0;
  static const double BLUR_SHADOW = 20.0;
  RenderBox _box;
  double width = 0;
  double height = 0;
  double slideAmount = 0.0;
  double contentScale = 1.0;
  double cornerRadius = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_,child){

        var animatePercent = widget.controller.value;
        slideAmount = ((-1*(width-100))/100*widget.slidePercent) * animatePercent;

        if(widget.enableScaleAnimin)
        contentScale = 1.0 - (((100 - widget.verticalScalePercent)/100) * animatePercent);

        if(widget.enableCornerAnimin)
        cornerRadius = widget.contentCornerRadius * animatePercent;

        return Transform(
          transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
            ..scale(contentScale, contentScale),
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: new BoxDecoration(
              boxShadow: _getShadow(),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(cornerRadius),
                child: child),
          ),
        );

      },
      child: _buildContet(),
    );
  }

  _buildContet() {
    return Stack(
      children: <Widget>[
        widget.child,
        Container(
          margin: EdgeInsets.only(top: (widget.whithPaddingTop ? HEIGHT_APPBAR : 0)),
          child: GestureDetector(
            onHorizontalDragUpdate: (detail) {
              if (widget.isDraggable) {
                var left = _box.globalToLocal(Offset(0.0,0.0)).dx;
                var globalPosition = detail.globalPosition.dx + left;
                if (globalPosition < 0) {
                  globalPosition = 0;
                }
                double position = globalPosition / (MediaQuery.of(context).size.width+left);
                widget.controller.move(position);
              }
            },
            onHorizontalDragEnd: (detail) {
              widget.controller.openOrClose();
            },
            child: Container(
              height: height,
              color: Colors.transparent,
              width: WIDTH_GESTURE,
            ),
          ),
        )
      ],
    );
  }

  List<BoxShadow>_getShadow() {
    if(widget.whithShadow) {
      return [
        new BoxShadow(
        color: const Color(0x44000000),
        offset: const Offset(0.0, 5.0),
        blurRadius: BLUR_SHADOW,
        spreadRadius: 5.0,
      ),
      ];
    }else{
      return [];
    }
  }

  void _afterLayout(Duration timeStamp) {
    setState(() {
      _box = context.findRenderObject();
      width = _box.size.width;
      height = _box.size.height;
    });
  }
}
