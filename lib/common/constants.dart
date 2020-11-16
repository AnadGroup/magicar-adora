import 'dart:collection';

import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart' as mat;
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum RoutingType {DRIVING,WALKING,AIR}

class Constants {

  static final int ROWSTATE_TYPE_INSERT=1;
  static final int ROWSTATE_TYPE_UPDATE=2;
  static final int ROWSTATE_TYPE_DELETE=4;

  static final int SERVICE_DONE=152364;
  static final int SERVICE_FAILD=152374;
  static final int SERVICE_NEAR=152375;
  static final int SERVICE_NOTDONE=152376;
  static final int SERVICE_CANCEL=152377;

  static final int SERVICE_DURATION_YEAR=152368;
  static final int SERVICE_DURATION_MONTH=152350;
  static final int SERVICE_DURATION_DAY=152351;

  static final int SERVICE_TYPE_FUNCTIONALITY=152353;
  static final int SERVICE_TYPE_DURATIONALITY=152354;
  static final int SERVICE_TYPE_BOTH=152365;

  static final String SERVICE_TYPE_FUNCTIONALITY_TITLE=Translations.current.functional();
  static final String SERVICE_TYPE_DURATIONALITY_TITLE=Translations.current.durational();
  static final String SERVICE_TYPE_BOTH_TITLE=Translations.current.both();


  static final String SERVICE_DURATION_YEAR_TITLE=Translations.current.durationYear();
  static final String SERVICE_DURATION_MONTH_TITLE=Translations.current.durationMonth();
  static final String SERVICE_DURATION_DAY_TITLE=Translations.current.durationDay();

  static final int SMS_STATUS_AS_READ=12354;

  static RegExp _pelak =new RegExp(r'^[0-9]{2}-[a-zA-Z]{1}-3[0-9]{3}-[0-9]{2}$');
  static String  POWER_ENGINE_START_SOUND='start_power.mp3';
  static String  POWER_ENGINE_OFF_SOUND='off.mp3';
   static String  DOOR_OPEN_SOUND='car_door_open.mp3';
   static String  DOOR_LOCK_SOUND='car_door_close.mp3';

   static String  TRUNK_CLOSE_SOUND='trunk_close.mp3';
   static String  TRUNK_OPEN_SOUND='open_trunk.mp3';

  static var maskPelakFormatter = new MaskTextInputFormatter(mask: '###-##-@-##', filter: { "@" : RegExp(r'[A-Za-z]') ,"#": RegExp(r'[0-9]'),});

   static final String LOCK_IMAGE_ASSETS='assets/images/lock_11.png';
   static final String UNLOCK_IMAGE_ASSETS='assets/images/unlock_22.png';
   static final String POWER_IMAGE_ASSETS='assets/images/engine_start.png';
   static final String TRUNK_IMAGE_ASSETS='assets/images/trunk.png';
   static final String CAPUT_IMAGE_ASSETS='assets/images/lock_11.png';
   static final String FIND_CAR_IMAGE_ASSETS='assets/images/findcar_3.png';
   static final String MAP_IMAGE_ASSETS='assets/images/lock_11.png';
   static final String ALARM_IMAGE_ASSETS='assets/images/lock_11.png';
   static final String AUX1_IMAGE_ASSETS='assets/images/aux1.png';
   static final String AUX2_IMAGE_ASSETS='assets/images/aux2.png';
   static final String _IMAGE_ASSETS='assets/images/lock_11.png';

  static final String CAR_IMAGE_BLACK='assets/images/car_black.png';
  static final String CAR_IMAGE_BLUE='assets/images/car_blue.png';
  static final String CAR_IMAGE_RED='assets/images/car_red.png';
  static final String CAR_IMAGE_YELLOW='assets/images/car_yellow.png';
  static final String CAR_IMAGE_GRAY='assets/images/car_gray.png';
  static final String CAR_IMAGE_WHITE='assets/images/car_white.png';

  static final String CAR_COMMANDS_TITLE_MAP_KEY='CAR_COMMANDS_TITLE_MAP';
  static final int MAX_CAR_COUNTS=20;

   static HashMap<String,String>  soundToActionMap=new HashMap();
   static HashMap<String,String>  statusPlanMap=new HashMap();
   static HashMap<String,String>  typPlanMap=new HashMap();
   static HashMap<int,String>  carColorsMap=new HashMap();
   static HashMap<int,mat.MaterialColor>  carColorsMatMap=new HashMap();
   static HashMap<int,Color>  colorIdToColorsMap=new HashMap();
   static HashMap<RoutingType,String>  routingTypeMap=new HashMap();
   static HashMap<int,String> carImagesInColorMap=new HashMap();
  static HashMap<String,String> carCommandsInTitlesMap=new HashMap();

  static List<Color> colors=[
    Colors.redAccent,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.black,
    Colors.black38,
    Colors.black54,

   ];

  static createCarCommandInTitlesMap() {
    if(carCommandsInTitlesMap==null)
      carCommandsInTitlesMap=new HashMap();
        //carCommandsInTitlesMap.putIfAbsent('62', ()=>'');
    carCommandsInTitlesMap.putIfAbsent('63', ()=>'Ultra Sonic');
    carCommandsInTitlesMap.putIfAbsent('64', ()=>'Door Open');
    carCommandsInTitlesMap.putIfAbsent('65', ()=>'Trunk Open');
    carCommandsInTitlesMap.putIfAbsent('66', ()=>'Hood Open');
    carCommandsInTitlesMap.putIfAbsent('67', ()=>'Ignition');
    carCommandsInTitlesMap.putIfAbsent('68', ()=>'Shock warning');
    carCommandsInTitlesMap.putIfAbsent('69', ()=>'Shock Trigger');
    carCommandsInTitlesMap.putIfAbsent('28', ()=>'Car Call');

  }
  static createCarImageInColorMap() {
    if(carImagesInColorMap==null)
      carImagesInColorMap=new HashMap();
    carImagesInColorMap.putIfAbsent(CAR_COLOR_BLACK_TAG, ()=>CAR_IMAGE_BLUE);
    carImagesInColorMap.putIfAbsent(CAR_COLOR_GREY_TAG, ()=>CAR_IMAGE_GRAY);
    carImagesInColorMap.putIfAbsent(CAR_COLOR_RED_TAG, ()=>CAR_IMAGE_RED);
    carImagesInColorMap.putIfAbsent(CAR_COLOR_WHITE_TAG, ()=>CAR_IMAGE_WHITE);
    carImagesInColorMap.putIfAbsent(CAR_COLOR_YELLOW_TAG, ()=>CAR_IMAGE_YELLOW);

  }
   static createSoundToActionMap()
   {
      soundToActionMap.putIfAbsent(ActionsCommand.LockAndArm_Nano_CODE,()=> DOOR_LOCK_SOUND);
      soundToActionMap.putIfAbsent(ActionsCommand.UnlockAndDisArm_Nano_CODE,()=> DOOR_OPEN_SOUND);
      soundToActionMap.putIfAbsent(ActionsCommand.RemoteStartOn_Nano_CODE,()=> POWER_ENGINE_START_SOUND);
      soundToActionMap.putIfAbsent(ActionsCommand.RemoteStartOff_Nano_CODE,()=> POWER_ENGINE_OFF_SOUND);
      soundToActionMap.putIfAbsent(ActionsCommand.RemoteTrunk_Release_CODE,()=> TRUNK_OPEN_SOUND);
   }

   static createPlanTypeAndStatusMap()
   {
      typPlanMap.putIfAbsent(DORE_CONST_ID_TAG,()=> "152335");
      typPlanMap.putIfAbsent(KARKARDI_CONST_ID_TAG,()=> "152336");
      typPlanMap.putIfAbsent(DORE_KARKARD_CONST_ID_TAG,()=> "152337");

      statusPlanMap.putIfAbsent(PLAN_STATUS_NOT_PAYMENT_CONST_ID_TAG, ()=> '152338');
      statusPlanMap.putIfAbsent(PLAN_STATUS_DEACTIVE_CONST_ID_TAG, ()=> '152339');
      statusPlanMap.putIfAbsent(PLAN_STATUS_ACTIVE_CONST_ID_TAG, ()=> '152340');
      statusPlanMap.putIfAbsent(PLAN_STATUS_PAID_CONST_ID_TAG, ()=> '152341');

   }
  static createRouteTypeMap() {
     routingTypeMap=new HashMap();
     routingTypeMap.putIfAbsent(RoutingType.DRIVING, ()=> 'driving-car');
     routingTypeMap.putIfAbsent(RoutingType.WALKING, ()=> 'foot-walking');
     routingTypeMap.putIfAbsent(RoutingType.AIR, ()=> 'air');

   }
   static final String DORE_CONST_ID_TAG="152335";
   static final String KARKARDI_CONST_ID_TAG="152336";
   static final String DORE_KARKARD_CONST_ID_TAG="152337";

   static final String PLAN_STATUS_NOT_PAYMENT_CONST_ID_TAG="152338";
   static final String PLAN_STATUS_DEACTIVE_CONST_ID_TAG="152339";
   static final String PLAN_STATUS_ACTIVE_CONST_ID_TAG="152340";
   static final String PLAN_STATUS_PAID_CONST_ID_TAG="152341";

   static final int CAR_TO_USER_STATUS_WAITING_TAG=152348;
   //static final int CAR_TO_USER_STATUS_CONFIRMED_TAG=152349;
  static final int CAR_TO_USER_STATUS_CONFIRMED_TAG=1;

   static final int CAR_COLOR_BLACK_TAG=152330;
   static final int CAR_COLOR_WHITE_TAG=152331;
   static final int CAR_COLOR_GREY_TAG=152332;
   static final int CAR_COLOR_RED_TAG=152333;
   static final int CAR_COLOR_YELLOW_TAG=152334;


   static createCarColorsMap()
   {

      carColorsMap.putIfAbsent(CAR_COLOR_BLACK_TAG, ()=>'BLACK');
      carColorsMap.putIfAbsent(CAR_COLOR_WHITE_TAG, ()=>'WHITE');
      carColorsMap.putIfAbsent(CAR_COLOR_GREY_TAG, ()=>'GREY');
      carColorsMap.putIfAbsent(CAR_COLOR_RED_TAG, ()=>'RED');
      carColorsMap.putIfAbsent(CAR_COLOR_YELLOW_TAG, ()=>'YELLOW');

      carColorsMatMap.putIfAbsent(CAR_COLOR_BLACK_TAG, ()=>mat.MaterialColor.BLACK);
      carColorsMatMap.putIfAbsent(CAR_COLOR_WHITE_TAG, ()=>mat.MaterialColor.WHITE);
      carColorsMatMap.putIfAbsent(CAR_COLOR_GREY_TAG, ()=>mat.MaterialColor.GREY);
      carColorsMatMap.putIfAbsent(CAR_COLOR_RED_TAG, ()=>mat.MaterialColor.RED);
      carColorsMatMap.putIfAbsent(CAR_COLOR_YELLOW_TAG, ()=>mat.MaterialColor.YELLOW);

      colorIdToColorsMap.putIfAbsent(CAR_COLOR_BLACK_TAG, ()=>colors[4]);
     // colorIdToColorsMap.putIfAbsent(CAR_COLOR_BLUE_TAG, ()=>colors[1]);
      colorIdToColorsMap.putIfAbsent(CAR_COLOR_GREY_TAG, ()=>colors[6]);
      colorIdToColorsMap.putIfAbsent(CAR_COLOR_WHITE_TAG, ()=>colors[5]);
      colorIdToColorsMap.putIfAbsent(CAR_COLOR_RED_TAG, ()=>colors[0]);
      colorIdToColorsMap.putIfAbsent(CAR_COLOR_YELLOW_TAG, ()=>colors[3]);

   }
}
