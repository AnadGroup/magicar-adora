

abstract class DynamicForm<T,List> {

  static String FIELD_TYPE_TEXT='TEXT';
  static String FIELD_TYPE_NUMBER='NUMBER';
  static String FIELD_TYPE_IMAGE='IMAGE';
  static String FIELD_TYPE_BUTTON='BUTTON';
  static String FIELD_TYPE_EDITTEXT='EDITTEXT';
  static String FIELD_TYPE_COMBO='COMBO';

  T model;
  String formType;
  String fieldType;

}
