import 'dart:math';

import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/flutter_form_builder/src/form_builder_custom_field.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_color.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/model/cars/car_model_detail.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/add_car_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/car/fancy_car/src/models/car_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import '../dart_helper.dart';
import '../matrix.dart';
import '../paddings.dart';
import '../providers/auth.dart';
import '../providers/login_messages.dart';
import '../widget_helper.dart';
import 'animated_button.dart';
import 'animated_text.dart';
import 'animated_text_form_field.dart';
import 'custom_page_transformer.dart';
import 'expandable_container.dart';
import 'fade_in.dart';

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
    this.addCarVM,
  }) : super(key: key);

  final EdgeInsets padding;
  final AnimationController loadingController;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> pelakValidator;
  final FormFieldValidator<String> passwordValidator;
  final Function onSubmit;
  final Function onSubmitCompleted;
  final AddCarVM addCarVM;
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

  int modelId = 0;
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
                    addCarVM: widget.addCarVM,
                    key: _cardKey,
                    loadingController: _isLoadingFirstTime
                        ? _formLoadingController
                        : (_formLoadingController..value = 1.0),
                    emailValidator: widget.emailValidator,
                    pelakValidator: widget.pelakValidator,
                    passwordValidator: widget.passwordValidator,
                    onSwitchRecoveryPassword: () => _switchRecovery(true),
                    onSubmitCompleted: () {
                      //_forwardChangeRouteAnimation().then((_) {
                      widget.onSubmitCompleted();
                      // });
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

    return current;
    /*AnimatedBuilder(
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
    );*/
  }
}

class _CarCard extends StatefulWidget {
  _CarCard(
      {Key key,
      this.loadingController,
      @required this.emailValidator,
      @required this.mobileValidator,
      @required this.pelakValidator,
      @required this.passwordValidator,
      @required this.onSwitchRecoveryPassword,
      this.onSwitchAuth,
      this.onSubmitCompleted,
      this.addCarVM})
      : super(key: key);

  final AnimationController loadingController;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> mobileValidator;
  final FormFieldValidator<String> pelakValidator;
  //final FormFieldValidator<String> emailValidator;

  final FormFieldValidator<String> passwordValidator;
  final Function onSwitchRecoveryPassword;
  final Function onSwitchAuth;
  final Function onSubmitCompleted;
  AddCarVM addCarVM;
  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<_CarCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordFocusNode = FocusNode();
  final _distanceFocusNode = FocusNode();
  final _pelakFocusNode = FocusNode();

  final _confirmPasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();

  var _authData = {
    'pelak': '',
    'tip': '',
    'modelId': '',
    'colorId': '',
    'distance': '',
    'brandId': '',
    'cancel': ''
  };
  var _isLoading = false;
  var _isSubmitting = false;
  var _showShadow = true;
  bool isTipSelected = false;
  bool isCarModelSelected = false;

  var maskPelakFormatter =
      new MaskTextInputFormatter(mask: '##@###(##)', filter: {
    "@": RegExp(r'[A-Za-z]'),
    "#": RegExp(r'[0-9]'),
  });

  static var translator = {
    '#': new RegExp(r'[\d]+$'),
    '@': new RegExp(r'[\S]+$')
  };

  String pelak_part1 = '';
  String pelak_part2 = '';
  String pelak_part3 = '';
  String pelak_part4 = '';

  var pelak_part2_title = [
    {'title': 'الف'},
    {'title': 'ب'},
    {'title': 'پ'},
    {'title': 'ت'},
    {'title': 'ث'},
    {'title': 'ج'},
    {'title': 'چ'},
    {'title': 'ح'},
    {'title': 'خ'},
    {'title': 'د'},
    {'title': 'ذ'},
    {'title': 'ر'},
    {'title': 'ز'},
    {'title': 'س'},
    {'title': 'ش'},
    {'title': 'ص'},
    {'title': 'ض'},
    {'title': 'ع'},
    {'title': 'غ'},
    {'title': 'ق'},
    {'title': 'ک'},
    {'title': 'گ'},
    {'title': 'ل'},
    {'title': 'م'},
    {'title': 'ن'},
    {'title': 'و'},
    {'title': 'ه'},
    {'title': 'ی'},
  ];
  var controller = new MaskedTextController(
      mask: '00-A-000-00' /*, translator: translator*/);
  var distanceController = new TextEditingController();
  var pelakController = new TextEditingController();
  var pelakController1 = new TextEditingController();
  var pelakController2 = new TextEditingController();
  var pelakController3 = new TextEditingController();
  var pelakController4 = new TextEditingController();

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
  int modelId = 0;
  int brandId = 0;
  NotyBloc<Message> carModelNoty;
  NotyBloc<Message> brandModelNoty;
  CarModel _valueCarModel;
  CarModelDetail _valueCarModelDetail;
  BrandModel _valueBrand;
  ApiCarColor _valueCarColor;
  Future<List<CarModelDetail>> carModelDetails;
  Future<List<CarModel>> carModels;

  List<CarModelDetail> modelDetails = new List();
  List<CarModel> cmodels = new List();

  List<BrandModel> brands = new List();
  List<ApiCarColor> colors = new List();

  List<CarModel> fetchCarModels(List<CarModel> models) {
    if (cmodels != null && cmodels.length > 0) cmodels.clear();
    cmodels = List.from(centerRepository
        .getCarModels()
        .where((cm) => cm.brandId == brandId)
        .toSet()
        .toList());
    if (cmodels != null && cmodels.length > 0) {
      _valueCarModel = cmodels.first;
      setState(() {
        fetchCarModelDetails(null);
      });
    }
    return cmodels;
  }

  List<CarModelDetail> fetchCarModelDetails(List<CarModelDetail> models) {
    if (modelDetails != null && modelDetails.length > 0) modelDetails.clear();
    modelDetails = List.from(centerRepository
        .getCarModelDetails()
        .where((cm) => cm.carModelId == modelId)
        .toSet()
        .toList());
    if (modelDetails != null && modelDetails.length > 0) {
      setState(() {
        _valueCarModelDetail = modelDetails.first;
      });
    }
    return modelDetails;
  }

  @override
  void initState() {
    carModelNoty = new NotyBloc<Message>();
    brandModelNoty = new NotyBloc<Message>();
    cmodels = new List();
    modelDetails = new List();
    brands = new List();
    cmodels = List.from(centerRepository.getCarModels());
    modelDetails = List.from(centerRepository.getCarModelDetails());
    brands = List.from(centerRepository.getCarBrands());
    colors = List.from(centerRepository.getCarColors());

    if (cmodels != null && cmodels.length > 0) {
      if (_valueCarModel == null) {
        _valueCarModel = cmodels[0];
      }
    }
    if (brands != null && brands.length > 0) {
      if (_valueBrand == null) {
        _valueBrand = brands[0];
      }
    }

    if (modelDetails != null && modelDetails.length > 0) {
      if (_valueCarModelDetail == null) {
        _valueCarModelDetail = modelDetails[0];
      }
    }

    if (colors != null && colors.length > 0) {
      if (_valueCarColor == null) {
        _valueCarColor = colors[0];
      }
    }

    /*_authData['colorId']=_valueCarColor!=null ? _valueCarColor.ConstantId.toString() : '0';
    _authData['modelId']=_valueCarModel!=null ? _valueCarModel.carModelId.toString() : '0';
    _authData['brandId']=_valueBrand!=null ? _valueBrand.brandId.toString() : '0';
    _authData['tip']=_valueCarModelDetail!=null ? _valueCarModelDetail.carModelDetailId.toString() : '0';
*/
    pelak_part2 = pelak_part2_title[0]['title'];

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

    if (widget.addCarVM != null &&
        widget.addCarVM.editMode != null &&
        widget.addCarVM.editMode) {
      _valueBrand = brands
          .where((b) => b.brandId == widget.addCarVM.editCarModel.brandId)
          .toList()
          .first;
      _valueCarModel = cmodels
          .where((c) => c.carModelId == widget.addCarVM.editCarModel.modelId)
          .toList()
          .first;
      _valueCarColor = colors
          .where((c) => c.ConstantId == widget.addCarVM.editCarModel.colorId)
          .toList()
          .first;
      _valueCarModelDetail = modelDetails
          .where((c) => c.carModelDetailId == widget.addCarVM.editCarModel.tip)
          .toList()
          .first;

      if (_valueCarColor == null) _valueCarColor = colors[0];

      /* _authData['colorId']=_valueCarColor!=null ? _valueCarColor.ConstantId.toString() : '0';
      _authData['modelId']=_valueCarModel!=null ? _valueCarModel.carModelId.toString() : '0';
      _authData['brandId']=_valueBrand!=null ? _valueBrand.brandId.toString() : '0';
      _authData['tip']=_valueCarModelDetail!=null ? _valueCarModelDetail.carModelDetailId.toString() : '0';
*/
      String seDate = widget.addCarVM.editCarModel.pelak;
      if (seDate != null && seDate.isNotEmpty) {
        var parts = seDate.split('-');
        if (parts != null && parts.length > 0 && parts.length == 5) {
          pelakController1.value = pelakController1.value.copyWith(
            text: parts[0],
            selection: TextSelection(
                baseOffset: parts[0].length, extentOffset: parts[0].length),
            composing: TextRange.empty,
          );
          pelakController2.value = pelakController2.value.copyWith(
            text: parts[1],
            selection: TextSelection(
                baseOffset: parts[1].length, extentOffset: parts[1].length),
            composing: TextRange.empty,
          );
          pelakController3.value = pelakController3.value.copyWith(
            text: parts[2],
            selection: TextSelection(
                baseOffset: parts[2].length, extentOffset: parts[2].length),
            composing: TextRange.empty,
          );
          pelakController4.value = pelakController4.value.copyWith(
            text: parts[4],
            selection: TextSelection(
                baseOffset: parts[4].length, extentOffset: parts[4].length),
            composing: TextRange.empty,
          );
          //_authData['pelak']=parts[0]+'-'+parts[1]+'-'+parts[2]+'-'+Translations.current.iranTitle()+'-'+ parts[4];
        }
        /*    controller.addListener(() {
          final text = controller.text.toLowerCase();
          controller.value = controller.value.copyWith(
            text: text,
            selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
            composing: TextRange.empty,
          );
        });*/
      }
      String dist = widget.addCarVM.editCarModel.distance != null
          ? widget.addCarVM.editCarModel.distance.toString()
          : '';
      distanceController.value = distanceController.value.copyWith(
        text: dist,
        selection:
            TextSelection(baseOffset: dist.length, extentOffset: dist.length),
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
    _pelakFocusNode.dispose();
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
    FocusScope.of(context).requestFocus(FocusNode());

    if (!_formKey.currentState.validate()) {
      return false;
    }
    final auth = Provider.of<Auth>(context, listen: false);
    if (auth.isConfirm) {
      if (widget.addCarVM.editMode != null &&
          widget.addCarVM.editMode == true &&
          isCarModelSelected &&
          !isTipSelected) {
        centerRepository.showFancyToast('لطفا نوع و تیپ را انتخاب کنید', false);
        return false;
      }
    }
    _formKey.currentState.save();
    _submitController.forward();
    setState(() => _isSubmitting = true);

    String error;
    isTipSelected = false;
    isCarModelSelected = false;
    if (auth.isConfirm) {
      _authData['pelak'] = pelak_part1 +
          '-' +
          pelak_part2 +
          '-' +
          pelak_part3 +
          '-' +
          Translations.current.iranTitle() +
          '-' +
          pelak_part4;
      error = await auth.onConfirm(CarData(
        pelak: _authData['pelak'],
        tip: int.tryParse(_authData['tip']),
        modelId: int.tryParse(_authData['modelId']),
        colorId: int.tryParse(_authData['colorId']),
        brandId: int.tryParse(_authData['brandId']),
        distance: int.tryParse(_authData['distance']),
        cancel: false,
      ));
    } else {
      error = await auth.onCancel(CarData(
        pelak: '',
        tip: 0,
        modelId: 0,
        colorId: 0,
        brandId: 0,
        distance: 0,
        cancel: true,
      ));
    }

    // workaround to run after _cardSizeAnimation in parent finished
    // need a cleaner way but currently it works so..
    Future.delayed(const Duration(milliseconds: 270), () {
      setState(() => _showShadow = false);
    });

    _submitController.reverse();

    if (!DartHelper.isNullOrEmpty(error)) {
      showErrorToast(context, error);
      Future.delayed(const Duration(milliseconds: 271), () {
        setState(() => _showShadow = true);
      });
      setState(() => _isSubmitting = false);
      return false;
    } else {
      Future.delayed(const Duration(milliseconds: 271), () {
        setState(() => _showShadow = true);
      });
      setState(() => _isSubmitting = false);
      //return false;

    }

    widget?.onSubmitCompleted();

    return true;
  }

  Widget _buildPelakField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);

    if (widget.addCarVM != null &&
        widget.addCarVM.editMode != null &&
        widget.addCarVM.editMode) {
      String pelak = widget.addCarVM.editCarModel.pelak;
      var parts = pelak.split('-');
      if (parts != null && parts.length > 0 && parts.length == 5) {
        pelak_part1 = parts[0];
        pelak_part2 = parts[1];
        pelak_part3 = parts[2];
        pelak_part4 = parts[4];
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: 40.0,
          width: 50.0,
          child: new TextFormField(
            initialValue: pelak_part4 != null ? pelak_part4 : '',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            inputFormatters: [LengthLimitingTextInputFormatter(2)],
            decoration: new InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.green),
              ),
              labelText: "",
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(2.0),
                borderSide: new BorderSide(width: 1.0, color: Colors.black),
              ),
              //fillColor: Colors.green
            ),
            validator: (val) {
              if (auth.isConfirm) {
                if (val.length == 0) {
                  return "نمیتواند خالی باشد";
                }
                return null;
              } else {
                return null;
              }
            },
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            style: new TextStyle(
              fontFamily: "IranSans",
            ),
            onFieldSubmitted: (value) {
              if (auth.isConfirm) {
                _submit();
              } else
                FocusScope.of(context).requestFocus(_pelakFocusNode);
            },
            onSaved: (value) {
              pelak_part4 = value;
            },
          ),
        ),
        Container(
          width: 20.0,
          child: Text(
            Translations.current.iranTitle(),
            style: TextStyle(fontSize: 8.0),
          ),
        ),
        Container(
          height: 40.0,
          width: 50.0,
          child: new TextFormField(
            initialValue: pelak_part3 != null ? pelak_part3 : '',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            inputFormatters: [LengthLimitingTextInputFormatter(3)],
            decoration: new InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.green),
              ),
              labelText: "",
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(2.0),
                borderSide: new BorderSide(width: 1.0, color: Colors.black),
              ),
              //fillColor: Colors.green
            ),
            validator: (val) {
              if (auth.isConfirm) {
                if (val.length == 0) {
                  return "نمیتواند خالی باشد";
                }
                return null;
              } else {
                return null;
              }
            },
            onFieldSubmitted: (value) {
              if (auth.isConfirm) {
                _submit();
              } else
                FocusScope.of(context).requestFocus(_pelakFocusNode);
            },
            onSaved: (value) {
              pelak_part3 = value;
            },
            keyboardType:
                TextInputType.numberWithOptions(decimal: false, signed: false),
            style: new TextStyle(
              fontFamily: "IranSans",
            ),
          ),
        ),
        Container(
          height: 40.0,
          width: 50.0,
          child: new TextFormField(
            initialValue: pelak_part2 != null ? pelak_part2 : '',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            inputFormatters: [
              BlacklistingTextInputFormatter('.!@#\\\$%^&*(),;:"\\\'و،'),
              LengthLimitingTextInputFormatter(1)
            ],
            decoration: new InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.green),
              ),
              labelText: "",
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(2.0),
                borderSide: new BorderSide(width: 0.5, color: Colors.black),
              ),
              //fillColor: Colors.green
            ),
            validator: (val) {
              if (auth.isConfirm) {
                if (val.length == 0) {
                  return "نمیتواند خالی باشد";
                }
                return null;
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.text,
            style: new TextStyle(
              fontFamily: "IranSans",
            ),
            onFieldSubmitted: (value) {
              if (auth.isConfirm) {
                _submit();
              } else
                FocusScope.of(context).requestFocus(_pelakFocusNode);
            },
            onSaved: (value) {
              pelak_part2 = value;
            },
          ),
        ),
        Container(
          height: 40.0,
          width: 50.0,
          child: new TextFormField(
            initialValue: pelak_part1 != null ? pelak_part1 : '',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            inputFormatters: [LengthLimitingTextInputFormatter(2)],
            decoration: new InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.green),
              ),
              labelText: "",
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(2.0),
                borderSide: new BorderSide(width: 0.5, color: Colors.black),
              ),
              //fillColor: Colors.green
            ),
            validator: (val) {
              if (auth.isConfirm) {
                if (val.length == 0) {
                  return "نمیتواند خالی باشد";
                }
                return null;
              } else {
                return null;
              }
            },
            onSaved: (value) {
              pelak_part1 = value;
            },
            keyboardType:
                TextInputType.numberWithOptions(decimal: false, signed: false),
            style: new TextStyle(
              fontFamily: "IranSans",
            ),
            onFieldSubmitted: (value) {
              if (auth.isConfirm) {
                _submit();
              } else
                FocusScope.of(context).requestFocus(_pelakFocusNode);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTipField(double width, LoginMessages messages, int modelId) {
    /* if(widget.addCarVM!=null && widget.addCarVM.editMode!=null && widget.addCarVM.editMode) {
      _valueCarModelDetail = modelDetails
          .where((c) => c.carModelDetailId == widget.addCarVM.editCarModel.tip)
          .toList()
          .first;
      _authData['tip']=_valueCarModelDetail!=null ? _valueCarModelDetail.carModelDetailId.toString() : '0';

    }*/

    return FormBuilderCustomField(
      initialValue: _valueCarModelDetail,
      attribute: "carModelDetailTitle",
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
          key: _formKey,
          onSaved: (value) {
            _authData['tip'] = _valueCarModelDetail.carModelDetailId.toString();
          },
          enabled: true,
          autovalidate: true,
          validator: (value) {
            if (value == null) {
              return 'انتخاب تیپ خودرو الزامی است';
            } else {
              return null;
            }
          },
          builder: (FormFieldState<CarModelDetail> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: "لطفا تیپ خودرو را انتخاب کنید",
                errorText: field.errorText,
                contentPadding: EdgeInsets.only(
                    top: 10.0, bottom: 0.0, right: 10.0, left: 10.0),
                border: InputBorder.none,
              ),
              child: DropdownButton(
                isExpanded: true,
                items: modelDetails.map((md) {
                  return DropdownMenuItem(
                    child: Text(md.carModelDetailTitle),
                    value: md,
                  );
                }).toList(),
                value: _valueCarModelDetail,
                onChanged: (value) {
                  setState(() {
                    isTipSelected = true;
                    _valueCarModelDetail = value;
                    _authData['tip'] = value.carModelDetailId.toString();
                  });

                  //field.didChange(_valueCarModelDetail);
                },
              ),
            );
          }),
      //);
      // }
      // );
      /*}
        return Container(width: 0,height: 0,);
      }*/
    );
  }

  Widget _buildColorField(double width, LoginMessages messages) {
    /*if(widget.addCarVM!=null && widget.addCarVM.editMode!=null && widget.addCarVM.editMode) {
    _valueCarColor=colors.where((c)=>c.ConstantId==widget.addCarVM.editCarModel.colorId).toList().first;
    _authData['colorId']=_valueCarColor!=null ? _valueCarColor.ConstantId.toString() : '0';

}*/
    return FormBuilderCustomField(
      initialValue: _valueCarColor,
      attribute: "DisplayName",
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
        key: _formKey,
        onSaved: (value) {
          _authData['colorId'] = _valueCarColor.ConstantId.toString();
        },
        //initialValue: ,
        enabled: true,
        builder: (FormFieldState<ApiCarColor> field) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: "لطفا رنگ خودرو را انتخاب کنید",
              errorText: field.errorText,
              contentPadding: EdgeInsets.only(
                  top: 10.0, bottom: 0.0, right: 10.0, left: 10.0),
              border: InputBorder.none,
            ),
            child: DropdownButton(
              isExpanded: true,
              items: colors.map((color) {
                return DropdownMenuItem(
                  child: Text(color.DisplayName),
                  value: color,
                );
              }).toList(),
              value: _valueCarColor /*field.value*/,
              onChanged: (value) {
                setState(() {
                  _valueCarColor = value;
                  _authData['colorId'] = value.ConstantId.toString();
                });

                //field.didChange(value);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildModelField(double width, LoginMessages messages) {
    List<CarModel> modls = new List();
    modls = centerRepository.getCarModels();
    return FormBuilderCustomField(
      //initialValue: modls[0],
      attribute: "carModelTitle",
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
        key: _formKey,
        onSaved: (value) {
          _authData['modelId'] = value.carModelId.toString();
        },
        enabled: true,
        builder: (FormFieldState<CarModel> field) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: "لطفا مدل خودرو را انتخاب کنید",
              errorText: field.errorText,
              contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
              border: InputBorder.none,
            ),
            child: DropdownButton(
              isExpanded: true,
              items: modls.map((m) {
                return DropdownMenuItem(
                  child: Text(m.carModelTitle),
                  value: m,
                );
              }).toList(),
              value: field.value,
              onChanged: (value) {
                _authData['modelId'] = value.carModelId.toString();
                field.didChange(value);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarModelField(
      double width, LoginMessages messages, int brandId) {
    /*if(widget.addCarVM!=null && widget.addCarVM.editMode!=null && widget.addCarVM.editMode) {
      _valueCarModel=cmodels.where((c)=>c.carModelId==widget.addCarVM.editCarModel.modelId).toList().first;
      _authData['modelId']=_valueCarModel!=null ? _valueCarModel.carModelId.toString() : '0';


    }*/
    return FormBuilderCustomField(
      initialValue: _valueCarModel,
      attribute: "carModelTitle",
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
          key: _formKey,
          onSaved: (value) {
            _authData['modelId'] = _valueCarModel.carModelId.toString();
          },
          enabled: true,
          builder: (FormFieldState<CarModel> field) {
            return InputDecorator(
              decoration: InputDecoration(
                // icon: Icon(Icons.branding_watermark),
                labelText: "لطفا مدل خودرو را انتخاب کنید",
                errorText: field.errorText,
                contentPadding: EdgeInsets.only(
                    top: 10.0, bottom: 0.0, right: 10.0, left: 10.0),
                border: InputBorder.none,
              ),
              child: DropdownButton(
                //elevation: 0,
                isExpanded: true,
                items: cmodels.map((brand) {
                  return DropdownMenuItem(
                    child: new Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Text(brand.carModelTitle.toString()),
                    ),
                    value: brand,
                  );
                }).toList(),
                value: _valueCarModel /*field.value*/,
                onChanged: (value) {
                  setState(() {
                    _authData['modelId'] = value.carModelId.toString();
                    _valueCarModel = value;
                    isCarModelSelected = true;
                    // field.didChange(_valueCarModel);
                    modelId = value.carModelId;
                    fetchCarModelDetails(null);
                  });
                  /* carModelNoty.updateValue(
                                        new Message(index: modelId));*/
                },
              ),
            );
          }),
    );
    // }
    // );
    /* }
          return Container(width: 0,height: 0,);
        }
          );*/
  }

  Widget _buildBrandField(double width, LoginMessages messages) {
    /*//final auth = Provider.of<Auth>(context);
    if(widget.addCarVM!=null && widget.addCarVM.editMode!=null && widget.addCarVM.editMode) {
      _valueBrand=brands.where((b)=>b.brandId==widget.addCarVM.editCarModel.brandId).toList().first;
      _authData['brandId']=_valueBrand!=null ? _valueBrand.brandId.toString() : '0';

    }*/
    return FormBuilderCustomField(
      initialValue: _valueBrand,
      attribute: "brandTitle",
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
        key: _formKey,
        onSaved: (value) {
          _authData['brandId'] = _valueBrand.brandId.toString();
        },
        enabled: true,
        builder: (FormFieldState<BrandModel> field) {
          return InputDecorator(
            decoration: InputDecoration(
              // icon: Icon(Icons.branding_watermark),
              labelText: "لطفا برند خودرو را انتخاب کنید",
              errorText: field.errorText,
              contentPadding: EdgeInsets.only(
                  top: 10.0, bottom: 0.0, right: 10.0, left: 10.0),
              border: InputBorder.none,
            ),
            child: DropdownButton(
              //elevation: 0,
              isExpanded: true,
              items: brands.map((brand) {
                return DropdownMenuItem(
                  child: new Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(brand.brandTitle),
                  ),
                  value: brand,
                );
              }).toList(),
              value: _valueBrand /*field.value*/,
              onChanged: (value) {
                setState(() {
                  _authData['brandId'] = value.brandId.toString();
                  _valueBrand = value;
                  //field.didChange(_valueBrand);
                  // brandModelNoty.updateValue(new Message(index: value.brandId));
                  brandId = value.brandId;
                  fetchCarModels(null);
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDistanceField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);
    /*if(widget.addCarVM!=null && widget.addCarVM.editMode!=null && widget.addCarVM.editMode) {
      String dist= widget.addCarVM.editCarModel.distance!=null ? widget.addCarVM.editCarModel.distance.toString() : '';
      distanceController.value = distanceController.value.copyWith(
        text: dist,
        selection:
        TextSelection(baseOffset: dist.length, extentOffset: dist.length),
        composing: TextRange.empty,
      );
    }*/
    return AnimatedTextFormField(
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.distanceHint,
      controller: distanceController,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      prefixIcon: Icon(Icons.directions_car),
      textInputAction:
          auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _distanceFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: null,
      onSaved: (value) {
        _authData['distance'] = value;
      },
    );
  }

  Widget _buildConfirmPasswordField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);

    return AnimatedPasswordTextFormField(
      animatedWidth: width,
      enabled: auth.isCancel,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: messages.confirmPasswordHint,
      textInputAction: TextInputAction.done,
      focusNode: _confirmPasswordFocusNode,
      onFieldSubmitted: (value) => _submit(),
      validator: auth.isCancel
          ? (value) {
              if (value != _passwordController.text) {
                return messages.confirmPasswordError;
              }
              return null;
            }
          : (value) => null,
    );
  }

  Widget _buildForgotPassword(ThemeData theme, LoginMessages messages) {
    return FadeIn(
      controller: _loadingController,
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      child: FlatButton(
        child: Text(
          messages.forgotPasswordButton,
          style: theme.textTheme.body1,
          textAlign: TextAlign.left,
        ),
        onPressed: buttonEnabled ? widget.onSwitchRecoveryPassword : null,
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme, LoginMessages messages) {
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

  Widget _buildSwitchAuthButton(ThemeData theme, LoginMessages messages) {
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

  @override
  Widget build(BuildContext context) {
    final isConfirm = Provider.of<Auth>(context, listen: false).isConfirm;
    final messages = Provider.of<LoginMessages>(context, listen: false);
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    const cardPadding = 16.0;
    final textFieldWidth = cardWidth - cardPadding * 2;
    final authForm = Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: cardPadding,
              right: cardPadding,
              top: cardPadding + 10,
            ),
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildBrandField(textFieldWidth, messages),
                SizedBox(height: 5),
                _buildCarModelField(textFieldWidth, messages, brandId),
                SizedBox(height: 5),
                _buildTipField(textFieldWidth, messages, modelId),
                SizedBox(height: 5),
                _buildColorField(textFieldWidth, messages),
                SizedBox(height: 5),
                _buildPelakField(textFieldWidth, messages),
                SizedBox(height: 5),
                _buildDistanceField(textFieldWidth, messages)
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
                    child: _buildConfirmPasswordField(textFieldWidth, messages),
                  ),
                ],
              )),
          Container(
            padding: Paddings.fromRBL(cardPadding),
            width: cardWidth,
            child: Column(
              children: <Widget>[
                // _buildForgotPassword(theme, messages),
                SizedBox(
                  height: 5.0,
                ),
                _buildSubmitButton(theme, messages),
                SizedBox(
                  height: 5.0,
                ),
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
    final messages = Provider.of<LoginMessages>(context, listen: false);

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
      showSuccessToast(context, messages.recoverPasswordSuccess);
      setState(() => _isSubmitting = false);
      // _submitController.reverse();
      return true;
    }
  }

  Widget _buildRecoverNameField(double width, LoginMessages messages) {
    return AnimatedTextFormField(
      width: width,
      labelText: messages.usernameHint,
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) => _submit(),
      validator: widget.emailValidator,
      onSaved: (value) {
        _name = value;
      },
    );
  }

  Widget _buildRecoverButton(ThemeData theme, LoginMessages messages) {
    return AnimatedButton(
      controller: _submitController,
      text: messages.recoverPasswordButton,
      onPressed: !_isSubmitting ? _submit : null,
    );
  }

  Widget _buildBackButton(ThemeData theme, LoginMessages messages) {
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
    final messages = Provider.of<LoginMessages>(context, listen: false);
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
                  messages.recoverPasswordIntro,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.body1,
                ),
                SizedBox(height: 20),
                _buildRecoverNameField(textFieldWidth, messages),
                SizedBox(height: 20),
                Text(
                  messages.recoverPasswordDescription,
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
