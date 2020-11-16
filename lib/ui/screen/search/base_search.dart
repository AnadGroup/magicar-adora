
import 'package:flutter/material.dart';

abstract class BaseSearch<T>{
  T searchModel;
 Widget showSearchForm(T serchModel);
 Widget resultWidget();
}
