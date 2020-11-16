import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/ui/screen/adora_car_status_setting/bloc/car_status_setting_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CarIconsStatus { edit, done }

class CarStatusSettingScreen extends StatefulWidget {
  final CarIconsStatus status;
  final Color currentColorRow;
  final String cioBinary;
  const CarStatusSettingScreen(
      {@required this.status,
      this.currentColorRow = Colors.amberAccent,
      this.cioBinary = "0000000"});

  const CarStatusSettingScreen.done({
    @required this.status,
    @required this.currentColorRow,
    @required this.cioBinary,
  });
  @override
  _CarStatusSettingScreenState createState() => _CarStatusSettingScreenState();
}

class _CarStatusSettingScreenState extends State<CarStatusSettingScreen> {
  CarStatusSettingBloc bloc;
  @override
  void initState() {
    bloc = CarStatusSettingBloc()..add(LoadCarStatusInitial());
    super.initState();
  }

  @override
  void didUpdateWidget(CarStatusSettingScreen oldWidget) {
    bloc.add(LoadCarStatusInitial());
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.status == CarIconsStatus.edit
            ? AppBar(
                elevation: 0,
                title: Text(
                  "انتخاب وضعیت خودرو",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                centerTitle: true,
                leading: BackButton(color: Colors.indigoAccent),
              )
            : null,
        body: BlocBuilder<CarStatusSettingBloc, CarStatusSettingState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is CarStatusSettingLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CarStatusSettingLoaded) {
              if (widget.status == CarIconsStatus.edit) {
                return _gridIconsModle(state.models);
              } else {
                return _selectedCarStatus(state.models);
              }
            }
            return Container(
              color: Colors.green,
            );
          },
        ));
  }

  Widget _gridIconsModle(List<CarSelectedStatusIconModel> iconsModel) {
    return Center(
      child: Container(
        // width: 250,
        // height: 300,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          // image: DecorationImage(
          //     image: AssetImage("assets/images/car.png"),
          //     fit: BoxFit.cover,
          //     alignment: Alignment.topCenter),
        ),
        child: Center(
          child: GridView.builder(
            itemCount: iconsModel.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 50,
              mainAxisSpacing: 0.1,
            ),
            itemBuilder: (ctx, index) => Container(
              width: 60,
              height: 60,
              child: CheckboxListTile(
                  title: Image.asset(iconsModel[index].iconAdress),
                  value: iconsModel[index].selected,
                  onChanged: (newValue) {
                    bloc.add(CarstatusIconSelectedextends(iconsModel[index]));
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedCarStatus(List<CarSelectedStatusIconModel> iconsModel) {
    final double i_h = 64;
    final double i_w = 64;

    return CenterRepository.APP_TYPE_ADORA ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        iconsModel[0].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.center,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[0] == "0"
                    ? Image.asset(
                        iconsModel[0].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[0].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[1].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.center,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[1] == "0"
                    ? Image.asset(
                        iconsModel[1].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[1].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[2].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.center,
                height: i_h,
                width: i_w,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 48.0,
                  child: widget.cioBinary[2] == "0"
                      ? Image.asset(
                          iconsModel[2].iconAdress,
                          fit: BoxFit.cover,
                          color: widget.currentColorRow.withOpacity(0.5),
                        )
                      : ImageNeonGlow(
                          imageUrl: iconsModel[2].iconAdress,
                          counter: 0,
                          color: widget.currentColorRow,
                        ),
                ),
              )
            : Container(),
        iconsModel[3].selected
            ? Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[3] == "0"
                    ? Image.asset(
                        iconsModel[3].iconAdress,
                        scale: 1.5,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[3].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[4].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[4] == "0"
                    ? Image.asset(
                        iconsModel[4].iconAdress,
                        scale: 1.5,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[4].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[5].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[5] == "0"
                    ? Image.asset(
                        iconsModel[5].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[5].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[6].selected
            ? Container(
                //color: Colors.white,
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[6] == "0"
                    ? Image.asset(
                        iconsModel[6].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[6].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[7].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[7] == "0"
                    ? Image.asset(
                        iconsModel[7].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[7].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
      ],
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        iconsModel[0].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.center,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[0] == "0"
                    ? Image.asset(
                        iconsModel[0].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[0].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[1].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.center,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[1] == "0"
                    ? Image.asset(
                        iconsModel[1].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[1].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[2].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.center,
                height: i_h,
                width: i_w,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 48.0,
                  child: widget.cioBinary[2] == "0"
                      ? Image.asset(
                          iconsModel[2].iconAdress,
                          fit: BoxFit.cover,
                          color: widget.currentColorRow.withOpacity(0.5),
                        )
                      : ImageNeonGlow(
                          imageUrl: iconsModel[2].iconAdress,
                          counter: 0,
                          color: widget.currentColorRow,
                        ),
                ),
              )
            : Container(),
        iconsModel[3].selected
            ? Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[3] == "0"
                    ? Image.asset(
                        iconsModel[3].iconAdress,
                        scale: 1.5,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[3].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[4].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[4] == "0"
                    ? Image.asset(
                        iconsModel[4].iconAdress,
                        scale: 1.5,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[4].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[5].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[5] == "0"
                    ? Image.asset(
                        iconsModel[5].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[5].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[6].selected
            ? Container(
                //color: Colors.white,
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[6] == "0"
                    ? Image.asset(
                        iconsModel[6].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[6].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
        iconsModel[7].selected
            ? Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                alignment: Alignment.topCenter,
                height: i_h,
                width: i_w,
                child: widget.cioBinary[7] == "0"
                    ? Image.asset(
                        iconsModel[7].iconAdress,
                        fit: BoxFit.cover,
                        color: widget.currentColorRow.withOpacity(0.5),
                      )
                    : ImageNeonGlow(
                        imageUrl: iconsModel[7].iconAdress,
                        counter: 0,
                        color: widget.currentColorRow,
                      ),
              )
            : Container(),
      ],
    );
  }
}
