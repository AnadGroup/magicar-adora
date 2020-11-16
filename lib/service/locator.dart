import 'package:anad_magicar/service/local_auth_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator =GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => LocalAuthenticationService());
}