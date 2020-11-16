
import 'dart:async';

abstract class BaseRest {


  void checkConnectivity();
  void init();
  beforeRequest();
  afterResponse();
}
