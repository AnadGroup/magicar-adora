import 'package:flutter/material.dart';

class NotyLoadingVM{
  bool isLoading;
  bool hasLoaded;
  bool haseError;
  bool hasInternet;
  NotyLoadingVM({
    @required this.isLoading,
    @required this.hasLoaded,
    @required this.haseError,
    @required this.hasInternet,
  });

}
