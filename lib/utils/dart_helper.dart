class DartHelper {
  static bool isNullOrEmpty(String value) => value == '' || value == null;

  static String isNullOrEmptyString(String value) {
   if( value=='' || value==null || value=='null' )
      return '' ;
    return value;
  }


}
