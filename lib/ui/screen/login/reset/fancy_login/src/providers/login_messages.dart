import 'package:flutter/material.dart';

class LoginMessages with ChangeNotifier {
  LoginMessages({
    this.usernameHint: defaultUsernameHint,
    this.firstNameHint: defaultFirstNameHint,
    this.lastNameHint: defaultLastNameHint,
    this.mobileHint: defaultMobileHint,
    this.confirmButton: defaultConfrimButton,
    this.securtiyCodeButton: defaultSecurityCodeButton,
    this.passwordHint: defaultPasswordHint,
    this.currentPasswordHint: defaultCurrentPasswordHint,
    this.confirmPasswordHint: defaultConfirmPasswordHint,
    this.forgotPasswordButton: defaultForgotPasswordButton,
    this.loginButton: defaultLoginButton,
    this.signupButton: defaultSignupButton,
    this.recoverPasswordButton: defaultRecoverPasswordButton,
    this.recoverPasswordIntro: defaultRecoverPasswordIntro,
    this.recoverPasswordDescription: defaultRecoverPasswordDescription,
    this.goBackButton: defaultGoBackButton,
    this.confirmPasswordError: defaultConfirmPasswordError,
    this.recoverPasswordSuccess: defaultRecoverPasswordSuccess,
  });

  static const defaultUsernameHint = 'UserName';
  static const defaultFirstNameHint = 'FirstName';
  static const defaultLastNameHint = 'LastName';
  static const defaultMobileHint = 'Mobile';
  static const defaultCurrentPasswordHint = 'Current Password';
  static const defaultPasswordHint = 'Password';
  static const defaultConfirmPasswordHint = 'Confirm Password';
  static const defaultForgotPasswordButton = 'Forgot Password?';
  static const defaultLoginButton = 'LOGIN';
  static const defaultSignupButton = 'SIGNUP';
  static const defaultConfrimButton = 'CONFIRM';
  static const defaultSecurityCodeButton = 'SecurityCode';

  static const defaultRecoverPasswordButton = 'RECOVER';
  static const defaultRecoverPasswordIntro = 'بازیابی رمز عبور';
  static const defaultRecoverPasswordDescription =
      'جهت بازیابی رمز عبور لطفا شماره همراه خود را وارد نمایید';
  static const defaultGoBackButton = 'BACK';
  static const defaultConfirmPasswordError = 'Password do not match!';
  static const defaultRecoverPasswordSuccess = 'An email has been sent';

  /// Hint text of the user name [TextField]
  final String usernameHint;
  /// Hint text of the first name [TextField]
  final String firstNameHint;
  /// Hint text of the last name [TextField]
  final String lastNameHint;
  /// Hint text of the mobile [TextField]
  final String mobileHint;

/// Hint text of the password [TextField]
  final String currentPasswordHint;
  final String passwordHint;

  /// Hint text of the confirm password [TextField]
  final String confirmPasswordHint;

  /// Forgot password button's label
  final String forgotPasswordButton;

  /// Login button's label
  final String loginButton;

  /// Signup button's label
  final String signupButton;

  final String confirmButton;

  final String securtiyCodeButton;

  /// Recover password button's label
  final String recoverPasswordButton;

  /// Intro in password recovery form
  final String recoverPasswordIntro;

  /// Description in password recovery form
  final String recoverPasswordDescription;

  /// Go back button's label. Go back button is used to go back to to
  /// login/signup form from the recover password form
  final String goBackButton;

  /// The error message to show when the confirm password not match with the
  /// original password
  final String confirmPasswordError;

  /// The success message to show after submitting recover password
  final String recoverPasswordSuccess;
}
