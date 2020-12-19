import 'dart:math';

import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/flutter_form_builder/src/form_builder_custom_field.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/viewmodel/reg_service_type_vm.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/service/service_type/fancy_service/src/models/car_service_type_data.dart';
import 'package:anad_magicar/ui/screen/service/service_type/fancy_service/src/providers/car_service_type_messages.dart';
import 'package:anad_magicar/utils/dart_helper.dart' as dh;
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

import '../dart_helper.dart';
import '../matrix.dart';
import '../paddings.dart';
import '../widget_helper.dart';

class AuthCard extends StatefulWidget {
  AuthCard({
    Key key,
    this.padding = const EdgeInsets.all(0),
    this.loadingController,
    this.emailValidator,
    this.fieldValidator,
    this.passwordValidator,
    this.onSubmit,
    this.onSubmitCompleted,
    this.regServiceTypeVM,
  }) : super(key: key);

  final EdgeInsets padding;
  final AnimationController loadingController;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> fieldValidator;
  final FormFieldValidator<String> passwordValidator;
  final Function onSubmit;
  final Function onSubmitCompleted;
  RegServiceTypeVM regServiceTypeVM;
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
        index: _pageIndex,
        transformer: CustomPageTransformer(),
        itemBuilder: (BuildContext context, int index) {
          final child = (index == 0)
              ? _buildLoadingAnimator(
                  theme: theme,
                  child: _CarCard(
                    isEditMode: widget.regServiceTypeVM.editMode,
                    serviceType: widget.regServiceTypeVM.serviceType,
                    key: _cardKey,
                    loadingController: _isLoadingFirstTime
                        ? _formLoadingController
                        : (_formLoadingController..value = 1.0),
                    emailValidator: widget.emailValidator,
                    fieldValidator: widget.fieldValidator,
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
    @required this.fieldValidator,
    // @required this.pelakValidator,
    @required this.passwordValidator,
    @required this.onSwitchRecoveryPassword,
    this.onSwitchAuth,
    this.onSubmitCompleted,
    this.isEditMode,
    this.serviceType,
  }) : super(key: key);

  final AnimationController loadingController;
  final FormFieldValidator<String> emailValidator;
  //final FormFieldValidator<String> mobileValidator;
  final FormFieldValidator<String> fieldValidator;
  //final FormFieldValidator<String> emailValidator;

  final FormFieldValidator<String> passwordValidator;
  final Function onSwitchRecoveryPassword;
  final Function onSwitchAuth;
  final Function onSubmitCompleted;
  ServiceType serviceType;
  final bool isEditMode;

  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<_CarCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _alarmCountFocusNode = FocusNode();
  final _distanceFocusNode = FocusNode();
  final _alarmDurationDayFocusNode = FocusNode();
  final _durationCountValueFocusNode = FocusNode();
  final _durationValueFocusNode = FocusNode();
  final _serviceTypeTitleFocusNode = FocusNode();
  final _serviceTypeCodeFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _confirmPasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _distanceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _serviceCodeController = TextEditingController();
  final _serviceTitleController = TextEditingController();
  final _durationController = TextEditingController();
  final _durationCountValueController = TextEditingController();
  final _alarmDurationDayController = TextEditingController();
  final _Controller = TextEditingController();

  final _alarmCountController = TextEditingController();

  var _authData = {
    'serviceTypeCode': '',
    'serviceTypeTitle': '',
    'durationValue': '',
    'durationCountValue': '',
    'description': '',
    'alarmDurationDay': '',
    'alarmCount': '',
    'automationInsert': false,
    'serviceTypeId': '',
    'serviceTypeConstId': '',
    'durationTypeId': '',
    'cancel': ''
  };

  var _isLoading = false;
  var _isSubmitting = false;
  var _showShadow = true;

  var maskPelakFormatter =
      new MaskTextInputFormatter(mask: '##@###(##)', filter: {
    "@": RegExp(r'[A-Za-z]'),
    "#": RegExp(r'[0-9]'),
  });

  static var translator = {
    '#': new RegExp(r'[\d]+$'),
    '@': new RegExp(r'[\S]+$')
  };

  var controller =
      new MaskedTextController(mask: '##@###(##)', translator: translator);
  AnimationController _loadingController;
  AnimationController _switchAuthController;
  AnimationController _postSwitchAuthController;
  AnimationController _submitController;

  Interval _nameTextFieldLoadingAnimationInterval;
  Interval _passTextFieldLoadingAnimationInterval;
  Interval _textButtonLoadingAnimationInterval;
  Animation<double> _buttonScaleAnimation;

  bool get buttonEnabled => !_isLoading && !_isSubmitting;
  int serviceTypeId = 0;
  int durationTypeId = 0;
  bool isDurational = false;
  bool isBoth = false;

  var _valueCarServiceType;
  var _valueDurationType;

  List<ServiceType> serviceTypes = new List();

  var durationTypes = [
    {
      'Title': Constants.SERVICE_DURATION_YEAR_TITLE,
      'Id': Constants.SERVICE_DURATION_YEAR,
    },
    {
      'Title': Constants.SERVICE_DURATION_MONTH_TITLE,
      'Id': Constants.SERVICE_DURATION_MONTH,
    },
    {
      'Title': Constants.SERVICE_DURATION_DAY_TITLE,
      'Id': Constants.SERVICE_DURATION_DAY,
    }
  ];

  var serviceTypes2 = [
    {
      'Title': Constants.SERVICE_TYPE_FUNCTIONALITY_TITLE,
      'Id': Constants.SERVICE_TYPE_FUNCTIONALITY,
    },
    {
      'Title': Constants.SERVICE_TYPE_DURATIONALITY_TITLE,
      'Id': Constants.SERVICE_TYPE_DURATIONALITY,
    },
    {
      'Title': Constants.SERVICE_TYPE_BOTH_TITLE,
      'Id': Constants.SERVICE_TYPE_BOTH,
    }
  ];

  @override
  void initState() {
    _valueCarServiceType = serviceTypes2[0];
    // _valueDurationType=durationTypes[0];

    _authData['serviceTypeConstId'] =
        _valueCarServiceType != null ? _valueCarServiceType['Id'] : '0';

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

    bool editMode = widget.isEditMode;
    if (editMode == null) editMode = false;

    if (editMode) {
      _authData['serviceTypeId'] = widget.serviceType.ServiceTypeId.toString();

      String sTitle = widget.serviceType.ServiceTypeTitle.toString();
      if (sTitle == null || sTitle.isEmpty || sTitle == 'null') {
        sTitle = '';
      }
      if (sTitle != null) {
        _serviceTitleController.value = _serviceTitleController.value.copyWith(
          text: sTitle,
          selection: TextSelection(
              baseOffset: sTitle.length, extentOffset: sTitle.length),
          composing: TextRange.empty,
        );
      }

      String alrCount = widget.serviceType.AlarmCount.toString();
      if (alrCount == null || alrCount.isEmpty || alrCount == 'null') {
        alrCount = '0';
      }
      if (alrCount != null) {
        _alarmCountController.value = _alarmCountController.value.copyWith(
          text: alrCount,
          selection: TextSelection(
              baseOffset: alrCount.length, extentOffset: alrCount.length),
          composing: TextRange.empty,
        );
      }

      String durationCount = widget.serviceType.DurationCountValue.toString();
      if (durationCount == null ||
          durationCount.isEmpty ||
          durationCount == 'null') {
        durationCount = '0';
      }

      if (durationCount != null) {
        _durationCountValueController.value =
            _durationCountValueController.value.copyWith(
          text: durationCount,
          selection: TextSelection(
              baseOffset: durationCount.length,
              extentOffset: durationCount.length),
          composing: TextRange.empty,
        );
      }

      String durationValue = widget.serviceType.DurationValue.toString();
      durationValue = dh.DartHelper.isNullOrEmptyString(durationValue);
      if (durationValue != null) {
        _durationController.value = _durationController.value.copyWith(
          text: durationValue,
          selection: TextSelection(
              baseOffset: durationValue.length,
              extentOffset: durationValue.length),
          composing: TextRange.empty,
        );
      }

      String alrmDurationDay = widget.serviceType.AlarmDurationDay.toString();
      alrmDurationDay = dh.DartHelper.isNullOrEmptyString(alrmDurationDay);
      if (alrmDurationDay != null) {
        _alarmDurationDayController.value =
            _alarmDurationDayController.value.copyWith(
          text: alrmDurationDay,
          selection: TextSelection(
              baseOffset: alrmDurationDay.length,
              extentOffset: alrmDurationDay.length),
          composing: TextRange.empty,
        );
      }

      String desc = widget.serviceType.Description.toString();
      desc = dh.DartHelper.isNullOrEmptyString(desc);
      if (desc != null) {
        _descriptionController.value = _descriptionController.value.copyWith(
          text: desc,
          selection:
              TextSelection(baseOffset: desc.length, extentOffset: desc.length),
          composing: TextRange.empty,
        );
      }

      String valueDurationTypeConstId =
          widget.serviceType.DurationTypeConstId != null &&
                  widget.serviceType.DurationTypeConstId > 0
              ? widget.serviceType.DurationTypeConstId.toString()
              : '0';
      if (widget.serviceType.DurationTypeConstId != null &&
          widget.serviceType.DurationTypeConstId > 0) {
        _valueDurationType = durationTypes
            .where((d) =>
                d.values.contains(widget.serviceType.DurationTypeConstId))
            .toList()
            .first;
      } else {
        _valueDurationType = durationTypes[0];
      }

      String serviceTypeConstId =
          widget.serviceType.ServiceTypeConstId != null &&
                  widget.serviceType.ServiceTypeConstId > 0
              ? widget.serviceType.ServiceTypeConstId.toString()
              : '0';
      if (widget.serviceType.ServiceTypeConstId != null &&
          widget.serviceType.ServiceTypeConstId > 0) {
        _valueCarServiceType = serviceTypes2
            .where(
                (s) => s.containsValue(widget.serviceType.ServiceTypeConstId))
            .toList()
            .first;
      } else {
        _valueCarServiceType = serviceTypes2[0];
      }

      isDurational =
          _valueCarServiceType['Id'] == Constants.SERVICE_TYPE_DURATIONALITY;
      isBoth = _valueCarServiceType['Id'] == Constants.SERVICE_TYPE_BOTH;
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
    _alarmDurationDayFocusNode.dispose();
    _alarmCountFocusNode.dispose();
    _distanceFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _durationCountValueFocusNode.dispose();
    _durationValueFocusNode.dispose();
    _serviceTypeTitleFocusNode.dispose();
    _serviceTypeCodeFocusNode.dispose();
    _switchAuthController.dispose();
    _postSwitchAuthController.dispose();
    _submitController.dispose();
    _alarmCountController.dispose();
    _distanceController.dispose();
    _descriptionController.dispose();
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
      error = await auth.onConfirm(CarServiceTypeData(
        alarmCount: _authData['alarmCount'],
        description: _authData['description'],
        alarmDurationDay: int.tryParse((_authData['alarmDurationDay'] != null &&
                _authData['alarmDurationDay'].toString().isNotEmpty)
            ? _authData['alarmDurationDay']
            : '0'),
        automationInsert: _authData['automationInsert'],
        durationCountValue: int.tryParse(
            (_authData['durationCountValue'] != null &&
                    _authData['durationCountValue'].toString().isNotEmpty)
                ? _authData['durationCountValue']
                : '0'),
        durationType: int.tryParse((_authData['durationTypeId'] != null &&
                _authData['durationTypeId'] != null.toString().isNotEmpty)
            ? _authData['durationTypeId']
            : '0'),
        durationValue: int.tryParse((_authData['durationValue'] != null &&
                _authData['durationValue'].toString().isNotEmpty)
            ? _authData['durationValue']
            : '0'),
        serviceType: int.tryParse(_authData['serviceTypeId']),
        serviceTypeCode: _authData['serviceTypeCode'],
        serviceTypeTitle: _authData['serviceTypeTitle'],
        durationTypeConstId: int.tryParse(
            (_authData['durationTypeId'] != null &&
                    _authData['durationTypeId'] != null.toString().isNotEmpty)
                ? _authData['durationTypeId']
                : '0'),
        serviceTypeConstId: int.tryParse(_authData['serviceTypeConstId'] != null
            ? _authData['serviceTypeConstId'].toString()
            : '0'),
        cancel: false,
      ));
    } else {
      error = await auth.onCancel(CarServiceTypeData(
        serviceTypeTitle: '',
        serviceType: 0,
        durationValue: 0,
        durationType: 0,
        durationCountValue: 0,
        alarmDurationDay: 0,
        description: '',
        alarmCount: '',
        automationInsert: false,
        serviceTypeCode: '',
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

  Widget _buildServiceTypeCodeField(
      double width, CarServiceTypeMessages messages) {
    final auth = Provider.of<Auth>(context);
    return AnimatedTextFormField(
      width: width,
      controller: _serviceCodeController,
      // inputFormatters: [ maskPelakFormatter],
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.serviceTypeCodeHint,
      prefixIcon: Icon(Icons.code),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (auth.isConfirm) {
          _submit();
        } else
          FocusScope.of(context).requestFocus(_serviceTypeCodeFocusNode);
      },
      validator: (value) {
        // if (auth.isConfirm) widget.fieldValidator;

        return null;
      },
      onSaved: (value) => _authData['serviceTypeCode'] = value,
    );
  }

  Widget _buildServiceTypesField(
      double width, CarServiceTypeMessages messages, int modelId) {
    if (widget.isEditMode != null && widget.isEditMode) {
      // int serviceTypeConstId =
      //     widget.serviceType.ServiceTypeConstId != null &&
      //             widget.serviceType.ServiceTypeConstId > 0
      //         ? widget.serviceType.ServiceTypeConstId
      //         : 0;
      // if (serviceTypeConstId != null && serviceTypeConstId>0) {
      //   _valueCarServiceType = serviceTypes2
      //       .where((s) => s["Id"] == serviceTypeConstId)
      //       .toList()
      //       .first;
      // }
      // isDurational =
      //     _valueCarServiceType['Id'] == Constants.SERVICE_TYPE_DURATIONALITY;
      // isBoth = _valueCarServiceType['Id'] == Constants.SERVICE_TYPE_BOTH;
    }
    return FormBuilderCustomField(
      initialValue: _valueCarServiceType,
      attribute: "Title",
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
          enabled: true,
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: "لطفا نوع سرویس را انتخاب کنید",
                errorText: field.errorText,
                contentPadding: EdgeInsets.only(
                    top: 10.0, bottom: 0.0, right: 10.0, left: 10.0),
                border: InputBorder.none,
              ),
              child: DropdownButton(
                isExpanded: true,
                items: serviceTypes2.map((md) {
                  return DropdownMenuItem(
                    child: Text(md['Title']),
                    value: md,
                  );
                }).toList(),
                value: _valueCarServiceType,
                onChanged: (value) {
                  setState(() {
                    _valueCarServiceType = value;
                    _authData['serviceTypeConstId'] = value['Id'].toString();
                    isDurational =
                        value['Id'] == Constants.SERVICE_TYPE_DURATIONALITY;
                    isBoth = value['Id'] == Constants.SERVICE_TYPE_BOTH;
                    if (isDurational) {
                      _valueDurationType = durationTypes[0];
                    }
                  });
                  //field.didChange(_valueCarModelDetail);
                },
              ),
            );
          }),
    );
  }

  Widget _buildDurationTypesField(
      double width, CarServiceTypeMessages messages, int typeId) {
    if (widget.isEditMode != null && widget.isEditMode) {
      // int valueDurationTypeConstId =
      //     widget.serviceType.DurationTypeConstId != null &&
      //             widget.serviceType.DurationTypeConstId > 0
      //         ? widget.serviceType.DurationTypeConstId
      //         : 0;
      // if (valueDurationTypeConstId != null &&
      //     valueDurationTypeConstId>0) {
      //   _valueDurationType = durationTypes
      //       .where((d) => d.values.contains( valueDurationTypeConstId))
      //       .toList()
      //       .first;
      // } else {
      //   _valueDurationType = durationTypes[0];
      // }
    }
    return FormBuilderCustomField(
      initialValue: _valueDurationType,
      attribute: "Title",
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
          enabled: true,
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: "لطفا نوع زمانی را انتخاب کنید",
                errorText: field.errorText,
                contentPadding: EdgeInsets.only(
                    top: 10.0, bottom: 0.0, right: 10.0, left: 10.0),
                border: InputBorder.none,
              ),
              child: DropdownButton(
                isExpanded: true,
                items: durationTypes.map((md) {
                  return DropdownMenuItem(
                    child: Text(md['Title']),
                    value: md,
                  );
                }).toList(),
                value: _valueDurationType,
                onChanged: (value) {
                  setState(() {
                    _valueDurationType = value;
                    _authData['durationTypeId'] = value['Id'].toString();
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

  Widget _buildServiceTypeTitleField(
      double width, CarServiceTypeMessages messages) {
    final auth = Provider.of<Auth>(context);
    if (widget.isEditMode != null && widget.isEditMode) {
      // String sTitle = widget.serviceType.ServiceTypeTitle.toString();
      // if (sTitle == null || sTitle.isEmpty || sTitle == 'null') {
      //   sTitle = '';
      // }
      // if (sTitle != null) {
      //   _serviceTitleController.value = _serviceTitleController.value.copyWith(
      //     text: sTitle,
      //     selection: TextSelection(
      //         baseOffset: sTitle.length, extentOffset: sTitle.length),
      //     composing: TextRange.empty,
      //   );
      // }
    }
    return AnimatedTextFormField(
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.serviceTypeTitleHint,
      controller: _serviceTitleController,
      //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.text,
      prefixIcon: Icon(Icons.title),
      textInputAction:
          auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _distanceFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: (value) {
        // if (auth.isConfirm) widget.fieldValidator;
        return null;
      },
      onSaved: (value) => _authData['serviceTypeTitle'] = value,
    );
  }

  Widget _buildDurationValueField(
      double width, CarServiceTypeMessages messages) {
    final auth = Provider.of<Auth>(context);
    if (widget.isEditMode != null && widget.isEditMode) {
      // String durationValue = widget.serviceType.DurationValue.toString();
      // durationValue = dh.DartHelper.isNullOrEmptyString(durationValue);
      // if (durationValue != null) {
      //   _durationController.value = _durationController.value.copyWith(
      //     text: durationValue,
      //     selection: TextSelection(
      //         baseOffset: durationValue.length,
      //         extentOffset: durationValue.length),
      //     composing: TextRange.empty,
      //   );
      // }
    }
    return AnimatedTextFormField(
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: isDurational
          ? messages.durationValueHint
          : Translations.current.durationFunctionalValue(),
      controller: _durationController,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      prefixIcon: Icon(Icons.confirmation_number),
      textInputAction:
          auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _durationValueFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: (value) {
        if (isDurational) {
          // if (auth.isConfirm) widget.fieldValidator;
        }
        return null;
      },
      onSaved: (value) => _authData['durationValue'] = value,
    );
  }

  Widget _buildDurationCountValueField(
      double width, CarServiceTypeMessages messages) {
    final auth = Provider.of<Auth>(context);
    if (widget.isEditMode != null && widget.isEditMode) {
      // String durationCount = widget.serviceType.DurationCountValue.toString();
      // if (durationCount == null ||
      //     durationCount.isEmpty ||
      //     durationCount == 'null') {
      //   durationCount = '0';
      // }

      // if (durationCount != null) {
      //   _durationCountValueController.value =
      //       _durationCountValueController.value.copyWith(
      //     text: durationCount,
      //     selection: TextSelection(
      //         baseOffset: durationCount.length,
      //         extentOffset: durationCount.length),
      //     composing: TextRange.empty,
      //   );
      // }
    }
    return AnimatedTextFormField(
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: isDurational
          ? messages.durationCountValueHint
          : Translations.current.durationFunctionalCountValue(),
      controller: _durationCountValueController,
      //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      prefixIcon: Icon(Icons.confirmation_number),
      textInputAction:
          auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _durationCountValueFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: (value) {
        if (isDurational) {
          // if (auth.isConfirm) widget.fieldValidator;
        }
        return null;
      },
      onSaved: (value) => _authData['durationCountValue'] = value,
    );
  }

  Widget _buildAlarmDurationDayField(
      double width, CarServiceTypeMessages messages) {
    final auth = Provider.of<Auth>(context);
    if (widget.isEditMode != null && widget.isEditMode) {
      // String alrmDurationDay = widget.serviceType.AlarmDurationDay.toString();
      // alrmDurationDay = dh.DartHelper.isNullOrEmptyString(alrmDurationDay);
      // if (alrmDurationDay != null) {
      //   _alarmDurationDayController.value =
      //       _alarmDurationDayController.value.copyWith(
      //     text: alrmDurationDay,
      //     selection: TextSelection(
      //         baseOffset: alrmDurationDay.length,
      //         extentOffset: alrmDurationDay.length),
      //     composing: TextRange.empty,
      //   );
      // }
    }
    return AnimatedTextFormField(
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.alarmDurationDayHint,
      controller: _alarmDurationDayController,
      //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      prefixIcon: Icon(Icons.confirmation_number),
      textInputAction:
          auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _alarmDurationDayFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: (value) {
        if (isDurational) {
          // if (auth.isConfirm) widget.fieldValidator;
        }
        return null;
      },
      onSaved: (value) => _authData['alarmDurationDay'] = value,
    );
  }

  Widget _buildAlarmCountField(double width, CarServiceTypeMessages messages) {
    final auth = Provider.of<Auth>(context);
    if (widget.isEditMode != null && widget.isEditMode) {
      // String alrCount = widget.serviceType.AlarmCount.toString();
      // if (alrCount == null || alrCount.isEmpty || alrCount == 'null') {
      //   alrCount = '0';
      // }
      // if (alrCount != null) {
      //   _alarmCountController.value = _alarmCountController.value.copyWith(
      //     text: alrCount,
      //     selection: TextSelection(
      //         baseOffset: alrCount.length, extentOffset: alrCount.length),
      //     composing: TextRange.empty,
      //   );
      // }
    }
    return AnimatedTextFormField(
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.alarmCountHint,
      controller: _alarmCountController,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      prefixIcon: Icon(Icons.confirmation_number),
      textInputAction:
          auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _alarmCountFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        //FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      validator: (value) {
        if (!isDurational) {
          // if (auth.isConfirm) widget.fieldValidator;
        }
        return null;
      },
      onSaved: (value) => _authData['alarmCount'] = value,
    );
  }

  Widget _buildDescriptionField(double width, CarServiceTypeMessages messages) {
    final auth = Provider.of<Auth>(context);
    if (widget.isEditMode != null && widget.isEditMode) {
      // String desc = widget.serviceType.Description.toString();
      // desc = dh.DartHelper.isNullOrEmptyString(desc);
      // if (desc != null) {
      //   _descriptionController.value = _descriptionController.value.copyWith(
      //     text: desc,
      //     selection:
      //         TextSelection(baseOffset: desc.length, extentOffset: desc.length),
      //     composing: TextRange.empty,
      //   );
      // }
    }
    return AnimatedTextFormField(
      enabled: true,
      width: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.descriptionHint,
      controller: _descriptionController,
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

  Widget _buildAutoInsertField(double width, CarServiceTypeMessages message) {
    return Container(
      child: SwitchListTile(
        value: true,
        title: Text(message.automationInsertHint),
        selected: true,
        onChanged: (value) {
          setState(() {
            _authData['automationInsert'] = value;
          });
          //field.didChange(_valueCarModelDetail);
        },
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme, CarServiceTypeMessages messages) {
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

  Widget _buildSwitchAuthButton(
      ThemeData theme, CarServiceTypeMessages messages) {
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
    final messages =
        Provider.of<CarServiceTypeMessages>(context, listen: false);
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
              left: cardPadding + 5,
              right: cardPadding + 5,
              top: cardPadding + 0,
            ),
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildServiceTypeTitleField(textFieldWidth, messages),
                SizedBox(height: 5),
                /* _buildServiceTypeCodeField(textFieldWidth, messages),
                SizedBox(height: 5),*/
                _buildServiceTypesField(textFieldWidth, messages, 0),
                SizedBox(height: 5),
                (isDurational || isBoth)
                    ? _buildDurationTypesField(textFieldWidth, messages, 0)
                    : Container(
                        width: 0.0,
                        height: 0.0,
                      ),
                SizedBox(height: 5),
                (isDurational || isBoth)
                    ? _buildDurationValueField(textFieldWidth, messages)
                    : Container(),
                SizedBox(height: 5),
                !isDurational
                    ? _buildDurationCountValueField(textFieldWidth, messages)
                    : Container(),
                SizedBox(height: 5),
                !isDurational
                    ? _buildAlarmCountField(textFieldWidth, messages)
                    : Container(),
                SizedBox(height: 5),
                (isDurational || isBoth)
                    ? _buildAlarmDurationDayField(textFieldWidth, messages)
                    : Container(),
                SizedBox(height: 5),
                _buildAutoInsertField(textFieldWidth, messages),
                SizedBox(height: 5),
                _buildDescriptionField(textFieldWidth, messages)
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
                    child: _buildDescriptionField(textFieldWidth, messages),
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
    final messages =
        Provider.of<CarServiceTypeMessages>(context, listen: false);

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

  Widget _buildRecoverNameField(double width, CarServiceTypeMessages messages) {
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

  Widget _buildRecoverButton(ThemeData theme, CarServiceTypeMessages messages) {
    return AnimatedButton(
      controller: _submitController,
      text: '',
      onPressed: !_isSubmitting ? _submit : null,
    );
  }

  Widget _buildBackButton(ThemeData theme, CarServiceTypeMessages messages) {
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
    final messages =
        Provider.of<CarServiceTypeMessages>(context, listen: false);
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
