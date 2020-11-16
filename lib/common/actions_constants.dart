import 'dart:collection';

import 'package:anad_magicar/model/actions.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart' as carEnum;
class ActionsCommand {


  static String TurboMode='Turbo Mode';
  static String TimeStart='Time Start';
  static String RemoteStart='Remote Start';
  static String PanicMode='Panic Mode';
  static String ValetMOde='Valet Mode';
  static String SirenOn='Siren On';
  static String ShockSendsor='Shock Sensor';
  static String DriveLock='Drive Lock';
  static String PassiveMode='Passive Mode';
  static String AutoMode='Auto Mode';
  static String OffMode='Off mode';
  static String LowVoltageState='Low Voltage State';


  static String TurboMode_ON_TAG='TurboModeOn';
  static String TimeStart_ON_TAG='TimeStartOn';
  static String RemoteStart_ON_TAG='RemoteStartOn';
  static String PanicMode_ON_TAG='PanicModeOn';
  static String ValetMOde_ON_TAG='ValetModeOn';
  static String SirenOn_ON_TAG='SirenOnOn';
  static String ShockSendsor_ON_TAG='ShockSensorOn';
  static String DriveLock_ON_TAG='DriveLockOn';
  static String PassiveMode_ON_TAG='PassiveModeOn';
  static String AutoMode_ON_TAG='AutoModeOn';
  static String OffMode_ON_TAG='OffmodeOn';
  static String LowVoltageState_ON_TAG='LowVoltageStateOn';

  static String TurboMode_OFF_TAG='TurboModeOff';
  static String TimeStart_OFF_TAG='TimeStartOff';
  static String RemoteStart_OFF_TAG='RemoteStartOff';
  static String PanicMode_OFF_TAG='PanicModeOff';
  static String ValetMOde_OFF_TAG='ValetModeOff';
  static String SirenOn_OFF_TAG='SirenOnOff';
  static String ShockSendsor_OFF_TAG='ShockSensorOff';
  static String DriveLock_OFF_TAG='DriveLockOff';
  static String PassiveMode_OFF_TAG='PassiveModeOff';
  static String AutoMode_OFF_TAG='AutoModeOff';
  static String OffMode_OFF_TAG='OffmodeOff';
  static String LowVoltageState_OFF_TAG='LowVoltageStateOff';

  static int TurboMode_ON=37;
  static int TimeStart_ON=34;
  static int RemoteStart_ON=12;
  static int PanicMode_ON=15;
  static int ValetMOde_ON=21;
  static int SirenOn_ON=15;
  static int ShockSendsor_ON=25;
  static int DriveLock_ON=27;
  static int PassiveMode_ON=29;
  static int AutoMode_ON=30;
  static int OffMode_ON=31;
  static int LowVoltageState_ON=32;

  static int TurboMode_OFF=38;
  static int TimeStart_OFF=35;
  static int RemoteStart_OFF=13;
  static int PanicMode_OFF=16;
  static int ValetMOde_OFF=22;
  static int SirenOn_OFF=16;
  static int ShockSendsor_OFF=26;
  static int DriveLock_OFF=28;
  static int PassiveMode_OFF=29;
  static int AutoMode_OFF=30;
  static int OffMode_OFF=31;
  static int LowVoltageState_OFF=33;
  static int Check_Status_Car=60;

  static String HARDWARE_VERSION_NANO_CODE='HardWareVersion_Nano';
  static String READ_IMEI_NANO_CODE='ReadIMEI_Nano';
  static String ChargeSimCardCredit_Nano_CODE='ChargeSimCardCredit_Nano';
  static String CheckSimCardCredit_Nano_CODE='CheckSimCardCredit_Nano';
  static String RequestTestSMS_Nano_CODE='RequestTestSMS_Nano';
  static String SetTiming_Nano_CODE='SetTiming_Nano';
  static String RemoteStartOn_Nano_CODE='RemoteStartOn_Nano';
  static String RemoteTrunk_Release_CODE='RemoteTrunk_Release';
  static String AUX1_Output_ON_CODE='AUX1_Output_ON';
  static String AUX2_Output_ON_CODE='AUX2_Output_ON';
  static String AUX1_Output_OFF_CODE='AUX1_Output_OFF';
  static String AUX2_Output_OFF_CODE='AUX2_Output_OFF';
  static String STATUS_CAR_TAG='STATUS_CAR';
  static String RemoteStartOff_Nano_CODE='RemoteStartOff_Nano';
  static String LockAndArm_Nano_CODE='LockAndArm_Nano';
  static String UnlockAndDisArm_Nano_CODE='UnlockAndDisArm_Nano';
  static String DriveLock_ONOrOFF_Nano_CODE='DriveLock_ONOrOFF_Nano';
  static String SIREN_Nano_CODE='Siren_Nano';



  static final String CAR_ID_TAG='CARId';
  static final String CAR_PAGE_TAG='CAR_PAGE';
  static final String ULTRA_SONIC_TAG='ULTRA_SONIC';
  static final String DISABLE_ULTRA_SONIC_TAG='DISABLE_ULTRA_SONIC';
  static final String OPEN_DOOR_TAG='OPEN_DOOR';
  static final String CLOSE_DOOR_TAG='CLOSE_DOOR';
  static final String OPEN_TRUNK_TAG='OPEN_TRUNK';
  static final String CLOSE_TRUNK_TAG='CLOSE_TRUNK';
  static final String OPEN_HOOD_TAG='OPEN_HOOD';
  static final String CLOSE_HOOD_TAG='CLOSE_HOOD';
  static final String IGNITATION_TAG='IGNITATION';
  static final String DISABLE_IGNITATION_TAG='DISABLE_IGNITATION';
  static final String SHOCK_WARNING_TAG='SHOCK_WARNING';
  static final String DISABLE_SHOCK_WARNING_TAG='DISABLE_SHOCK_WARNING';
  static final String SHOCK_TRIGGER_TAG='SHOCK_TRIGGER';
  static final String DISABLE_SHOCK_TRIGGER_TAG='DISABLE_SHOCK_TRIGGER';

  static final int CAR_PAGE_VALUE_TAG=28;
  static final int ULTRA_SONIC_VALUE_TAG=30;
  static final int DISABLE_ULTRA_SONIC_VALUE_TAG=31;
  static final int OPEN_DOOR_VALUE_TAG=11;
  static final int CLOSE_DOOR_VALUE_TAG=10;
  static final int OPEN_TRUNK_VALUE_TAG=14;
  static final int CLOSE_TRUNK_VALUE_TAG=0;
  static final int OPEN_HOOD_VALUE_TAG=0;
  static final int CLOSE_HOOD_VALUE_TAG=0;
  static final int IGNITATION_VALUE_TAG=0;
  static final int DISABLE_IGNITATION_VALUE_TAG=0;
  static final int SHOCK_WARNING_VALUE_TAG=0;
  static final int DISABLE_SHOCK_WARNING_VALUE_TAG=25;
  static final int SHOCK_TRIGGER_VALUE_TAG=26;
  static final int DISABLE_SHOCK_TRIGGER_VALUE_TAG=42;

  static HashMap<String,int> actionCommandsMap=new HashMap();
  static HashMap<int,String> actionCommandsNotiMap=new HashMap();
  static HashMap<carEnum.CarStatus,int> carNotiMap=new HashMap();
  static HashMap<String,List<String>> actionsTitleMap=new HashMap();
  static HashMap<String,int> actionsTitleValueMap=new HashMap();
  static HashMap<int,String> actionsIconsURLMap=new HashMap();


 static bool hasActions(String title)
  {
    bool result=actionsTitleMap.containsValue(title);
    return result;
  }


  static String getActionIconURL(int actionId) {
    if(actionsIconsURLMap.containsKey(actionId)) {
      return actionsIconsURLMap[actionId];
    }
  }

  static createActionIconsURlMap(){
   if(actionsIconsURLMap==null)
     actionsIconsURLMap=new HashMap();
   actionsIconsURLMap.putIfAbsent(OPEN_DOOR_VALUE_TAG, ()=>'assets/images/unlock_22.png');
   actionsIconsURLMap.putIfAbsent(CLOSE_DOOR_VALUE_TAG, ()=>'assets/images/lock_11.png');
   actionsIconsURLMap.putIfAbsent(OPEN_TRUNK_VALUE_TAG, ()=>'assets/images/trunk.png');
   actionsIconsURLMap.putIfAbsent(OPEN_HOOD_VALUE_TAG, ()=>'assets/images/trunk.png');
   actionsIconsURLMap.putIfAbsent(CLOSE_HOOD_VALUE_TAG, ()=>'assets/images/trunk.png');
   actionsIconsURLMap.putIfAbsent(CLOSE_TRUNK_VALUE_TAG, ()=>'assets/images/trunk.png');
   actionsIconsURLMap.putIfAbsent(RemoteStart_OFF, ()=>'assets/images/stop_engine.png');
   actionsIconsURLMap.putIfAbsent(RemoteStart_ON, ()=>'assets/images/start_engine.png');

  }
  static createActionsTitleMap()
  {
    if(actionsTitleMap==null)
      actionsTitleMap=new HashMap();
    actionsTitleMap.putIfAbsent(TurboMode, ()=>[TurboMode_ON_TAG,TurboMode_OFF_TAG]);
    actionsTitleMap.putIfAbsent(TimeStart, ()=>[TimeStart_ON_TAG,TimeStart_OFF_TAG]);
    actionsTitleMap.putIfAbsent(RemoteStart, ()=>[RemoteStart_ON_TAG,RemoteStart_OFF_TAG]);
    actionsTitleMap.putIfAbsent(PanicMode, ()=>[PanicMode_ON_TAG,PanicMode_OFF_TAG]);
    actionsTitleMap.putIfAbsent(ValetMOde, ()=>[ValetMOde_ON_TAG,ValetMOde_OFF_TAG]);
    actionsTitleMap.putIfAbsent(SirenOn, ()=>[SirenOn_ON_TAG,SirenOn_OFF_TAG]);
    actionsTitleMap.putIfAbsent(ShockSendsor, ()=>[ShockSendsor_ON_TAG,ShockSendsor_OFF_TAG]);
    actionsTitleMap.putIfAbsent(DriveLock, ()=>[DriveLock_ON_TAG,DriveLock_OFF_TAG]);
    actionsTitleMap.putIfAbsent(PassiveMode, ()=>[PassiveMode_ON_TAG,PassiveMode_OFF_TAG]);
    actionsTitleMap.putIfAbsent(AutoMode, ()=>[AutoMode_ON_TAG,AutoMode_OFF_TAG]);
    actionsTitleMap.putIfAbsent(OffMode, ()=>[OffMode_ON_TAG,OffMode_OFF_TAG]);
    actionsTitleMap.putIfAbsent(LowVoltageState, ()=>[LowVoltageState_ON_TAG,LowVoltageState_OFF_TAG]);

    /*actionsTitleMap.putIfAbsent(TurboMode, ()=>TurboMode);
    actionsTitleMap.putIfAbsent(TimeStart, ()=>TimeStart);
    actionsTitleMap.putIfAbsent(RemoteStart, ()=>RemoteStart);
    actionsTitleMap.putIfAbsent(PanicMode, ()=>PanicMode);
    actionsTitleMap.putIfAbsent(ValetMOde, ()=>ValetMOde);
    actionsTitleMap.putIfAbsent(SirenOn, ()=>SirenOn);
    actionsTitleMap.putIfAbsent(ShockSendsor, ()=>ShockSendsor);
    actionsTitleMap.putIfAbsent(DriveLock, ()=>DriveLock);
    actionsTitleMap.putIfAbsent(PassiveMode, ()=>PassiveMode);
    actionsTitleMap.putIfAbsent(AutoMode, ()=>AutoMode);
    actionsTitleMap.putIfAbsent(OffMode, ()=>OffMode);
    actionsTitleMap.putIfAbsent(LowVoltageState, ()=>LowVoltageState);*/

  }
  static createActionsMap()
  {
    actionCommandsMap.putIfAbsent(LockAndArm_Nano_CODE, ()=> 10);
    actionCommandsMap.putIfAbsent(UnlockAndDisArm_Nano_CODE, ()=> 11);
    actionCommandsMap.putIfAbsent(STATUS_CAR_TAG, ()=> 60);
    actionCommandsMap.putIfAbsent(RemoteStartOn_Nano_CODE, ()=> 12);
    actionCommandsMap.putIfAbsent(RemoteStartOff_Nano_CODE, ()=> 13);
    actionCommandsMap.putIfAbsent(RemoteTrunk_Release_CODE, ()=> 14);
    actionCommandsMap.putIfAbsent(AUX1_Output_ON_CODE, ()=> 19);
    actionCommandsMap.putIfAbsent(AUX1_Output_OFF_CODE, ()=> 19);
    actionCommandsMap.putIfAbsent(AUX2_Output_ON_CODE, ()=> 21);
    actionCommandsMap.putIfAbsent(AUX2_Output_OFF_CODE, ()=> 21);
    actionCommandsMap.putIfAbsent(SIREN_Nano_CODE, ()=> 15);
    actionCommandsMap.putIfAbsent(HARDWARE_VERSION_NANO_CODE, ()=> 5);
    actionCommandsMap.putIfAbsent(CheckSimCardCredit_Nano_CODE, ()=> 7);
    actionCommandsMap.putIfAbsent(ChargeSimCardCredit_Nano_CODE, ()=> 115);


    actionCommandsMap.putIfAbsent(TurboMode_ON_TAG, ()=> TurboMode_ON);
    actionCommandsMap.putIfAbsent(TurboMode_OFF_TAG, ()=> TurboMode_OFF);
    //actionCommandsMap.putIfAbsent(STATUS_CAR_TAG, ()=> 60);
    actionCommandsMap.putIfAbsent(SirenOn_ON_TAG, ()=> SirenOn_ON);
    actionCommandsMap.putIfAbsent(SirenOn_OFF_TAG, ()=> SirenOn_OFF);
    actionCommandsMap.putIfAbsent(RemoteStart_ON_TAG, ()=> RemoteStart_ON);
    actionCommandsMap.putIfAbsent(RemoteStart_OFF_TAG, ()=> RemoteStart_OFF);
    actionCommandsMap.putIfAbsent(TimeStart_ON_TAG, ()=> TimeStart_ON);
    actionCommandsMap.putIfAbsent(TimeStart_OFF_TAG, ()=> TimeStart_OFF);
    actionCommandsMap.putIfAbsent(PanicMode_ON_TAG, ()=> PanicMode_ON);
    actionCommandsMap.putIfAbsent(PanicMode_OFF_TAG, ()=> PanicMode_OFF);
    actionCommandsMap.putIfAbsent(ValetMOde_ON_TAG, ()=> ValetMOde_ON);
    actionCommandsMap.putIfAbsent(ValetMOde_OFF_TAG, ()=> ValetMOde_OFF);
    actionCommandsMap.putIfAbsent(AutoMode_ON_TAG, ()=> AutoMode_ON);
    actionCommandsMap.putIfAbsent(AutoMode_OFF_TAG, ()=> AutoMode_OFF);
    actionCommandsMap.putIfAbsent(OffMode_ON_TAG, ()=> OffMode_ON);
    actionCommandsMap.putIfAbsent(OffMode_OFF_TAG, ()=> OffMode_OFF);

    actionCommandsMap.putIfAbsent(DriveLock_ON_TAG, ()=> DriveLock_ON);
    actionCommandsMap.putIfAbsent(DriveLock_OFF_TAG, ()=> DriveLock_OFF);
    actionCommandsMap.putIfAbsent(PassiveMode_ON_TAG, ()=> PassiveMode_ON);
    actionCommandsMap.putIfAbsent(ShockSendsor_ON_TAG, ()=> ShockSendsor_ON);
    actionCommandsMap.putIfAbsent(ShockSendsor_OFF_TAG, ()=> ShockSendsor_OFF);
    actionCommandsMap.putIfAbsent(DriveLock_ON_TAG, ()=> DriveLock_ON);
    actionCommandsMap.putIfAbsent(DriveLock_OFF_TAG, ()=> DriveLock_OFF);
    actionCommandsMap.putIfAbsent(LowVoltageState_ON_TAG, ()=> LowVoltageState_ON);
    actionCommandsMap.putIfAbsent(LowVoltageState_OFF_TAG, ()=> LowVoltageState_ON);

  }

  static createActionCommandsNotiMap()
  {
    actionCommandsNotiMap.putIfAbsent(28, ()=>CAR_PAGE_TAG);
    actionCommandsNotiMap.putIfAbsent(30, ()=>ULTRA_SONIC_TAG);
    actionCommandsNotiMap.putIfAbsent(31, ()=>DISABLE_ULTRA_SONIC_TAG);
    actionCommandsNotiMap.putIfAbsent(11, ()=>OPEN_DOOR_TAG);
    actionCommandsNotiMap.putIfAbsent(10, ()=>CLOSE_DOOR_TAG);
    actionCommandsNotiMap.putIfAbsent(14, ()=>OPEN_TRUNK_TAG);
    actionCommandsNotiMap.putIfAbsent(0, ()=>CLOSE_TRUNK_TAG);
    actionCommandsNotiMap.putIfAbsent(0, ()=>OPEN_HOOD_TAG);
    actionCommandsNotiMap.putIfAbsent(0, ()=>CLOSE_HOOD_TAG);
    actionCommandsNotiMap.putIfAbsent(0, ()=>IGNITATION_TAG);
    actionCommandsNotiMap.putIfAbsent(0, ()=>DISABLE_IGNITATION_TAG);
    actionCommandsNotiMap.putIfAbsent(25, ()=>SHOCK_WARNING_TAG);
    actionCommandsNotiMap.putIfAbsent(26, ()=>DISABLE_SHOCK_WARNING_TAG);
    actionCommandsNotiMap.putIfAbsent(42, ()=>SHOCK_TRIGGER_TAG);

    carNotiMap.putIfAbsent(carEnum.CarStatus.ONLYDOOROPEN, ()=>300);
    carNotiMap.putIfAbsent(carEnum.CarStatus.ONLYCAPUTOPNE, ()=>200);
    carNotiMap.putIfAbsent(carEnum.CarStatus.BOTHCLOSED, ()=>100);
    carNotiMap.putIfAbsent(carEnum.CarStatus.ONLYTRUNKOPEN, ()=>400);
    carNotiMap.putIfAbsent(carEnum.CarStatus.BOTHOPEN, ()=>500);
    carNotiMap.putIfAbsent(carEnum.CarStatus.ALLOPEN, ()=>1000);


  }
}
