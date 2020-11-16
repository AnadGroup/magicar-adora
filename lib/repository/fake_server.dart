import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/model/action_to_role_model.dart';
import 'package:anad_magicar/model/actions.dart';
import 'package:anad_magicar/model/apis/accessable_actions.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_color.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/apis/current_user_accessable_action.dart';
import 'package:anad_magicar/model/apis/device_model.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/model/cars/car_model_detail.dart';
import 'package:anad_magicar/model/plan_model.dart';
import 'package:anad_magicar/model/user/admin_car.dart';

class FakeServer {

  static List<CurrentUserAccessableActionModel> createCurrentUserAccessableActionModel()
  {
    List<CurrentUserAccessableActionModel> result=new List();
    result..add(new CurrentUserAccessableActionModel(
        UserId: 3, RoleId: 1, Description: 'Role 1',
        /*accessableActions: new AccessableActions(
            ActionTitle: 'action 1',
            ActionId: 1,
            ActionCode: '', IsActive: true)*/))
    ..add(new CurrentUserAccessableActionModel(
        UserId: 3, RoleId: 2, Description: 'Role 1',
       /* accessableActions: new AccessableActions(
            ActionTitle: 'action 1',
            ActionId: 2,
            ActionCode: '', IsActive: true)*/))
    ..add(new CurrentUserAccessableActionModel(
       /* UserId: 3, RoleId: 2, Description: 'Role 1',
        accessableActions: new AccessableActions(
            ActionTitle: 'action 1',
            ActionId: 3,
            ActionCode: '', IsActive: true)*/))
    ..add(new CurrentUserAccessableActionModel(
        UserId: 3, RoleId: 3, Description: 'Role 1',
        /*accessableActions: new AccessableActions(
            ActionTitle: 'action 1',
            ActionId: 1,
            ActionCode: '', IsActive: true)*/));
    return result;
  }
  static List<ActionToRoleModel> createActionToRoles()
  {
    List<ActionToRoleModel> result=new List();
    result..add(new ActionToRoleModel(
        ActionToRoleId: 1,
        ActionId: 1,
        RoleId: 1,
        Description: 'desc 1',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null))
    ..add(new ActionToRoleModel(
        ActionToRoleId: 2,
        ActionId: 2,
        RoleId: 2,
        Description: 'desc 1',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null))
    ..add(new ActionToRoleModel(
        ActionToRoleId: 3,
        ActionId: 1,
        RoleId: 3,
        Description: 'desc 1',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null))
    ..add(new ActionToRoleModel(
        ActionToRoleId: 4,
        ActionId: 2,
        RoleId: 4,
        Description: 'desc 1',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null))
    ..add(new ActionToRoleModel(
        ActionToRoleId: 5,
        ActionId: 3,
        RoleId: 5,
        Description: 'desc 1',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null));
    return result;
  }
  static List<BrandModel>  createBrands()
  {
    List<BrandModel> result=new List();
    result..add(new BrandModel(
        brandId: 1,
        brandTitle: 'برند 1',
        brandCode: '0001',
        decription: 'desc1',
        imageUrl: null,
        description: null,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null))
    ..add(new BrandModel(
        brandId: 2,
        brandTitle: 'برند 2',
        brandCode: '0002',
        decription: 'desc2',
        imageUrl: null,
        description: null,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null))
    ..add(new BrandModel(
        brandId: 3,
        brandTitle: 'برند 3',
        brandCode: '0003',
        decription: 'desc3',
        imageUrl: null,
        description: null,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null))
    ..add(new BrandModel(
        brandId: 4,
        brandTitle: 'برند 4',
        brandCode: '0004',
        decription: 'desc4',
        imageUrl: null,
        description: null,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null))
    ..add(new BrandModel(
  brandId: 5,
  brandTitle: 'برند 5',
  brandCode: '0005',
  decription: 'desc5',
  imageUrl: null,
  description: null,
  isActive: true,
  businessUnitId: null,
  owner: null,
  version: null,
  createdDate: null))
    ..add(new BrandModel(
        brandId: 6,
        brandTitle: 'برند 6',
        brandCode: '0006',
        decription: 'desc6',
        imageUrl: null,
        description: null,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null));
    return result;
  }

 static List<CarModel> createCarModels()
  {
    List<CarModel> result=new List();
    result..add(
        new CarModel(
            carModelId: 1,
            carModelCode: '001',
            carModelTitle: 'مدل 1',
            imageUrl: null,
            brandId: 1,
            isActive: true,
            businessUnitId: null,
            owner: null,
            version: null,
            createdDate: null))
    ..add(new CarModel(
        carModelId: 2,
        carModelCode: '002',
        carModelTitle: 'مدل 2',
        imageUrl: null,
        brandId: 1,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null))
    ..add(new CarModel(
        carModelId: 3,
        carModelCode: '003',
        carModelTitle: 'مدل 3',
        imageUrl: null,
        brandId: 2,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null))
    ..add(new CarModel(
        carModelId: 4,
        carModelCode: '004',
        carModelTitle: 'مدل 4',
        imageUrl: null,
        brandId: 2,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null))
    ..add(new CarModel(
        carModelId: 5,
        carModelCode: '005',
        carModelTitle: 'مدل 5',
        imageUrl: null,
        brandId: 3,
        isActive: true,
        businessUnitId: null,
        owner: null,
        version: null,
        createdDate: null));
    return result;
  }

  static List<Car> createCars()
  {
    List<Car> result=new List();
    result..add(new Car(
        carId: 1,
        carModelDetailId: 1,
        productDate: '1398/01/01',
        colorTypeConstId: 1,
        pelaueNumber: '10122',
        deviceId: 10,
        totalDistance: 4152,
        carStatusConstId: 1,
        description: 'desccar',
        isActive: true,
        brandTitle: 'brand 1',
        businessUnitId: null,
        owner: null, version: null, createdDate: null));
    return result;
  }

  static List<CarModelDetail> createCarModelDetails()
  {
    List<CarModelDetail> result=new List();
    result..add(new CarModelDetail(
        carModelDetailId: 1,
        carModelDetailTitle: 'جزییات مدل 1',
        imageUrl: null,
        carModelId: 1,
        description: 'desc modeldetail 1',
        isActive: true,
        businessUnitId: null, owner: null, version: null, createdDate: null))
    ..add(new CarModelDetail(
        carModelDetailId: 2,
        carModelDetailTitle: '2',
        imageUrl: null,
        carModelId: 2,
        description: 'desc modeldetail 2',
        isActive: true,
        businessUnitId: null, owner: null, version: null, createdDate: null))
    ..add(new CarModelDetail(
        carModelDetailId: 3,
        carModelDetailTitle: 'جزییات مدل 3',
        imageUrl: null,
        carModelId: 1,
        description: 'desc modeldetail 3',
        isActive: true,
        businessUnitId: null, owner: null, version: null, createdDate: null));
    return result;
  }


  static List<ApiCarColor> createCarColors()
  {
    List<ApiCarColor> result=new List();
    result..add(new ApiCarColor(
        carColorTitle: 'color1',
        colorId: 1,
        ConstantId: 1,
        DisplayName: 'color1'))
    ..add(new ApiCarColor(
        carColorTitle: 'color2',
        colorId: 2,
        ConstantId: 2,
        DisplayName: 'color2'))
    ..add(new ApiCarColor(
        carColorTitle: 'color3',
        colorId: 3,
        ConstantId: 3,
        DisplayName: 'color3'))
    ..add(new ApiCarColor(
        carColorTitle: 'color4',
        colorId: 4,
        ConstantId: 4,
        DisplayName: 'color4'))
    ..add(new ApiCarColor(
        carColorTitle: 'color5',
        colorId: 5,
        ConstantId: 5,
        DisplayName: 'color5'));
    return result;
  }

  static List<PlanModel> createPlans()
  {
    List<PlanModel> result=new List();
    result..add(new PlanModel(
        PlanCode: '001',
        PlanTitle: 'Plan 1',
        TypeName: 'Type 1',
        FromDate: '1398/01/01',
        ToDate: '1398/02/01',
        Cost: 20000,
        DayCount: 15,
        CreatedDate: null, Description: null))
    ..add(new PlanModel(
        PlanCode: '002',
        PlanTitle: 'Plan 2',
        TypeName: 'Type 2',
        FromDate: '1398/03/01',
        ToDate: '1398/04/01',
        Cost: 50000,
        DayCount: 35,
        CreatedDate: null, Description: null))
    ..add(new PlanModel(
        PlanCode: '003',
        PlanTitle: 'Plan 3',
        TypeName: 'Type 3',
        FromDate: '1398/03/01',
        ToDate: '1398/05/01',
        Cost: 45555,
        DayCount: 66,
        CreatedDate: null, Description: null))
    ..add(new PlanModel(
        PlanCode: '004',
        PlanTitle: 'Plan 4',
        TypeName: 'Type 4',
        FromDate: '1398/05/01',
        ToDate: '1398/08/01',
        Cost: 55000,
        DayCount: 55,
        CreatedDate: null, Description: null))
    ..add(new PlanModel(
        PlanCode: '005',
        PlanTitle: 'Plan 5',
        TypeName: 'Type 5',
        FromDate: '1398/01/01',
        ToDate: '1398/02/01',
        Cost: 690000,
        DayCount: 45,
        CreatedDate: null, Description: null))
    ..add(new PlanModel(
        PlanCode: '006',
        PlanTitle: 'Plan 6',
        TypeName: 'Type 6',
        FromDate: '1398/08/01',
        ToDate: '1398/10/01',
        Cost: 485555,
        DayCount: 110,
        CreatedDate: null, Description: null));
    return result;
  }
  static List<ActionModel> createActions()
  {
    List<ActionModel> result=new List();
    result..add(new ActionModel(
        ActionId: 1,
        ActionCode: ActionsCommand.LockAndArm_Nano_CODE,
        ActionTitle: 'Action 1',
        KeyString: null,
        CarId: 1,
        Description: 'Desc action 1',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null))
    ..add(new ActionModel(
        ActionId: 2,
        ActionCode: ActionsCommand.UnlockAndDisArm_Nano_CODE,
        ActionTitle: 'Action 2',
        KeyString: null,
        CarId: 2,
        Description: 'Desc action 2',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null))
    ..add(new ActionModel(
        ActionId: 3,
        ActionCode: ActionsCommand.RemoteStartOn_Nano_CODE,
        ActionTitle: 'Action 3',
        KeyString: null,
        CarId: 1,
        Description: 'Desc action 3',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null))
    ..add(new ActionModel(
        ActionId: 4,
        ActionCode: ActionsCommand.RemoteStartOff_Nano_CODE,
        ActionTitle: 'Action 4',
        KeyString: null,
        CarId: 1,
        Description: 'Desc action 4',
        IsActive: true,
        BusinessUnitId: null, Owner: null, Version: null, CreatedDate: null));
    return result;
  }

  static List<ApiRelatedUserModel> createRelatedUsers()
  {
    List<ApiRelatedUserModel> result=new List();
    result..add(new ApiRelatedUserModel(userId: 1,
        userName: 'user 1', roleTitle: 'user', roleId: 1))
    ..add(new ApiRelatedUserModel(userId: 2,
        userName: 'user 2', roleTitle: 'user', roleId: 1))
    ..add(new ApiRelatedUserModel(userId: 4,
        userName: 'user 3', roleTitle: 'user', roleId: 2))
    ..add(new ApiRelatedUserModel(userId: 5,
        userName: 'user 4', roleTitle: 'user', roleId: 3))
    ..add(new ApiRelatedUserModel(userId: 6,
        userName: 'user 5', roleTitle: 'user', roleId: 3));
    return result;

  }
  static  List<AdminCarModel> createAdminCars()
  {
    List<AdminCarModel> result=new List();
    result..add(new AdminCarModel(
        CarId: 1,
        CreatedDate: '1398/01/01',
        Description: 'Desc 1',
        FromDate: '1398/02/01',
        ToDate: null,
        IsActive: true,
        IsAdmin: true,
        UserId: 3,
        CarModelDetailTitle: 'Model Detail 1',
        CarModelTitle: ' Mode 1',
        BrandTitle: 'Brand 1'))
    ..add(new AdminCarModel(
        CarId: 2,
        CreatedDate: '1398/02/01',
        Description: 'Desc 2',
        FromDate: '1398/02/01',
        ToDate: null,
        IsActive: true,
        IsAdmin: true,
        UserId: 3,
        CarModelDetailTitle: 'Model Detail 2',
        CarModelTitle: ' Mode 2',
        BrandTitle: 'Brand 2'))
    ..add(new AdminCarModel(
        CarId: 3,
        CreatedDate: '1398/01/01',
        Description: 'Desc 3',
        FromDate: '1398/03/01',
        ToDate: null,
        IsActive: true,
        IsAdmin: true,
        UserId: 3,
        CarModelDetailTitle: 'Model Detail 3',
        CarModelTitle: ' Mode 3',
        BrandTitle: 'Brand 3'))
    ..add(new AdminCarModel(
        CarId: 4,
        CreatedDate: '1398/05/01',
        Description: 'Desc 4',
        FromDate: '1398/06/01',
        ToDate: null,
        IsActive: true,
        IsAdmin: true,
        UserId: 3,
        CarModelDetailTitle: 'Model Detail 4',
        CarModelTitle: ' Mode 4',
        BrandTitle: 'Brand 4'));
    return result;

  }

  static List<DeviceModel> createDeviceModel()
  {
    List<DeviceModel> result=new List();
    result..add(new DeviceModel(DisplayName: 'Device 1', ConstantId: 1))
    ..add(new DeviceModel(DisplayName: 'Device 1', ConstantId: 1))
    ..add(new DeviceModel(DisplayName: 'Device 2', ConstantId: 2))
    ..add(new DeviceModel(DisplayName: 'Device 3', ConstantId: 3))
    ..add(new DeviceModel(DisplayName: 'Device 4', ConstantId: 4));
    return result;
  }

}
