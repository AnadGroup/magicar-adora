import 'dart:async';

import 'package:anad_magicar/i10n/anad_messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Translations {
  Translations() {}
  Translations._() {
    current = this;
  }
  static Translations current;
  static Future<Translations> load(Locale locale) {
    final String name =
        (locale.countryCode != null && locale.countryCode.isEmpty)
            ? locale.languageCode
            : locale.toString();
    Translations._();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((dynamic _) {
      Intl.defaultLocale = localeName;
      return new Translations();
    });
  }

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  /* static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Healthy Style',
    },
    'fa': {
      'title': 'Healthy Style',
    },
  };*/

  String confirm() =>
      Intl.message('confirm', name: 'confirm', desc: 'Confirm Security Code');
  String register() =>
      Intl.message('register', name: 'register', desc: 'register');
  String securitycode() =>
      Intl.message('securitycode', name: 'securitycode', desc: 'securitycode');
  String help() => Intl.message('help', name: 'help', desc: 'Help');
  String search() => Intl.message('search', name: 'search', desc: 'search');
  String support() => Intl.message('support', name: 'support', desc: 'support');
  String login() => Intl.message('login', name: 'login', desc: 'login');
  String exit() => Intl.message('exit', name: 'exit', desc: 'exit');

  String basket() => Intl.message('basket', name: 'basket', desc: 'basket');
  String userName() =>
      Intl.message('userName', name: 'userName', desc: 'userName');
  String home() => Intl.message('home', name: 'home', desc: 'home');
  String mobile() => Intl.message('mobile', name: 'mobile', desc: 'mobile');
  String phone() => Intl.message('phone', name: 'phone', desc: 'phone');
  String address() => Intl.message('address', name: 'address', desc: 'address');
  String firstName() =>
      Intl.message('firstName', name: 'firstName', desc: 'firstName');
  String lastName() =>
      Intl.message('lastName', name: 'lastName', desc: 'lastName');
  String age() => Intl.message('age', name: 'age', desc: 'age');
  String userinfo() =>
      Intl.message('userinfo', name: 'userinfo', desc: 'userinfo');
  String deviceinfo() =>
      Intl.message('deviceinfo', name: 'deviceinfo', desc: 'deviceinfo');
  String cartype() => Intl.message('cartype', name: 'cartype', desc: 'cartype');
  String carcolor() =>
      Intl.message('carcolor', name: 'carcolor', desc: 'carcolor');
  String carfunction() =>
      Intl.message('carfunction', name: 'carfunction', desc: 'carfunction');
  String caryear() => Intl.message('caryear', name: 'caryear', desc: 'caryear');
  String carmodel() =>
      Intl.message('carmodel', name: 'carmodel', desc: 'carmodel');
  String carbtitle() =>
      Intl.message('carbtitle', name: 'carbtitle', desc: 'carbtitle');
  String devicemobile() =>
      Intl.message('devicemobile', name: 'devicemobile', desc: 'devicemobile');
  String password() =>
      Intl.message('password', name: 'password', desc: 'password');
  String imei() => Intl.message('imei', name: 'imei', desc: 'imei');
  String simcartno() =>
      Intl.message('simcartno', name: 'simcartno', desc: 'simcartno');
  String settings() =>
      Intl.message('settings', name: 'settings', desc: 'settings');
  String on() => Intl.message('ON', name: 'on', desc: 'on');
  String off() => Intl.message('OFF', name: 'off', desc: 'off');
  String mobilename() =>
      Intl.message('mobilename', name: 'mobilename', desc: 'mobilename');
  String pattern() => Intl.message('pattern', name: 'pattern', desc: 'pattern');
  String admin() => Intl.message('admin', name: 'admin', desc: 'admin');
  String edit() => Intl.message('edit', name: 'edit', desc: 'edit');
  String carbrand() =>
      Intl.message('carbrand', name: 'carbrand', desc: 'carbrand');
  String carpelak() =>
      Intl.message('carpelak', name: 'carpelak', desc: 'carpelak');
  String loadingdata() =>
      Intl.message('loadingdata', name: 'loadingdata', desc: 'loadingdata');
  String confirmrecievecode() => Intl.message('confirmrecievecode',
      name: 'confirmrecievecode', desc: 'confirmrecievecode');
  String send() => Intl.message('send', name: 'send', desc: 'send');
  String noimage() => Intl.message('noimage', name: 'noimage', desc: 'noimage');
  String dataloaded() =>
      Intl.message('dataloaded', name: 'dataloaded', desc: 'dataloaded');
  String email() => Intl.message('email', name: 'email', desc: 'email');
  String profile() => Intl.message('profile', name: 'profile', desc: 'profile');
  String authToAccess() =>
      Intl.message('authToAccess', name: 'authToAccess', desc: 'authToAccess');
  String car() => Intl.message('car', name: 'car', desc: 'car');
  String security() =>
      Intl.message('security', name: 'security', desc: 'security');
  String pleaseEnterFirstName() => Intl.message('pleaseEnterFirstName',
      name: 'pleaseEnterFirstName', desc: 'pleaseEnterFirstName');
  String pleaseEnterMobile() => Intl.message('pleaseEnterMobile',
      name: 'pleaseEnterMobile', desc: 'pleaseEnterMobile');
  String pleaseEnterPassword() => Intl.message('pleaseEnterPassword',
      name: 'pleaseEnterPassword', desc: 'pleaseEnterPassword');
  String profilePic() =>
      Intl.message('profilePic', name: 'profilePic', desc: 'profilePic');
  String pleaseEnterLastName() => Intl.message('pleaseEnterLastName',
      name: 'pleaseEnterLastName', desc: 'pleaseEnterLastName');
  String serialNumber() =>
      Intl.message('serialNumber', name: 'serialNumber', desc: 'serialNumber');
  String pleaseEnterSimNumber() => Intl.message('pleaseEnterSimNumber',
      name: 'pleaseEnterSimNumber', desc: 'pleaseEnterSimNumber');
  String simNumber() =>
      Intl.message('simNumber', name: 'simNumber', desc: 'simNumber');
  String reTypePassword() => Intl.message('reTypePassword',
      name: 'reTypePassword', desc: 'reTypePassword');
  String addCar() => Intl.message('addCar', name: 'addCar', desc: 'addCar');
  String skip() => Intl.message('skip', name: 'skip', desc: 'skip');

  String addCarFormTitle() => Intl.message('addCarFormTitle',
      name: 'addCarFormTitle', desc: 'addCarFormTitle');
  String hasErrors() =>
      Intl.message('hasErrors', name: 'hasErrors', desc: 'hasErrors');
  String thisFormHasErrors() => Intl.message('thisFormHasErrors',
      name: 'thisFormHasErrors', desc: 'thisFormHasErrors');
  String doYouRealyWantToExit() => Intl.message('doYouRealyWantToExit',
      name: 'doYouRealyWantToExit', desc: 'doYouRealyWantToExit');
  String yes() => Intl.message('Yes', name: 'yes', desc: 'yes');
  String no() => Intl.message('No', name: 'no', desc: 'no');
  String magicarTitle() =>
      Intl.message('MAGICAR', name: 'magicarTitle', desc: 'magicarTitle');
  String areYouSureToExit() => Intl.message('Are You Sure To Exit',
      name: 'areYouSureToExit', desc: 'areYouSureToExit');
  String noFingerPrintSupport() => Intl.message('No Finger Print Support!',
      name: 'noFingerPrintSupport', desc: 'noFingerPrintSupport');

  String fingerPrintHint() => Intl.message('fingerPrintHint',
      name: 'fingerPrintHint', desc: 'fingerPrintHint');
  String fingerprintNotRecognized() => Intl.message('fingerprintNotRecognized',
      name: 'fingerprintNotRecognized', desc: 'fingerprintNotRecognized');
  String fingerprintSuccess() => Intl.message('fingerprintSuccess',
      name: 'fingerprintSuccess', desc: 'fingerprintSuccess');
  String cancel() => Intl.message('cancel', name: 'cancel', desc: 'cancel');
  String signInTitle() =>
      Intl.message('signInTitle', name: 'signInTitle', desc: 'signInTitle');
  String fingerprintRequiredTitle() => Intl.message('fingerprintRequiredTitle',
      name: 'fingerprintRequiredTitle', desc: 'fingerprintRequiredTitle');
  String goToSettingsButton() => Intl.message('goToSettingsButton',
      name: 'goToSettingsButton', desc: 'goToSettingsButton');
  String goToSettingsDescription() => Intl.message('goToSettingsDescription',
      name: 'goToSettingsDescription', desc: 'goToSettingsDescription');
  String lockOut() => Intl.message('lockOut', name: 'lockOut', desc: 'lockOut');
  String enable() => Intl.message('enable', name: 'enable', desc: 'enable');
  String disable() => Intl.message('disable', name: 'disable', desc: 'disable');
  String engineStart() =>
      Intl.message('Start', name: 'engineStart', desc: 'engineStart');
  String darkTheme() =>
      Intl.message('Dark', name: 'darkTheme', desc: 'darkTheme');
  String lightTheme() =>
      Intl.message('Light', name: 'lightTheme', desc: 'lightTheme');
  String appTheme() =>
      Intl.message('Current App Theme', name: 'appTheme', desc: 'appTheme');
  String withLogin() =>
      Intl.message('Enter with Login', name: 'withLogin', desc: 'withLogin');
  String noLogin() =>
      Intl.message('Enter with no Login', name: 'noLogin', desc: 'noLogin');
  String withFinger() => Intl.message('Enter wtih Finger Print',
      name: 'withFinger', desc: 'withFinger');
  String withPassword() => Intl.message('Enter wtih Password',
      name: 'withPassword', desc: 'withPassword');
  String withPattern() => Intl.message('Enetr with Pattern',
      name: 'withPattern', desc: 'withPattern');
  String statusLogin() =>
      Intl.message('Login Type', name: 'statusLogin', desc: 'statusLogin');
  String carsNo() =>
      Intl.message('Cars Counts', name: 'carsNo', desc: 'carsNo');
  String counts() =>
      Intl.message('Cars Counts', name: 'counts', desc: 'counts');
  String allLoginFieldsRequired() => Intl.message('All Login Fields Required',
      name: 'allLoginFieldsRequired', desc: 'allLoginFieldsRequired');
  String goBack() => Intl.message('Back', name: 'goBack', desc: 'goBack');
  String forgotPassword() => Intl.message('Forgot Password',
      name: 'forgotPassword', desc: 'forgotPassword');
  String recoverPassword() => Intl.message('Recover Password',
      name: 'recoverPassword', desc: 'recoverPassword');
  String confirmSecurityCode() => Intl.message('Confirm Security Code',
      name: 'confirmSecurityCode', desc: 'confirmSecurityCode');
  String distance() =>
      Intl.message('Distance', name: 'distance', desc: 'distance');
  String carTip() => Intl.message('Car Tip', name: 'carTip', desc: 'carTip');
  String inLoadingApp() => Intl.message('Loading App...',
      name: 'inLoadingApp', desc: 'inLoadingApp');
  String noConnection() => Intl.message('No Connection...',
      name: 'noConnection', desc: 'noConnection');
  String description() =>
      Intl.message('Description', name: 'description', desc: 'description');
  String errorFetchData() => Intl.message('Error while fetching data',
      name: 'errorFetchData', desc: 'errorFetchData');
  String users() => Intl.message('Users', name: 'users', desc: 'users');
  String noDatatoShow() => Intl.message('No Data to Show',
      name: 'noDatatoShow', desc: 'noDatatoShow');
  String useLogin() =>
      Intl.message('Use Login', name: 'useLogin', desc: 'useLogin');
  String usePassword() =>
      Intl.message('Use Password', name: 'usePassword', desc: 'usePassword');
  String useFingerPrint() => Intl.message('Use FingerPrint',
      name: 'useFingerPrint', desc: 'useFingerPrint');
  String usePattern() =>
      Intl.message('Use Pattern', name: 'usePattern', desc: 'usePattern');
  String resetPassword() => Intl.message('Reset Password',
      name: 'resetPassword', desc: 'resetPassword');
  String currentPlan() =>
      Intl.message('Current Plan', name: 'currentPlan', desc: 'currentPlan');
  String planCode() =>
      Intl.message('Plan Code', name: 'planCode', desc: 'planCode');
  String planTitle() =>
      Intl.message('Plan Title', name: 'planTitle', desc: 'planTitle');
  String invoiceDate() =>
      Intl.message('Invoice Date', name: 'invoiceDate', desc: 'invoiceDate');
  String startDate() =>
      Intl.message('Start Date', name: 'startDate', desc: 'startDate');
  String endDate() =>
      Intl.message('End Date', name: 'endDate', desc: 'endDate');
  String active() => Intl.message('Active', name: 'active', desc: 'active');
  String deactive() =>
      Intl.message('Deactive', name: 'deactive', desc: 'deactive');
  String planStatus() =>
      Intl.message('Plan Status', name: 'planStatus', desc: 'planStatus');
  String planType() =>
      Intl.message('Plan Type', name: 'planType', desc: 'planType');
  String errorInUIs() => Intl.message('Error in Null Widget...',
      name: 'errorInUIs', desc: 'errorInUIs');
  String errorInUIsDescription() =>
      Intl.message('Error in Widget! Null Widget...',
          name: 'errorInUIsDescription', desc: 'errorInUIsDescription');
  String reportModeTitle() => Intl.message('Report Problems us',
      name: 'reportModeTitle', desc: 'reportModeTitle');
  String plans() => Intl.message('Plans', name: 'plans', desc: 'plans');
  String pleaseEnterSecurityCode() => Intl.message('Please Enter Recieved Code',
      name: 'pleaseEnterSecurityCode', desc: 'pleaseEnterSecurityCode');
  String notValidSecurityCode() => Intl.message('SecurityCode is not Valid',
      name: 'notValidSecurityCode', desc: 'notValidSecurityCode');
  String plzEnterRecievedSecurityCode() =>
      Intl.message('Enter Recieved SecurityCode',
          name: 'plzEnterRecievedSecurityCode',
          desc: 'plzEnterRecievedSecurityCode');
  String userCounts() =>
      Intl.message('User Counts', name: 'userCounts', desc: 'userCounts');
  String resendSecurityCode() => Intl.message('Resend Code',
      name: 'resendSecurityCode', desc: 'resendSecurityCode');
  String fromDate() =>
      Intl.message('From Date', name: 'fromDate', desc: 'fromDate');
  String cars() => Intl.message('Cars', name: 'cars', desc: 'cars');
  String resetPasswordSuccessful() => Intl.message('Reset Password Successful',
      name: 'resetPasswordSuccessful', desc: 'resetPasswordSuccessful');
  String resetPasswordUnSuccessful() =>
      Intl.message('Reset Password UnSuccessful',
          name: 'resetPasswordUnSuccessful', desc: 'resetPasswordUnSuccessful');
  String sendingCommand() =>
      Intl.message('Sending', name: 'sendingCommand', desc: 'sendingCommand');
  String sentCommand() =>
      Intl.message('Sent', name: 'sentCommand', desc: 'sentCommand');
  String sentCommandHasError() => Intl.message('Error',
      name: 'sentCommandHasError', desc: 'sentCommandHasError');
  String hasFinger() => Intl.message('Device has FingerPrint',
      name: 'hasFinger', desc: 'hasFinger');
  String noFinger() => Intl.message('Device does not Support FingerPrint',
      name: 'noFinger', desc: 'noFinger');
  String loginWithPassword() => Intl.message('Login With Password',
      name: 'loginWithPassword', desc: 'loginWithPassword');
  String authorizedSuccessfull() => Intl.message('Authorized Successfull',
      name: 'authorizedSuccessfull', desc: 'authorizedSuccessfull');
  String authorizedFaild() => Intl.message('Authorized Faild',
      name: 'authorizedFaild', desc: 'authorizedFaild');
  String authorized() =>
      Intl.message('Authorized', name: 'authorized', desc: 'authorized');
  String notAuthorized() => Intl.message('Not Authorized',
      name: 'notAuthorized', desc: 'notAuthorized');
  String deviceNotAvailable() => Intl.message('Device Not Available',
      name: 'deviceNotAvailable', desc: 'deviceNotAvailable');
  String registerSuccessful() => Intl.message('Register Successful',
      name: 'registerSuccessful', desc: 'registerSuccessful');
  String noCarExist() =>
      Intl.message('No Car Exist', name: 'noCarExist', desc: 'noCarExist');
  String searchCar() =>
      Intl.message('Search Car', name: 'searchCar', desc: 'searchCar');
  String currentPassword() => Intl.message('Current Password',
      name: 'currentPassword', desc: 'currentPassword');
  String plzWaiting() =>
      Intl.message('Please Wait...', name: 'plzWaiting', desc: 'plzWaiting');
  String toDate() => Intl.message('To Date', name: 'toDate', desc: 'toDate');
  String planCost() =>
      Intl.message('Plan Cost', name: 'planCost', desc: 'planCost');
  String buyPlan() =>
      Intl.message('Buy Plan', name: 'buyPlan', desc: 'buyPlan');
  String invoiceAmount() => Intl.message('Invoice Amount',
      name: 'invoiceAmount', desc: 'invoiceAmount');
  String carId() => Intl.message('Car ID', name: 'carId', desc: 'carId');
  String plzSelectDeviceModel() => Intl.message('Please Select Device Model',
      name: 'plzSelectDeviceModel', desc: 'plzSelectDeviceModel');
  String accessToActions() => Intl.message('Access To Actions',
      name: 'accessToActions', desc: 'accessToActions');
  String confirmCarSuccessful() => Intl.message('Confirm Car Successful',
      name: 'confirmCarSuccessful', desc: 'confirmCarSuccessful');
  String actionsCounts() => Intl.message('Actions Counts',
      name: 'actionsCounts', desc: 'actionsCounts');
  String plzSelectNewRole() => Intl.message('Please Select New Role',
      name: 'plzSelectNewRole', desc: 'plzSelectNewRole');
  String roleTitle() =>
      Intl.message('Role Title', name: 'roleTitle', desc: 'roleTitle');
  String changeRoleSuccessful() => Intl.message('Change Role Successful',
      name: 'changeRoleSuccessful', desc: 'changeRoleSuccessful');
  String changeRoleUnSuccessful() => Intl.message('Change Role UnSuccessful',
      name: 'changeRoleUnSuccessful', desc: 'changeRoleUnSuccessful');
  String rolesTitle() =>
      Intl.message('Roles', name: 'rolesTitle', desc: 'rolesTitle');
  String buyPlanSuccessful() => Intl.message('Buy Plan Successful',
      name: 'buyPlanSuccessful', desc: 'buyPlanSuccessful');
  String buyPlanUnSuccessful() => Intl.message('Buy Plan UnSuccessful',
      name: 'buyPlanUnSuccessful', desc: 'buyPlanUnSuccessful');
  String activateSuccessful() => Intl.message('Activate Successful',
      name: 'activateSuccessful', desc: 'activateSuccessful');
  String activateunSuccessful() => Intl.message('Activateun Successful',
      name: 'activateunSuccessful', desc: 'activateunSuccessful');
  String activatePlan() =>
      Intl.message('Activate Plan', name: 'activatePlan', desc: 'activatePlan');
  String planIsActive() => Intl.message('Plan Is Active',
      name: 'planIsActive', desc: 'planIsActive');
  String carTitle() =>
      Intl.message('Title', name: 'carTitle', desc: 'carTitle');
  String carModelTitle() =>
      Intl.message('Car Model', name: 'carModelTitle', desc: 'carModelTitle');
  String carModelDetailTitle() => Intl.message('Tip',
      name: 'carModelDetailTitle', desc: 'carModelDetailTitle');
  String changeUserRole() => Intl.message('Change User Role',
      name: 'changeUserRole', desc: 'changeUserRole');
  String adminUserName() => Intl.message('Admin UserName',
      name: 'adminUserName', desc: 'adminUserName');
  String carIsWaitingForConfirm() => Intl.message('Car Is Waiting For Confirm',
      name: 'carIsWaitingForConfirm', desc: 'carIsWaitingForConfirm');
  String showAccessablActions() => Intl.message('Accessable Actions',
      name: 'showAccessablActions', desc: 'showAccessablActions');
  String foundCar() =>
      Intl.message('Found Car', name: 'foundCar', desc: 'foundCar');
  String appSettings() =>
      Intl.message('App Settings', name: 'appSettings', desc: 'appSettings');
  String loadingLogin() =>
      Intl.message('Loading Login', name: 'loadingLogin', desc: 'loadingLogin');
  String close() => Intl.message('Close', name: 'close', desc: 'close');
  String sendChanges() =>
      Intl.message('Send Changes', name: 'sendChanges', desc: 'sendChanges');
  String plzEnterRequiredData() => Intl.message('Please Enter Required Data',
      name: 'plzEnterRequiredData', desc: 'plzEnterRequiredData');
  String logoutAccount() => Intl.message('Logout Account',
      name: 'logoutAccount', desc: 'logoutAccount');
  String logoutSuccessful() => Intl.message('Logout Successful',
      name: 'logoutSuccessful', desc: 'logoutSuccessful');
  String editProfileSuccessful() => Intl.message('Edit Profile Successful',
      name: 'editProfileSuccessful', desc: 'editProfileSuccessful');
  String routeCars() =>
      Intl.message('Route Cars', name: 'routeCars', desc: 'routeCars');
  String getRouteCars() => Intl.message('Get Route Cars',
      name: 'getRouteCars', desc: 'getRouteCars');
  String lastPostionOfCar() => Intl.message('Last Postion Of Car',
      name: 'lastPostionOfCar', desc: 'lastPostionOfCar');
  String confirmPasswordError() => Intl.message('Confirm Password Error',
      name: 'confirmPasswordError', desc: 'confirmPasswordError');
  String pelakNotvalid() => Intl.message('Pelak Not Valid',
      name: 'pelakNotvalid', desc: 'pelakNotvalid');
  String carList() =>
      Intl.message('Car List', name: 'carList', desc: 'carList');
  String joinCars() =>
      Intl.message('Join Cars', name: 'joinCars', desc: 'joinCars');
  String report() => Intl.message('Report', name: 'report', desc: 'report');
  String enablePlan() =>
      Intl.message('Enable', name: 'enablePlan', desc: 'enablePlan');
  String doFilter() =>
      Intl.message('Do Filter', name: 'doFilter', desc: 'doFilter');
  String delete() => Intl.message('Delete', name: 'delete', desc: 'delete');
  String activateCar() =>
      Intl.message('Activate', name: 'activateCar', desc: 'activateCar');
  String messageTitle() =>
      Intl.message('Action', name: 'messageTitle', desc: 'messageTitle');
  String serviceDate() =>
      Intl.message('Service Date', name: 'serviceDate', desc: 'serviceDate');
  String alarmDate() =>
      Intl.message('Alarm Date', name: 'alarmDate', desc: 'alarmDate');
  String alarmCount() =>
      Intl.message('Alarm Count', name: 'alarmCount', desc: 'alarmCount');
  String actionDate() =>
      Intl.message('Action Date', name: 'actionDate', desc: 'actionDate');
  String serviceCost() =>
      Intl.message('Service Cost', name: 'serviceCost', desc: 'serviceCost');
  String allFieldsRequired() => Intl.message('All Fields Required',
      name: 'allFieldsRequired', desc: 'allFieldsRequired');
  String alarmDurationDay() => Intl.message('alarmDurationDay',
      name: 'alarmDurationDay', desc: 'alarmDurationDay');
  String automationInsert() => Intl.message('automationInsert',
      name: 'automationInsert', desc: 'automationInsert');
  String durationCountValue() => Intl.message('durationCountValue',
      name: 'durationCountValue', desc: 'durationCountValue');
  String durationValue() => Intl.message('durationValue',
      name: 'durationValue', desc: 'durationValue');
  String serviceTypeCode() => Intl.message('serviceTypeCode',
      name: 'serviceTypeCode', desc: 'serviceTypeCode');
  String serviceTypeTitle() => Intl.message('serviceTypeTitle',
      name: 'serviceTypeTitle', desc: 'serviceTypeTitle');
  String plzSelectACarToRoute() => Intl.message('plz Select A Car To Route',
      name: 'plzSelectACarToRoute', desc: 'plzSelectACarToRoute');
  String yourLocationNotFound() => Intl.message('yourLocationNotFound',
      name: 'yourLocationNotFound', desc: 'yourLocationNotFound');
  String carJoindBefore() =>
      Intl.message('Last Cars', name: 'carJoindBefore', desc: 'carJoindBefore');
  String selectForJoin() => Intl.message('Select to Join',
      name: 'selectForJoin', desc: 'selectForJoin');
  String editCarSuccessful() => Intl.message('Edit Car Successful',
      name: 'editCarSuccessful', desc: 'editCarSuccessful');
  String editCarUnSuccessful() => Intl.message('Edit Car UnSuccessful',
      name: 'editCarUnSuccessful', desc: 'editCarUnSuccessful');
  String messageDate() =>
      Intl.message('Message Date', name: 'messageDate', desc: 'messageDate');
  String messageSubject() => Intl.message('Message Subject',
      name: 'messageSubject', desc: 'messageSubject');
  String messageBody() =>
      Intl.message('Message Body', name: 'messageBody', desc: 'messageBody');
  String messageSentUnSuccessfull() =>
      Intl.message('Message Sent UnSuccessfull',
          name: 'messageSentUnSuccessfull', desc: 'messageSentUnSuccessfull');
  String messageHasSentSuccessfull() => Intl.message('Message Sent Successfull',
      name: 'messageHasSentSuccessfull', desc: 'messageHasSentSuccessfull');
  String sendMessage() =>
      Intl.message('Sending Message', name: 'sendMessage', desc: 'sendMessage');
  String noServiceTypes() => Intl.message('No ServiceTypes',
      name: 'noServiceTypes', desc: 'noServiceTypes');
  String showDetails() =>
      Intl.message('Show Details', name: 'showDetails', desc: 'showDetails');
  String confimDelete() => Intl.message('Alarm to Delete!',
      name: 'confimDelete', desc: 'confimDelete');
  String areYouSureToDelete() => Intl.message('Are You Sure To Delete?',
      name: 'areYouSureToDelete', desc: 'areYouSureToDelete');
  String carNotFound() =>
      Intl.message('Car Not Found', name: 'carNotFound', desc: 'carNotFound');
  String serviceType() =>
      Intl.message('Service Type', name: 'serviceType', desc: 'serviceType');
  String serviceTypeIsDurational() => Intl.message('Durational',
      name: 'serviceTypeIsDurational', desc: 'serviceTypeIsDurational');
  String serviceTypeIsFunctionality() => Intl.message('Functional',
      name: 'serviceTypeIsFunctionality', desc: 'serviceTypeIsFunctionality');
  String functional() =>
      Intl.message('Functional', name: 'functional', desc: 'functional');
  String durational() =>
      Intl.message('Durational', name: 'durational', desc: 'durational');
  String both() => Intl.message('Both', name: 'both', desc: 'both');
  String durationDay() =>
      Intl.message('Day', name: 'durationDay', desc: 'durationDay');
  String durationMonth() =>
      Intl.message('Month', name: 'durationMonth', desc: 'durationMonth');
  String durationYear() =>
      Intl.message('Year', name: 'durationYear', desc: 'durationYear');
  String remaind() => Intl.message('Remaind', name: 'remaind', desc: 'remaind');
  String durationFunctionalCountValue() =>
      Intl.message('durationFunctionalCountValue',
          name: 'durationFunctionalCountValue',
          desc: 'durationFunctionalCountValue');
  String durationFunctionalValue() => Intl.message('durationFunctionalValue',
      name: 'durationFunctionalValue', desc: 'durationFunctionalValue');
  String securityCodeWillSmsYou() => Intl.message('Your Password SMS you',
      name: 'securityCodeWillSmsYou', desc: 'securityCodeWillSmsYou');
  String smsHasRead() =>
      Intl.message('Read', name: 'smsHasRead', desc: 'smsHasRead');
  String smsHasUnRead() =>
      Intl.message('UnRead', name: 'smsHasUnRead', desc: 'smsHasUnRead');
  String loginAndThenEditYourProfile() =>
      Intl.message('Login And Then Edit Your Profile With Password: 1111',
          name: 'loginAndThenEditYourProfile',
          desc: 'loginAndThenEditYourProfile');
  String passwordHasChanged() => Intl.message('PasswordHas Changed',
      name: 'passwordHasChanged', desc: 'passwordHasChanged');
  String changePasswordError() => Intl.message('Change Password Has Error',
      name: 'changePasswordError', desc: 'changePasswordError');
  String changePasswordTitle() => Intl.message('Change Password Title',
      name: 'changePasswordTitle', desc: 'changePasswordTitle');
  String replyMessage() =>
      Intl.message('Reply Message', name: 'replyMessage', desc: 'replyMessage');
  String actionService() => Intl.message('Action Service',
      name: 'actionService', desc: 'actionService');
  String done() => Intl.message('Done', name: 'done', desc: 'done');
  String notDone() =>
      Intl.message('Not Done', name: 'notDone', desc: 'notDone');
  String fromDateToDate() => Intl.message('From Date by Date',
      name: 'fromDateToDate', desc: 'fromDateToDate');
  String showReportBaseOnDate() => Intl.message('Show Report BaseOn Date',
      name: 'showReportBaseOnDate', desc: 'showReportBaseOnDate');
  String showReportBaseOnDays() => Intl.message('Show Report Base On Last Days',
      name: 'showReportBaseOnDays', desc: 'showReportBaseOnDays');
  String fromLastDays() => Intl.message('From Last Days',
      name: 'fromLastDays', desc: 'fromLastDays');
  String alarmDistance() => Intl.message('Alarm Distance',
      name: 'alarmDistance', desc: 'alarmDistance');
  String areYouSureToExitForBackTouchCancel() =>
      Intl.message('Are You Sure To Exit ? For Back Touch Cancel',
          name: 'areYouSureToExitForBackTouchCancel',
          desc: 'areYouSureToExitForBackTouchCancel');
  String carPairedCounts() => Intl.message('carPairedCounts',
      name: 'carPairedCounts', desc: 'carPairedCounts');
  String carToRequestForPair() => Intl.message('carToRequestForPair',
      name: 'carToRequestForPair', desc: 'carToRequestForPair');
  String addToPaired() =>
      Intl.message('addToPaired', name: 'addToPaired', desc: 'addToPaired');
  String masterCarId() =>
      Intl.message('masterCarId', name: 'masterCarId', desc: 'masterCarId');
  String thisCarPaired() => Intl.message('thisCarPaired',
      name: 'thisCarPaired', desc: 'thisCarPaired');
  String messageRead() =>
      Intl.message('Read', name: 'messageRead', desc: 'messageRead');
  String errorinSignUp() => Intl.message('errorinSignUp',
      name: 'errorinSignUp', desc: 'errorinSignUp');
  String navigateToCurrent() => Intl.message('navigateToCurrent',
      name: 'navigateToCurrent', desc: 'navigateToCurrent');
  String payPlan() => Intl.message('payPlan', name: 'payPlan', desc: 'payPlan');
  String actionUsername() => Intl.message('actionUsername',
      name: 'actionUsername', desc: 'actionUsername');
  String chargeAmount() =>
      Intl.message('chargeAmount', name: 'chargeAmount', desc: 'chargeAmount');
  String chargeSimCard() => Intl.message('chargeSimCard',
      name: 'chargeSimCard', desc: 'chargeSimCard');
  String getHardwareVersion() => Intl.message('getHardwareVersion',
      name: 'getHardwareVersion', desc: 'getHardwareVersion');
  String sendInfoAccuracy() => Intl.message('sendInfoAccuracy',
      name: 'sendInfoAccuracy', desc: 'sendInfoAccuracy');
  String gethHrdwareVersion() => Intl.message('gethHrdwareVersion',
      name: 'gethHrdwareVersion', desc: 'gethHrdwareVersion');
  String forGethwareVersionClickGetButton() =>
      Intl.message('forGethwareVersionClickGetButton',
          name: 'forGethwareVersionClickGetButton',
          desc: 'forGethwareVersionClickGetButton');
  String getChargeAmount() => Intl.message('getChargeAmount',
      name: 'getChargeAmount', desc: 'getChargeAmount');
  String maxSpeed() =>
      Intl.message('maxSpeed', name: 'maxSpeed', desc: 'maxSpeed');
  String minSpeed() =>
      Intl.message('minSpeed', name: 'minSpeed', desc: 'minSpeed');
  String periodicSendTime() => Intl.message('periodicSendTime',
      name: 'periodicSendTime', desc: 'periodicSendTime');
  String periodicAccuracy() => Intl.message('periodicAccuracy',
      name: 'periodicAccuracy', desc: 'periodicAccuracy');
  String hardWareVersion() => Intl.message('hardWareVersion',
      name: 'hardWareVersion', desc: 'hardWareVersion');
  String plzEnterChargePassword() => Intl.message('plzEnterChargePassword',
      name: 'plzEnterChargePassword', desc: 'plzEnterChargePassword');
  String iranTitle() =>
      Intl.message('iranTitle', name: 'iranTitle', desc: 'iranTitle');
  String services() =>
      Intl.message('services', name: 'services', desc: 'services');
  String cancelService() => Intl.message('cancelService',
      name: 'cancelService', desc: 'cancelService');
  String notDoneService() => Intl.message('notDoneService',
      name: 'notDoneService', desc: 'notDoneService');
  String denyRequest() =>
      Intl.message('denyRequest', name: 'denyRequest', desc: 'denyRequest');
  String accuracyInfo() =>
      Intl.message('accuracyInfo', name: 'accuracyInfo', desc: 'accuracyInfo');
  String sendCommand() =>
      Intl.message('sendCommand', name: 'sendCommand', desc: 'sendCommand');
  String sabteInfo() =>
      Intl.message('sabteInfo', name: 'sabteInfo', desc: 'sabteInfo');
  String lowLevel() =>
      Intl.message('lowLevel', name: 'lowLevel', desc: 'lowLevel');
  String mediumLevel() =>
      Intl.message('mediumLevel', name: 'mediumLevel', desc: 'mediumLevel');
  String highLevel() =>
      Intl.message('highLevel', name: 'highLevel', desc: 'highLevel');
  String minStopTime() =>
      Intl.message('minStopTime', name: 'minStopTime', desc: 'minStopTime');
  String showReport() =>
      Intl.message('showReport', name: 'showReport', desc: 'showReport');
  String remaindToNextService() => Intl.message('remaindToNextService',
      name: 'remaindToNextService', desc: 'remaindToNextService');
  String forGetChargeAmount() => Intl.message('forGetChargeAmount',
      name: 'forGetChargeAmount', desc: 'forGetChargeAmount');
  String messageCount() =>
      Intl.message('messageCount', name: 'messageCount', desc: 'messageCount');
  String distanceDone() =>
      Intl.message('distanceDone', name: 'distanceDone', desc: 'distanceDone');
  String serviceDoneDate() => Intl.message('serviceDoneDate',
      name: 'serviceDoneDate', desc: 'serviceDoneDate');
  String currentDistance() => Intl.message('currentDistance',
      name: 'currentDistance', desc: 'currentDistance');
  String securitySettings() => Intl.message('securitySettings',
      name: 'securitySettings', desc: 'securitySettings');
  String reservationIsDisabled() => Intl.message('reservationIsDisabled',
      name: 'reservationIsDisabled', desc: 'reservationIsDisabled');
  String document() =>
      Intl.message('document', name: 'document', desc: 'document');
  String shareHelpText() => Intl.message('shareHelpText',
      name: 'shareHelpText', desc: 'shareHelpText');
  String shareHelpSubject() => Intl.message('shareHelpSubject',
      name: 'shareHelpSubject', desc: 'shareHelpSubject');

  String title() => Intl.message('MagiCar', name: 'title', desc: 'MagiCar Co.');
}
