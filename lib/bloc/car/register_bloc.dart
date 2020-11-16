import 'dart:async';
import 'package:anad_magicar/bloc/car/register.dart';
import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:bloc/bloc.dart';



class RegisterCarBloc extends Bloc<RegisterEvent,RegisterState>
{
  static final RegisterCarBloc _registerBlocSingleton = new RegisterCarBloc._internal();
  var currentObj;
  factory RegisterCarBloc() {
    return _registerBlocSingleton;
  }
  RegisterCarBloc._internal();

  RegisterState get initialState => new UnRegisterState();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if(event is LoadRegisterEvent) {
      yield LoadRegisterState();
      try {
        if (event.carModel != null) {
          CarDS carDS = new CarDS();
          SaveCarModel result = await carDS.send(event.carModel);
          if (result != null) {
            centerRepository.getCars()
              ..add(new Car(carId: result.carId,
                  carModelDetailId: result.tip,
                  productDate: null,
                  colorTypeConstId: result.colorId,
                  pelaueNumber: result.pelak,
                  deviceId: 1,
                  totalDistance: result.distance,
                  carStatusConstId: null,
                  description: null,
                  isActive: null,
                  brandTitle: 'brand title',
                  businessUnitId: null,
                  owner: null,
                  version: null,
                  createdDate: null));
            prefRepository.setCarId(result.carId);
            centerRepository.setCarId(result.carId);
            prefRepository.addCarsCount();
            yield RegisteredState();
           // yield UnRegisterState();
          }
          else
            yield ErrorRegisterState('خطا در ثبت خودرو');
        }
      } catch (_, stackTrace) {
       yield ErrorRegisterState(_?.toString());
    }
    }
    if (event is RegisteredEvent){
      yield RegisteredState();
    }
    if(event is InRegisterEvent){
      yield InRegisterState();
    }
  }


}
