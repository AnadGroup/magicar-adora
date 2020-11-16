import 'dart:math';

import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/flutter_form_builder/src/form_builder_custom_field.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_color.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/model/cars/car_model_detail.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/car/fancy_car/src/models/car_data.dart';
import 'package:anad_magicar/ui/screen/service/fancy_service/src/models/car_service_data.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/persian_datepicker/persian_datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'animated_button.dart';
import 'animated_text.dart';
import 'custom_page_transformer.dart';
import 'expandable_container.dart';
import 'fade_in.dart';
import 'animated_text_form_field.dart';
import '../providers/auth.dart';
import '../providers/car_service_messages.dart';
import '../dart_helper.dart';
import '../matrix.dart';
import '../paddings.dart';
import '../widget_helper.dart';
import 'package:anad_magicar/components/date_picker/flutter_datetime_picker.dart' as dtpicker;
class AuthCard extends StatefulWidget {
  AuthCard({
    Key key,
    this.padding = const EdgeInsets.all(0),
    this.loadingController,
    this.emailValidator,
    this.pelakValidator,
    this.passwordValidator,
    this.onSubmit,
    this.onSubmitCompleted,
    this.editMode,
    this.serviceModel,
    this.serviceVM
  }) : super(key: key);

  final EdgeInsets padding;
  final AnimationController loadingController;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> pelakValidator;
  final FormFieldValidator<String> passwordValidator;
  final Function onSubmit;
  final Function onSubmitCompleted;
  final bool editMode;
  final ApiService serviceModel;
  final ServiceVM serviceVM;

  @override
  AuthCardState createState() => AuthCardState();
}

class AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  GlobalKey _cardKey = GlobalKey();

  var _isLoadingFirstTime = true;
  var _pageIndex = 0;

  static const cardSizeScaleEnd = .2;

  TransformerPageController _pageController;
  AnimationController _formLoadingController;
  AnimationController _routeTransitionController;
  Animation<double> _flipAnimation;
  Animation<double> _cardSizeAnimation;
  Animation<double> _cardSize2AnimationX;
  Animation<double> _cardSize2AnimationY;
  Animation<double> _cardRotationAnimation;
  Animation<double> _cardOverlayHeightFactorAnimation;
  Animation<double> _cardOverlaySizeAndOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _pageController = TransformerPageController();

    widget.loadingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isLoadingFirstTime = false;
        _formLoadingController.forward();
      }
    });

    _flipAnimation = Tween<double>(begin: pi / 2, end: 0).animate(
      CurvedAnimation(
        parent: widget.loadingController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );

    _formLoadingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1150),
      reverseDuration: Duration(milliseconds: 300),
    );

    _routeTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );

    _cardSizeAnimation = Tween<double>(begin: 1.0, end: cardSizeScaleEnd)
        .animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(0, .27272727 /* ~300ms */, curve: Curves.easeInOutCirc),
    ));
    _cardOverlayHeightFactorAnimation =
        Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.27272727, .5 /* ~250ms */, curve: Curves.linear),
    ));
    _cardOverlaySizeAndOpacityAnimation =
        Tween<double>(begin: 1.0, end: 0).animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.5, .72727272 /* ~250ms */, curve: Curves.linear),
    ));
    _cardSize2AnimationX =
        Tween<double>(begin: 1, end: 1).animate(_routeTransitionController);
    _cardSize2AnimationY =
        Tween<double>(begin: 1, end: 1).animate(_routeTransitionController);
    _cardRotationAnimation =
        Tween<double>(begin: 0, end: pi / 2).animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.72727272, 1 /* ~300ms */, curve: Curves.easeInOutCubic),
    ));
  }

  @override
  void dispose() {


    _formLoadingController.dispose();
    _pageController.dispose();
    _routeTransitionController.dispose();
    super.dispose();
  }

  void _switchRecovery(bool recovery) {
    final auth = Provider.of<Auth>(context, listen: false);

    auth.isRecover = recovery;
    if (recovery) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      _pageIndex = 1;
    } else {
      _pageController.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      _pageIndex = 0;
    }
  }

  Future<void> runLoadingAnimation() {
    if (widget.loadingController.isDismissed) {
      return widget.loadingController.forward().then((_) {
        if (!_isLoadingFirstTime) {
          _formLoadingController.forward();
        }
      });
    } else if (widget.loadingController.isCompleted) {
      return _formLoadingController
          .reverse()
          .then((_) => widget.loadingController.reverse());
    }
    return Future(null);
  }

  Future<void> _forwardChangeRouteAnimation() {
    final isConfirm = Provider.of<Auth>(context, listen: false).isConfirm;
    final deviceSize = MediaQuery.of(context).size;
    final cardSize = getWidgetSize(_cardKey);
    // add .25 to make sure the scaling will cover the whole screen
    final widthRatio =
        deviceSize.width / cardSize.height + (isConfirm ? .25 : .65);
    final heightRatio = deviceSize.height / cardSize.width + .25;

    _cardSize2AnimationX =
        Tween<double>(begin: 1.0, end: heightRatio / cardSizeScaleEnd)
            .animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.72727272, 1, curve: Curves.easeInOutCubic),
    ));
    _cardSize2AnimationY =
        Tween<double>(begin: 1.0, end: widthRatio / cardSizeScaleEnd)
            .animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.72727272, 1, curve: Curves.easeInOutCubic),
    ));

    widget?.onSubmit();

    return _formLoadingController
        .reverse()
        .then((_) => _routeTransitionController.forward());
  }

  void _reverseChangeRouteAnimation() {
    _routeTransitionController
        .reverse()
        .then((_) => _formLoadingController.forward());
  }

  void runChangeRouteAnimation() {
    if (_routeTransitionController.isCompleted) {
      _reverseChangeRouteAnimation();
    } else if (_routeTransitionController.isDismissed) {
      _forwardChangeRouteAnimation();
    }
  }
  int modelId=0;
  void runChangePageAnimation() {
    final auth = Provider.of<Auth>(context, listen: false);
    _switchRecovery(!auth.isRecover);
  }

  Widget _buildLoadingAnimator({Widget child, ThemeData theme}) {
    Widget card;
    Widget overlay;

    // loading at startup
    card = AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) => Transform(
        transform: Matrix.perspective()..rotateX(_flipAnimation.value),
        alignment: Alignment.center,
        child: child,
      ),
      child: child,
    );

    // change-route transition
    overlay = Padding(
      padding: theme.cardTheme.margin,
      child: AnimatedBuilder(
        animation: _cardOverlayHeightFactorAnimation,
        builder: (context, child) => ClipPath.shape(
          shape: theme.cardTheme.shape,
          child: FractionallySizedBox(
            heightFactor: _cardOverlayHeightFactorAnimation.value,
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: theme.accentColor),
        ),
      ),
    );

    overlay = ScaleTransition(
      scale: _cardOverlaySizeAndOpacityAnimation,
      child: FadeTransition(
        opacity: _cardOverlaySizeAndOpacityAnimation,
        child: overlay,
      ),
    );

    return Stack(
      children: <Widget>[
        card,
        Positioned.fill(child: overlay),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    Widget current = Container(
      height: deviceSize.height,
      width: deviceSize.width,
      padding: widget.padding,
      child: TransformerPageView(
        physics: NeverScrollableScrollPhysics(),
        pageController: _pageController,
        itemCount: 2,

        /// Need to keep track of page index because soft keyboard will
        /// make page view rebuilt
        index: _pageIndex,
        transformer: CustomPageTransformer(),
        itemBuilder: (BuildContext context, int index) {
          final child = (index == 0)
              ? _buildLoadingAnimator(
                  theme: theme,
                  child: _CarCard(
                    editMode: widget.editMode,
                    service: widget.serviceModel,
                    serviceVM: widget.serviceVM,
                    key: _cardKey,
                    loadingController: _isLoadingFirstTime
                        ? _formLoadingController
                        : (_formLoadingController..value = 1.0),
                    emailValidator: widget.emailValidator,
                    pelakValidator: widget.pelakValidator,
                    passwordValidator: widget.passwordValidator,
                    onSwitchRecoveryPassword: () => _switchRecovery(true),
                    onSubmitCompleted: () {
                      _forwardChangeRouteAnimation().then((_) {
                        widget.onSubmitCompleted();
                      });
                    },
                  ),
                )
              : _RecoverCard(
                  emailValidator: widget.emailValidator,
                  onSwitchLogin: () => _switchRecovery(false),
                );

          return Align(
            alignment: Alignment.topCenter,
            child: child,
          );
        },
      ),
    );

    return AnimatedBuilder(
      animation: _cardSize2AnimationX,
      builder: (context, snapshot) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(_cardRotationAnimation.value)
            ..scale(_cardSizeAnimation.value, _cardSizeAnimation.value)
            ..scale(_cardSize2AnimationX.value, _cardSize2AnimationY.value),
          child: current,
        );
      },
    );
  }
}

class _CarCard extends StatefulWidget {
  _CarCard({
    Key key,
    this.loadingController,
    @required this.emailValidator,
    @required this.mobileValidator,
    @required this.pelakValidator,
    @required this.passwordValidator,
    @required this.onSwitchRecoveryPassword,
    this.onSwitchAuth,
    this.onSubmitCompleted,
    this.editMode,
    this.service,
    this.serviceVM,
  }) : super(key: key);

  final AnimationController loadingController;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> mobileValidator;
  final FormFieldValidator<String> pelakValidator;
  //final FormFieldValidator<String> emailValidator;

  final FormFieldValidator<String> passwordValidator;
  final Function onSwitchRecoveryPassword;
  final Function onSwitchAuth;
  final Function onSubmitCompleted;
  final bool editMode;
  ApiService service;
  ServiceVM serviceVM;

  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<_CarCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordFocusNode = FocusNode();
  final _distanceFocusNode = FocusNode();
  final _serviceDateFocusNode = FocusNode();
  final _actionDateFocusNode = FocusNode();
  final _alarmDateFocusNode = FocusNode();
  final _alarmCountFocusNode = FocusNode();
  final _serviceCostFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();

  var _authData = {'serviceId':'', 'serviceDate': '', 'alarmDate': '','actionDate': '', 'serviceCost': '','distance': '','alarmCount':'', 'serviceTypeId':'','cancel':'','description':''};
  var _isLoading = false;
  var _isSubmitting = false;
  var _showShadow = true;
  bool editMode=false;
  var maskPelakFormatter = new MaskTextInputFormatter(mask: '##@###(##)', filter: { "@" : RegExp(r'[A-Za-z]') ,"#": RegExp(r'[0-9]'),});

  static var translator = {
    '#': new RegExp(r'[\d]+$'),
    '@': new RegExp(r'[\S]+$')
  };

  var controller1 = new MaskedTextController(mask: '0000/00/00', /*translator: translator*/);
  var controller2 = new MaskedTextController(mask: '0000/00/00', /*translator: translator*/);
  var controller3 = new MaskedTextController(mask: '0000/00/00', /*translator: translator*/);
  var controller4 = new MaskedTextController(mask: '0000/00/00', /*translator: translator*/);
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();
  final TextEditingController textEditingController3 = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController alarmCountController = TextEditingController();

  final TextEditingController costController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  //final TextEditingController Controller = TextEditingController();

  PersianDatePickerWidget persianDatePicker;
  /// switch between login and signup
  AnimationController _loadingController;
  AnimationController _switchAuthController;
  AnimationController _postSwitchAuthController;
  AnimationController _submitController;

  Interval _nameTextFieldLoadingAnimationInterval;


  Interval _passTextFieldLoadingAnimationInterval;
  Interval _textButtonLoadingAnimationInterval;
  Animation<double> _buttonScaleAnimation;

  bool get buttonEnabled => !_isLoading && !_isSubmitting;
  int serviceTypeId=0;
  ServiceType _valueCarServiceType;
  List<ServiceType> serviceTypes=new List();
  String seDate;
  String actDate;
  String alarmDate;
  String serviceDate='';

  bool isDurational=false;
  bool isServiceDateEdited=false;
  bool isActionDateEdited=false;
  bool isAlarmDateEdited=false;

  initDatePicker(TextEditingController controller){
    persianDatePicker = PersianDatePicker(
      controller: controller,
      //datetime: Jalali.now().toString(),
      fontFamily: 'IranSans',
      onChange: (String oldText, String newText){
        /*controller.value=controller.value.copyWith(
          text: newText,
          selection:
          TextSelection(baseOffset: newText.length, extentOffset: newText.length),
          composing: TextRange.empty,
        );*/
      },

    ).init();
    return persianDatePicker;
  }


  String validateAlarmDate() {
    int diff=DateTimeUtils.diffDaysFromDateIsGreaterThanToDate( serviceDate,alarmDate);
    if(diff<=-1) {
        return alarmDate;
      }else {
      Jalali sj=DateTimeUtils.convertIntoDateTimeJalali(serviceDate);
      Jalali nowDate=sj.addDays(-1);
      alarmDate=DateTimeUtils.getDateJalaliThis(nowDate);
      return alarmDate;
    }
  }
  @override
  void initState() {


    serviceTypes=List.from( centerRepository.getServiceTypes());

    if(serviceTypes!=null && serviceTypes.length>0)
      {
        _valueCarServiceType=serviceTypes[0];
        if(widget.editMode!=null && widget.editMode){
          var st=serviceTypes.where((s)=>s.ServiceTypeId==widget.service.serviceType.ServiceTypeId).toList();
          if(st!=null && st.length>0){
            _valueCarServiceType=st.first;
          }
        }
      }


    //_authData['serviceTypeId']=_valueCarServiceType!=null ? _valueCarServiceType.ServiceTypeId.toString() : '0';


    _loadingController = widget.loadingController ??
        (AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1150),
          reverseDuration: Duration(milliseconds: 300),
        )..value = 1.0);

    _loadingController?.addStatusListener(handleLoadingAnimationStatus);

    _switchAuthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _postSwitchAuthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _submitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
    _passTextFieldLoadingAnimationInterval = const Interval(.15, 1.0);
    _textButtonLoadingAnimationInterval =
        const Interval(.6, 1.0, curve: Curves.easeOut);
    _buttonScaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Interval(.4, 1.0, curve: Curves.easeOutBack),
    ));



    //mobileEditingController=new TextEditingController();

    textEditingController.addListener(() {
      alarmDate=getAlarmDate();
    });


    textEditingController3.addListener(() {
      alarmDate = textEditingController3.value.text;
      alarmDate=validateAlarmDate();
      if(alarmDate!=null && alarmDate.isNotEmpty) {
        textEditingController3.value = textEditingController3.value.copyWith(
          text: alarmDate,
          selection:
          TextSelection(
              baseOffset: alarmDate.length, extentOffset: alarmDate.length),
          composing: TextRange.empty,
        );
      }
    });


    if(centerRepository.getCars()!=null) {
      var cars=centerRepository.getCars().where((element) => element.carId == widget.serviceVM.carId).toList();
      if(cars!=null && cars.isNotEmpty){
        Car car=cars.first;
        String currentDistance=(car!=null && car.totalDistance.toString()!='null') ? car.totalDistance.toString() : '0';
    distanceController.value = distanceController.value.copyWith(
    text: currentDistance,
    selection:
    TextSelection(
    baseOffset: currentDistance.length, extentOffset: currentDistance.length),
    composing: TextRange.empty,
    );

    }
    }

    if(widget.editMode!=null && widget.editMode) {
    isDurational=widget.service.serviceType.ServiceTypeConstId==Constants.SERVICE_TYPE_DURATIONALITY;

    _authData['serviceId']=widget.service.ServiceId.toString();
    var sType=serviceTypes.where((s)=>s.ServiceTypeId==widget.service.ServiceTypeId).toList();

    if(sType!=null && sType.length>0){
      _valueCarServiceType=sType.first;
    }

     serviceDate = widget.service.ServiceDate;
    if(serviceDate!=null && serviceDate.isNotEmpty && serviceDate!='null') {
      textEditingController.value = textEditingController.value.copyWith(
        text: serviceDate,
        selection:
        TextSelection(baseOffset: serviceDate.length, extentOffset: serviceDate.length),
        composing: TextRange.empty,
      );
    }
    String actDate = widget.service.ActionDate;
    if(actDate!=null && actDate.isNotEmpty && actDate!='null') {
      textEditingController2.value = textEditingController2.value.copyWith(
        text: actDate,
        selection:
        TextSelection(baseOffset: actDate.length, extentOffset: actDate.length),
        composing: TextRange.empty,
      );
    }
     alarmDate = widget.service.AlarmDate;
    if(alarmDate!=null && alarmDate.isNotEmpty && alarmDate!='null') {
      textEditingController3.value = textEditingController3.value.copyWith(
        text: alarmDate,
        selection:
        TextSelection(
            baseOffset: alarmDate.length, extentOffset: alarmDate.length),
        composing: TextRange.empty,
      );
    }
    String count=(widget.service.AlarmCount!=null && widget.service.AlarmCount.toString()!='null') ? widget.service.AlarmCount.toString() : '0';
    alarmCountController.value = alarmCountController.value.copyWith(
      text: count,
      selection:
      TextSelection(
          baseOffset: count.length, extentOffset: count.length),
      composing: TextRange.empty,
    );


    String cost=widget.service.ServiceCost==null ? '0' : widget.service.ServiceCost.toString();
    if(cost==null || cost.isEmpty || cost=='null'){
      cost='0';
    }
    costController.value = costController.value.copyWith(
      text: cost,
      selection:
      TextSelection(
          baseOffset: cost.length, extentOffset: cost.length),
      composing: TextRange.empty,
    );

    String desc=widget.service.Description==null ? '' : widget.service.Description;
    if(desc==null || desc.isEmpty || desc=='null'){
      desc='';
    }
    descriptionController.value = descriptionController.value.copyWith(
      text: desc,
      selection:
      TextSelection(
          baseOffset: desc.length, extentOffset: desc.length),
      composing: TextRange.empty,
    );


  }
    super.initState();
  }

  void handleLoadingAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.forward) {
      setState(() => _isLoading = true);
    }
    if (status == AnimationStatus.completed) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _loadingController?.removeStatusListener(handleLoadingAnimationStatus);
    _passwordFocusNode.dispose();
    _serviceCostFocusNode.dispose();
    _serviceDateFocusNode.dispose();
    _alarmCountFocusNode.dispose();
    _alarmDateFocusNode.dispose();
    _distanceFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    _switchAuthController.dispose();
    _postSwitchAuthController.dispose();
    _submitController.dispose();
  }

  void _switchAuthMode() {
    final auth = Provider.of<Auth>(context, listen: false);
    final newAuthMode = auth.switchAuth();

    if (newAuthMode == AuthMode.Cancel) {
     // _switchAuthController.forward();
     // Navigator.of(context).pushReplacementNamed('/home');
      _submit();
    } else {
      _switchAuthController.reverse();
    }
  }

  Future<bool> _submit() async {
    // a hack to force unfocus the soft keyboard. If not, after change-route
    // animation completes, it will trigger rebuilding this widget and show all
    // textfields and buttons again before going to new route
    FocusScope.of(context).requestFocus(FocusNode());

    if (!_formKey.currentState.validate()) {
      return false;
    }

    _formKey.currentState.save();
    //_submitController.forward();
    setState(() => _isSubmitting = true);
    final auth = Provider.of<Auth>(context, listen: false);
    String error;

    if (auth.isConfirm) {
      error = await auth.onConfirm( CarServiceData(
        serviceId: int.tryParse( _authData['serviceId']),
        actionDate: _authData['actionDate'],
        alarmCount: int.tryParse( _authData['alarmCount']),
        alarmDate: _authData['alarmDate'],
        cost: double.tryParse(_authData['serviceCost']),
        description: _authData['description'],
        distance:int.tryParse( _authData['distance']),
        serviceDate: _authData['serviceDate'],
        serviceTypeId:int.tryParse( _authData['serviceTypeId']),
        cancel: false,
      ));
    } else {
      error = await auth.onCancel(CarServiceData(
        serviceId: 0,
        serviceTypeId: 0,
        serviceDate: '',
        distance: 0,
        description: '',
        cost: 0,
        alarmDate: '',
        alarmCount: 0,
        actionDate: '',
        cancel: true,
      ));
    }

    // workaround to run after _cardSizeAnimation in parent finished
    // need a cleaner way but currently it works so..
    Future.delayed(const Duration(milliseconds: 270), () {
      setState(() => _showShadow = false);
    });

    //_submitController.reverse();

    if (!DartHelper.isNullOrEmpty(error)) {
      showErrorToast(context, error);
      Future.delayed(const Duration(milliseconds: 271), () {
        setState(() => _showShadow = true);
      });
      setState(() => _isSubmitting = false);
      return false;
    }

    widget?.onSubmitCompleted();

    return true;
  }


  showDatePicker(String type,TextEditingController controller){
    FocusScope.of(context).requestFocus( FocusNode()); // to prevent opening default keyboard
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return initDatePicker(controller);
        });
  }

  String getServiceDate() {
   // String serviceDate='';
    if(isDurational){
      int dv=_valueCarServiceType.DurationValue;
      if(_valueCarServiceType.DurationTypeConstId==Constants.SERVICE_DURATION_MONTH){

        Jalali sj=Jalali.now().addMonths(dv);
        serviceDate=DateTimeUtils.getDateJalaliThis(sj);
      }else if(_valueCarServiceType.DurationTypeConstId==Constants.SERVICE_DURATION_YEAR){
        Jalali sj=Jalali.now().addYears(dv);
        serviceDate=DateTimeUtils.getDateJalaliThis(sj);
      } else if(_valueCarServiceType.DurationTypeConstId==Constants.SERVICE_DURATION_DAY){
        Jalali sj=Jalali.now().addDays(dv);
        serviceDate=DateTimeUtils.getDateJalaliThis(sj);
      } }
    return serviceDate;
  }

  String getAlarmDate() {
    //String serviceDate='';
    //String alarmDate='';

   if(serviceDate==null || serviceDate.isEmpty)
     serviceDate=getServiceDate();
    if(isDurational){
      int dv=_valueCarServiceType.AlarmDurationDay;
      if(_valueCarServiceType.DurationTypeConstId==Constants.SERVICE_DURATION_MONTH){

        if(serviceDate!=null && serviceDate.isNotEmpty) {
          Jalali sj=DateTimeUtils.convertIntoDateTimeJalali(serviceDate);
          Jalali nowDate=sj.addDays(-dv);
          alarmDate=DateTimeUtils.getDateJalaliThis(nowDate);
        }

      }else if(_valueCarServiceType.DurationTypeConstId==Constants.SERVICE_DURATION_YEAR){
        if(serviceDate!=null && !serviceDate.isNotEmpty) {
          Jalali sj=DateTimeUtils.convertIntoDateTimeJalali(serviceDate);
          Jalali nowDate=sj.addDays(-dv);
          alarmDate=DateTimeUtils.getDateJalaliThis(nowDate);
        }
      } else if(_valueCarServiceType.DurationTypeConstId==Constants.SERVICE_DURATION_DAY){
        if(serviceDate!=null && !serviceDate.isNotEmpty) {
          Jalali sj=DateTimeUtils.convertIntoDateTimeJalali(serviceDate);
          Jalali nowDate=sj.addDays(-dv);
          alarmDate=DateTimeUtils.getDateJalaliThis(nowDate);
        }
      }
      if(!isAlarmDateEdited) {
        textEditingController3.value = textEditingController3.value.copyWith(
          text: alarmDate,
          selection:
          TextSelection(
              baseOffset: alarmDate.length, extentOffset: alarmDate.length),
          composing: TextRange.empty,
        );
      } else{
        textEditingController3.value = textEditingController3.value.copyWith(
          text: alarmDate,
          selection:
          TextSelection(
              baseOffset: alarmDate.length, extentOffset: alarmDate.length),
          composing: TextRange.empty,
        );
      }
    }
    return alarmDate;
  }
  Widget _buildServiceDateField(double width, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context);
    editMode=(widget.editMode!=null && widget.editMode);
    //String serviceDate='';

    if(editMode){
       if(serviceDate==null || serviceDate.isEmpty || serviceDate=='null') {
         serviceDate = widget.service != null ? widget.service.ServiceDate : '';
         if (serviceDate == null || serviceDate == 'null') {
           serviceDate = '';
         }
         textEditingController.value = textEditingController.value.copyWith(
           text: serviceDate,
           selection:
           TextSelection(
               baseOffset: serviceDate.length,
               extentOffset: serviceDate.length),
           composing: TextRange.empty,
         );
       }
    } else {
      if(serviceDate==null || serviceDate.isEmpty || serviceDate=='null') {
        serviceDate = getServiceDate();
        textEditingController.value = textEditingController.value.copyWith(
          text: serviceDate,
          selection:
          TextSelection(
              baseOffset: serviceDate.length, extentOffset: serviceDate.length),
          composing: TextRange.empty,
        );
      }
    }
     // if(!isServiceDateEdited) {
        /*textEditingController.value = textEditingController.value.copyWith(
          text: serviceDate,
          selection:
          TextSelection(
              baseOffset: serviceDate.length, extentOffset: serviceDate.length),
          composing: TextRange.empty,
        );*/
     // }


    return AnimatedTextFormField(
      enableInteractiveSelection: false,
      width: width,
     controller: textEditingController,
     onTap: (){
        isServiceDateEdited=true;
        showDatePicker('Service',textEditingController);
     },
     // inputFormatters: [ maskPelakFormatter],
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.serviceDateHint,
      prefixIcon: Icon(FontAwesomeIcons.solidCalendar),
      //keyboardType: TextInputType.datetime ,
      textInputAction: TextInputAction.next,

      onFieldSubmitted: (value) {
        if(auth.isConfirm) {
            _submit();
          }
        else
          FocusScope.of(context).requestFocus(_serviceDateFocusNode);
      },
     validator: (value) {
        return null;
     },
      onSaved: (value) => _authData['serviceDate'] = value,
    );
  }

  Widget _buildServiceTypesField(double width, CarServiceMessages messages,int modelId) {
    return
       FormBuilderCustomField(
        initialValue: _valueCarServiceType,
        attribute: "ServiceTypeTitle",
        validators: [
          FormBuilderValidators.required(),
        ],
        formField: FormField(
          key:_formKey,
          onSaved: (value){  _authData['serviceTypeId'] = _valueCarServiceType.ServiceTypeId.toString();},
          enabled: true,
          builder: (FormFieldState<ServiceType> field) {
            return InputDecorator(
              decoration: InputDecoration(

                labelText: "نوع سرویس را انتخاب کنید",
                errorText: field.errorText,
                contentPadding:
                EdgeInsets.only(
                    top: 10.0, bottom: 0.0, right: 10.0, left: 10.0),
                border: InputBorder.none,
              ),
              child:
                      DropdownButton(
                        isExpanded: true,
                        items: serviceTypes.map((md) {
                          return DropdownMenuItem(
                            child: Text(md.ServiceTypeTitle),
                            value: md,
                          );
                        }).toList(),
                        value: _valueCarServiceType,
                          onChanged: (value) {
                          setState(() {
                            _valueCarServiceType=value;
                            _authData['serviceTypeId'] = value.ServiceTypeId.toString();
                            isDurational=_valueCarServiceType.ServiceTypeConstId==Constants.SERVICE_TYPE_DURATIONALITY;
                          });

                          //field.didChange(_valueCarModelDetail);
                        },
                      ),
            );
          }
        ),
      //);
    );
  }



  Widget _buildDistanceField(double width, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context);

    bool isEdit=(widget.editMode!=null && widget.editMode);
     if(isEdit!=null && isEdit){

     }
    return AnimatedTextFormField(


      enableInteractiveSelection: true,
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.distanceHint,
      controller: distanceController,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
      prefixIcon: Icon(Icons.directions_car),
      textInputAction:
      /*auth.isConfirm ?*/ TextInputAction.done, //: TextInputAction.next,
      focusNode: _distanceFocusNode,
      onFieldSubmitted: (value) {
        _submit();
          //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: null,
      onSaved: (value) => _authData['distance'] = value,
    );
  }
  Widget _buildServiceCostField(double width, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context);

    return AnimatedTextFormField(
      enableInteractiveSelection: true,
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.serviceCostHint,
      controller: costController,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
      prefixIcon: Icon(Icons.money_off),
      textInputAction:
      auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _serviceCostFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: null,
      onSaved: (value) => _authData['serviceCost'] = value,
    );
  }
  Widget _buildAlarmDateField(double width, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context);

    //alarmDate=getAlarmDate();


      if (widget.editMode != null && widget.editMode) {
        alarmDate = widget.service.AlarmDate;
         if(alarmDate==null || alarmDate.isEmpty || alarmDate=='null'){
           alarmDate='';
         }
        textEditingController3.value = textEditingController3.value.copyWith(
          text: alarmDate,
          selection:
          TextSelection(
              baseOffset: alarmDate.length, extentOffset: alarmDate.length),
          composing: TextRange.empty,
        );
      } else{
         if(alarmDate==null || alarmDate.isEmpty || alarmDate=='null'){
           alarmDate=getAlarmDate();
           textEditingController3.value = textEditingController3.value.copyWith(
             text: alarmDate,
             selection:
             TextSelection(
                 baseOffset: alarmDate.length, extentOffset: alarmDate.length),
             composing: TextRange.empty,
           );
         }

      }
    /*textEditingController3.value = textEditingController3.value.copyWith(
      text: alarmDate,
      selection:
      TextSelection(
          baseOffset: alarmDate.length, extentOffset: alarmDate.length),
      composing: TextRange.empty,
    );*/
    return AnimatedTextFormField(
      enableInteractiveSelection: false,
      onTap: (){
        isAlarmDateEdited=true;
        showDatePicker('Alarm',textEditingController3);},
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.alarmDateHint,
      controller: textEditingController3,
      //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.text, //numberWithOptions(decimal: false,signed: false),
      prefixIcon: Icon(Icons.date_range),
      textInputAction:
      auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _alarmDateFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: null,
      onSaved: (value) => _authData['alarmDate'] = value,
    );
  }
  Widget _buildActionDateField(double width, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context);

    return AnimatedTextFormField(
      enableInteractiveSelection: false,
      onTap: () {
        isActionDateEdited=true;
        showDatePicker('Action',textEditingController2);},
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.actionDateHint,
      controller: textEditingController2,
      //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.text,
      prefixIcon: Icon(Icons.date_range),
      textInputAction:
      auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _actionDateFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: (value){
        if(_isSubmitting){
          if(widget.editMode!=null && widget.editMode)
            {
              if(value==null || value.isEmpty || value=='')
                return 'ورود تایخ انجام الزامی است';
            }
        }
        return null;
      },
      onSaved: (value) => _authData['actionDate'] = value,
    );
  }
  Widget _buildAlarmCountField(double width, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context);

    if(!isDurational && widget.editMode!=null && widget.editMode) {
      int dv=_valueCarServiceType.AlarmCount;
      if(dv==null){
        dv=0;
      }
      alarmCountController.value =alarmCountController.value.copyWith(
        text: dv.toString(),
        selection:
        TextSelection(baseOffset: dv.toString().length, extentOffset: dv.toString().length),
        composing: TextRange.empty,
      );
    }
    return AnimatedTextFormField(
      enableInteractiveSelection: true,
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: isDurational ? messages.alarmCountHint : Translations.current.alarmDistance(),
      controller: alarmCountController,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
      prefixIcon: Icon(Icons.confirmation_number),
      textInputAction:
      auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _alarmCountFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: null,
      onSaved: (value) => _authData['alarmCount'] = value,
    );
  }



  Widget _buildSubmitButton(ThemeData theme, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context);

    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: AnimatedButton(
        controller: _submitController,
        text: auth.isConfirm ? messages.confirmButton : messages.cancelButton,
        onPressed: _submit,
      ),
    );
  }

  Widget _buildSwitchAuthButton(ThemeData theme, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context, listen: false);

    return FadeIn(
      controller: _loadingController,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      fadeDirection: FadeDirection.topToBottom,
      child: FlatButton(
        child: AnimatedText(
          text: auth.isCancel ? messages.confirmButton : messages.cancelButton,
          textRotation: AnimatedTextRotation.down,
        ),
        disabledTextColor: theme.primaryColor,
        onPressed: buttonEnabled ? _switchAuthMode : null,
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textColor: theme.primaryColor,
      ),
    );
  }
  Widget _buildDescriptionField(double width, CarServiceMessages messages) {
    final auth = Provider.of<Auth>(context);
    String description='';
    if(widget.editMode!=null && widget.editMode){
        description=widget.service.Description;
    }
    if(description==null){
      description='';
    }

    return AnimatedTextFormField(

      enableInteractiveSelection: true,
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.descriptionHint,
      controller: descriptionController,
      //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.text,
      prefixIcon: Icon(Icons.description),
      textInputAction:
      auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _descriptionFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: null,
      onSaved: (value) => _authData['description'] = value,
    );
  }
  @override
  Widget build(BuildContext context) {
    final isConfirm = Provider.of<Auth>(context, listen: false).isConfirm;
    final messages = Provider.of<CarServiceMessages>(context, listen: false);
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    const cardPadding = 1.0;
    final textFieldWidth = cardWidth - cardPadding * 2;
    final authForm = Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: cardPadding+5,
              right: cardPadding+5,
              top: cardPadding + 1,
            ),
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildServiceTypesField(textFieldWidth, messages,serviceTypeId),
                SizedBox(height: 5),
                isDurational ?  _buildServiceDateField(textFieldWidth, messages) : Container(),
                SizedBox(height: 5),
                (widget.editMode!=null && widget.editMode && widget.service.ServiceStatusConstId==Constants.SERVICE_DONE) ?  _buildActionDateField(textFieldWidth, messages) :
                Container(width: 0.0,height: 0.0,),
                SizedBox(height: 5),
                ((widget.editMode!=null && widget.editMode) || (isDurational)) ? _buildAlarmDateField(textFieldWidth, messages) :
                Container(width: 0.0,height: 0.0,),
                SizedBox(height: 5),
                (!isDurational)  ? _buildAlarmCountField(textFieldWidth, messages) : Container(),
                SizedBox(height: 5),
                (widget.editMode!=null && widget.editMode) ?   _buildServiceCostField(textFieldWidth, messages) :
                Container(),
                SizedBox(height: 5),
               !isDurational ? _buildDistanceField(textFieldWidth, messages) : Container(),
                SizedBox(height: 5),
                ((widget.editMode!=null && widget.editMode) && (widget.service.ServiceStatusConstId==Constants.SERVICE_NOTDONE ||
                    widget.service.ServiceStatusConstId==Constants.SERVICE_DONE)) ?  _buildDescriptionField(textFieldWidth, messages) :
                Container(),
              ],
            ),
          ),
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isConfirm
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(
         // horizontal: cardPadding,
          vertical: 10,
        ),
        child: Container(),
     // _buildDistanceField(textFieldWidth, messages),
      ),

    ],
    )

          ),
          Container(
            padding: Paddings.fromRBL(cardPadding),
            width: cardWidth,
            child: Column(
              children: <Widget>[
               // _buildForgotPassword(theme, messages),
                SizedBox(height: 5.0,),
                _buildSubmitButton(theme, messages),
                SizedBox(height: 5.0,),
                _buildSwitchAuthButton(theme, messages),
              ],
            ),
          ),
        ],
      ),
    );

    return FittedBox(
      child: Card(
        elevation: _showShadow ? theme.cardTheme.elevation : 0,
        child: authForm,
      ),
    );
  }
}

class _RecoverCard extends StatefulWidget {
  _RecoverCard({
    Key key,
    @required this.emailValidator,
    @required this.onSwitchLogin,
  }) : super(key: key);

  final FormFieldValidator<String> emailValidator;
  final Function onSwitchLogin;

  @override
  _RecoverCardState createState() => _RecoverCardState();
}

class _RecoverCardState extends State<_RecoverCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formRecoverKey = GlobalKey();

  var _isSubmitting = false;
  var _name = '';

  AnimationController _submitController;

  @override
  void initState() {
    super.initState();

    _submitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _submitController.dispose();
  }

  Future<bool> _submit() async {
    if (!_formRecoverKey.currentState.validate()) {
      return false;
    }
    final auth = Provider.of<Auth>(context, listen: false);
    final messages = Provider.of<CarServiceMessages>(context, listen: false);

    _formRecoverKey.currentState.save();
   // _submitController.forward();
    setState(() => _isSubmitting = true);
    final error = await auth.onRecoverPassword(_name);

    if (error != null) {
      showErrorToast(context, error);
      setState(() => _isSubmitting = false);
     // _submitController.reverse();
      return false;
    } else {
      showSuccessToast(context, '');
      setState(() => _isSubmitting = false);
     // _submitController.reverse();
      return true;
    }
  }

  Widget _buildRecoverNameField(double width, CarServiceMessages messages) {
    return AnimatedTextFormField(
      width: width,
      labelText: '',
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) => _submit(),
      validator: widget.emailValidator,
      onSaved: (value) => _name = value,
    );
  }

  Widget _buildRecoverButton(ThemeData theme, CarServiceMessages messages) {
    return AnimatedButton(
      controller: _submitController,
      text:'',
      onPressed: !_isSubmitting ? _submit : null,
    );
  }

  Widget _buildBackButton(ThemeData theme, CarServiceMessages messages) {
    return FlatButton(
      child: Text(messages.goBackButton),
      onPressed: !_isSubmitting ? widget.onSwitchLogin : null,
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textColor: theme.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = Provider.of<CarServiceMessages>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    const cardPadding = 16.0;
    final textFieldWidth = cardWidth - cardPadding * 2;

    return FittedBox(
      // width: cardWidth,
      child: Card(
        child: Container(
          padding: const EdgeInsets.only(
            left: cardPadding,
            top: cardPadding + 10.0,
            right: cardPadding,
            bottom: cardPadding,
          ),
          width: cardWidth,
          alignment: Alignment.center,
          child: Form(
            key: _formRecoverKey,
            child: Column(
              children: [
                Text(
                  '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.body1,
                ),
                SizedBox(height: 20),
                _buildRecoverNameField(textFieldWidth, messages),
                SizedBox(height: 20),
                Text(
                  '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.body1,
                ),
                SizedBox(height: 26),
                _buildRecoverButton(theme, messages),
                _buildBackButton(theme, messages),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
