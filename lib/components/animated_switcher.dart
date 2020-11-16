import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';

class AnimatedSwitcherDeivao extends StatefulWidget {
  final PageController controller;
  final List<String> pageTitle;
  const AnimatedSwitcherDeivao({Key key, this.controller,this.pageTitle}) : super(key: key);
  @override
  _AnimatedSwitcherDeivaoState createState() => _AnimatedSwitcherDeivaoState();
}

class _AnimatedSwitcherDeivaoState extends State<AnimatedSwitcherDeivao> {
  double _width = 0;
  bool isRTL;
  void getWidth() {
    var width = (context.findRenderObject() as RenderBox)?.size?.width;
    if (_width == 0 && width == null)
      Future.delayed(Duration(milliseconds: 500), getWidth);
    else if(width != null)
      setState(() {
        _width = width;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWidth();
    isRTL=centerRepository.getCachedLangCode()=='fa' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.controller.page == 0) {
         // RxBus.post(new ChangeEvent(amount: 1,message: 'LOGIN_CHANGED',type: 'REGISTER'));
          widget.controller.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );

        }
        else {
          //RxBus.post(new ChangeEvent(amount: 0,message: 'LOGIN_CHANGED',type: 'LOGIN'));
          widget.controller.previousPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );

        }
      },
      onHorizontalDragUpdate: (val) {
        widget.controller.jumpTo(
          (widget.controller.page *
              widget.controller.position.maxScrollExtent) +
              val.primaryDelta * 2,
        );
      },
      onHorizontalDragEnd: (val) {},
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(25),
        ),
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, snapshot) {
            if (_width == 0 || widget.controller.positions.isEmpty)
              return Container();

            var page = widget.controller?.page ?? 0;
            return Stack(
              children: <Widget>[
                Transform.translate(
                  child: _buildButton(context),
                  offset:
                  Offset(widget.controller.page * ((isRTL ? (-_width / 2) : (_width / 2)) - 5), 0),
                ),
                Container(
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          Translations.current.login(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.lerp(Colors.black, Colors.white, page),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Translations.current.register(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.lerp(Colors.white, Colors.black, page),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      width: _width / 2 ,
    );
  }
}
