
import 'package:anad_magicar/service/fetch_connection.dart';

class CheckConnection extends FetchConnection {


bool hasInternet;

CheckConnection() : super();

@override
onOnline() {
  hasInternet=true;
}

@override  
onOffline(){
  hasInternet=false;

  }


bool checkInternet() {
  return this.hasInternet;
}
}