import 'package:anad_magicar/bloc/car/register.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/components/car/car_utils.dart';
import 'package:anad_magicar/components/switch_button.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/action_to_role_model.dart';
import 'package:anad_magicar/model/actions.dart';
import 'package:anad_magicar/model/apis/accessable_actions.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/apis/current_user_accessable_action.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/viewmodel/accessable_action_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/service/command_builder.dart';
import 'package:anad_magicar/service/do_command.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/style/app_style.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/magicar_appbar.dart';
import 'package:anad_magicar/widgets/magicar_appbar_title.dart';
import 'package:flutter/material.dart';

class UserAccessPage extends StatefulWidget {

  ApiRelatedUserModel userModel;
  AccessableActionVM accessableActionVM;


  UserAccessPage({Key key,this.userModel,
  this.accessableActionVM,
  }) : super(key: key);

  @override
  _UserAccessPageState createState() {
    return _UserAccessPageState();
  }
}

class _UserAccessPageState extends State<UserAccessPage> {


  CommandBuilder _commandBuilder;
  bool actionSelected=false;
  int  _actionCounts=0;
  int _carCounts=0;
  List<Car> cars;
  List<AdminCarModel> adminCars;
  List<ActionModel> actions;
  List<SwitchItem> switchItems;
  List<CurrentUserAccessableActionModel> accessToActions=new List();
  Future<List<CurrentUserAccessableActionModel>> userAccessables;

  Future<List<CurrentUserAccessableActionModel>> loadUserAccessables() async {
      RestDatasource restDS=new RestDatasource();
      centerRepository.showProgressDialog(context, Translations.current.loadingdata());
      var cars_temp=await restDS.getAllCarsByUserId(widget.accessableActionVM.userModel.userId);
      var result;
      List<CurrentUserAccessableActionModel> results=new List();
      List<AccessableActions> actions=new List();
       ActionsCommand.actionsTitleMap.forEach((k,v) {
         AccessableActions action=new AccessableActions(ActionTitle: k,
             ActionId: 0, ActionCode: k, IsActive: null);
         actions..add(action);
       });
       results..add(new CurrentUserAccessableActionModel(UserId: widget.accessableActionVM.userModel.userId,
           RoleId: widget.accessableActionVM.userModel.roleId,
           CarId: widget.accessableActionVM.carId,
           RoleTitle: null, Description: null,
           accessableActions: actions));
      //await restDS.getGetCurrentUserAccessableActions(widget.accessableActionVM.userModel.userId);
      if(results!=null &&
          cars_temp!=null) {
        _carCounts=cars_temp.length;
        if(widget.accessableActionVM.isFromMainAppForCommand!=null &&
        widget.accessableActionVM.isFromMainAppForCommand)
          {
            adminCars=cars_temp.where((c)=>c.CarId==widget.accessableActionVM.carId).toList();
          }
        else
          {
            adminCars=cars_temp;
          }
        switchItems=new List();

        return results;
      }
      return null;
  }

  sendCommand(String actionCode,
      int carId,
      int userId)
  {
    _commandBuilder=new CommandBuilder(
        sendCommandModel: widget.accessableActionVM.sendCommandModel,
        sendingCommandVM: widget.accessableActionVM.sendingCommandVM,
        sendCommandNoty: widget.accessableActionVM.sendingCommandNoty,
        carStateNoty: widget.accessableActionVM.carStateNoty,
        carStateVM: widget.accessableActionVM.carStateVM,
        actionCode: actionCode,
        userId: userId,
        carId: carId);
    DoCommand command= _commandBuilder.commandBuild();
    command.sendCommand();
  }
  getCarTiles(AdminCarModel car)
  {
    if (car != null) {
      Car cr=centerRepository.getCarByCarId(car.CarId);
        String name=cr.brandTitle;
        String desc=cr.description;
        String pelaque=cr.pelaueNumber;
        return ListTile(
          title: Text(name),
          subtitle: Text( ' # '+ Translations.current.carpelak()+' : '+ pelaque),
          trailing: new Image.asset(''),
        );
    }
  }

  List<Widget> getActionsTiles(int carId) {
    List<Widget> list = [];
    String actionName='';
    ActionModel actModel;
    String desc='';
    bool selected=true;
    if (widget.accessableActionVM!=null && accessToActions != null) {
        List<CurrentUserAccessableActionModel> actionToAccess=accessToActions.where((ac)=>ac.CarId==carId).toList();
        if(actionToAccess!=null && actionToAccess.length>0) {
         for(CurrentUserAccessableActionModel act in actionToAccess){

        int roleId = act.RoleId;
        if (centerRepository.getActionToRoles() != null &&
            centerRepository
                .getActionToRoles()
                .length > 0) {
          List<ActionToRoleModel> actionToRoleModel = centerRepository
              .getActionToRoles().where((r) => r.RoleId == roleId).toList();
          if (actionToRoleModel != null &&
              actionToRoleModel.length > 0) {
            ActionToRoleModel aToRoleModel = actionToRoleModel.first;
            for (AccessableActions accessableActions in act.accessableActions) {
              List<ActionModel> actionModel = centerRepository.getActions()
                  .where((ac) => ac.ActionId == accessableActions.ActionId &&
                  ActionsCommand.hasActions(ac.ActionTitle)==true).toList();

              if (actionModel != null &&
                  actionModel.length > 0) {
                actModel = actionModel.first;

                actionName = actModel.ActionTitle;
                desc = actModel.Description;
                selected = actModel.IsActive;

                list.add(ListTile(
                  title: Text(actionName),
                  subtitle: Text(
                      ' # ' + Translations.current.description() + ' : ' +
                          desc),
                  trailing: GestureDetector(
                    onTap: () {
                      actModel.selected = !selected;
                    },
                    child: Switch( onChanged: (value) {
                    },
                      value: false,),
                  ),
                ),
                );
              }
            }
          }
        }
          }
        }
     // }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();

    ActionsCommand.createActionsTitleMap();
    _actionCounts=
    centerRepository.getActions()!=null ?
    centerRepository.getActions().length : 0;
    _carCounts=
        centerRepository.getCars()!=null ?
            centerRepository.getCars().length : 0;

    actions=new List();
    cars=new List();

    userAccessables=loadUserAccessables();

  }

  @override
  void dispose() {
    super.dispose();
  }

  List<SwitchItem> generateSwitchItems(int numberOfItems,List<AccessableActions> accessActions) {
    String actionTitle='';
    String actionCode='';
    return List.generate(numberOfItems, (int index) {

          actionTitle = accessActions[index].ActionTitle;
          actionCode = accessActions[index].ActionCode;
      return SwitchItem(
        headerValue: 'Action $index',
        expandedValue: 'No. $index',
        selected: true,
        actionTitle: actionTitle,
        actionCode: actionCode
      );
    });
  }

  List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
  return Item(
  headerValue: 'Panel $index',
  expandedValue: 'This is item number $index',
  );
  });
  }

  Widget _buildPanel() {
    List<Item> _data = generateItems(8);
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle: Text('To delete this panel, tap the trash can icon'),
              trailing: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              }
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _buildActionsPanel( int carId) {
    //List<Widget> list=new List();
    Car car_temp;
    String brandTitle='';
   // for(var cr in cars) {
      List<CurrentUserAccessableActionModel> actionToAccess = accessToActions
          .where((ac) => ac.CarId == carId).toList();
      if(centerRepository.getCars()!=null) {
        car_temp = centerRepository
            .getCars()
            .where((c) => c.carId == carId)
            .toList()
            .first;
        if(car_temp!=null)
          brandTitle=car_temp.brandTitle;
      }

      if (actionToAccess != null && actionToAccess.length > 0) {
        return ExpansionPanelList(

          expansionCallback: (int index, bool isExpanded) {
             /* setState(() {
                actionToAccess.first.accessableActions[index].isExpanded=!isExpanded;
              });*/
          },
          children: actionToAccess.first.accessableActions.map<ExpansionPanel>((
              AccessableActions item) {
            ActionModel actionModel;
            String actionTitle = '';
            String actionCode = '';
            if (centerRepository.getActions() != null)
              actionModel = centerRepository
                  .getActions()
                  .where((a) => a.ActionId == item.ActionId)
                  .toList()
                  .first;
            if (actionModel != null) {
              actionTitle = actionModel.ActionTitle;
              actionCode = actionModel.ActionCode;
            }
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(DartHelper.isNullOrEmptyString(brandTitle)),
                );
              },
              body:
                ListTile(
                    title: Text(DartHelper.isNullOrEmptyString(actionTitle)),
                    subtitle: SwitchListTile(
                        selected: item.IsActive,
                        value: item.IsActive),
                    trailing: Icon(Icons.info_outline),
                    onTap: () {

                    }
                ),
              isExpanded: true,
            );
          }).toList(),
        );
    //  }
    }
  }

  Widget _buildActionsRow(  AccessableActions item,int carId) {
    //List<Widget> list=new List();
    Car car_temp;
    String brandTitle='';
    // for(var cr in cars) {

 /*   if(centerRepository.getCars()!=null) {
      car_temp = centerRepository
          .getCars()
          .where((c) => c.carId == carId)
          .toList()
          .first;
      if(car_temp!=null)
        brandTitle=car_temp.brandTitle;
    }*/


          SwitchItem switchItem;
          ActionModel actionModel;
          String actionTitle = '';
          String actionCode = '';
          if (centerRepository.getActions() != null)
            actionModel = centerRepository
                .getActions()
                .where((a) => a.ActionId == item.ActionId)
                .toList()
                .first;
          if (actionModel != null) {
            actionTitle = actionModel.ActionTitle;
            actionCode = actionModel.ActionCode;
            switchItem=new SwitchItem(actionCode: actionCode,
            actionTitle: actionTitle,
            selected: true);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                //Text(DartHelper.isNullOrEmptyString(brandTitle)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                  Padding(padding: EdgeInsets.only(right: 5.0,left: 5.0),
                    child:
                    Text(DartHelper.isNullOrEmptyString(switchItem.actionTitle),style: TextStyle(color: Theme.of(context).textTheme.body1.color),),),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          switchItem.selected=!switchItem.selected;
                        });
                      },
                      child: Switch(value: switchItem.selected, onChanged: (value) {
                        if(value)
                          {
                            sendCommand(switchItem.actionCode, carId, widget.userModel.userId);
                          }
                        else{

                        }
                    }, ),
                    ),
                  ],
                )

            ],
          );
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  FutureBuilder<List<CurrentUserAccessableActionModel>>(
        future: userAccessables,
        builder: (context, snapshot)
    {
      if (snapshot.hasData && snapshot.data != null) {
        centerRepository.dismissDialog(context);
        accessToActions = snapshot.data;
        List<CurrentUserAccessableActionModel> actionToAccess = accessToActions
            .where((ac) => ac.CarId == widget.accessableActionVM.carId).toList();
          switchItems=generateSwitchItems(actionToAccess.first.accessableActions.length, actionToAccess.first.accessableActions);
        return
          Stack(
            children: <Widget>[

          Padding(padding: EdgeInsets.only(top: 60.0),
      child:
      Container(
      height: MediaQuery.of(context).size.height,
      child:
          ListView(
            children:
              switchItems.map<Column>((SwitchItem si) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //Text(DartHelper.isNullOrEmptyString(brandTitle)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Padding(padding: EdgeInsets.only(right: 5.0,left: 5.0),
                          child:
                          Text(DartHelper.isNullOrEmptyString(si.actionTitle),
                          style: TextStyle(color: Theme.of(context).textTheme.title.color),),),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              switchItems.where((s)=>s.actionTitle==si.actionTitle).toList().first.selected=!si.selected;
                            });
                          },
                          child: Switch(value: si.selected,
                            onChanged: (value) {
                              String actionCode='';
                              if(value)
                                {
                                  actionCode=ActionsCommand.actionsTitleMap[si.actionCode][0];
                                }
                              else{
                                actionCode=ActionsCommand.actionsTitleMap[si.actionCode][1];
                              }
                              sendCommand(actionCode, widget.accessableActionVM.carId, widget.accessableActionVM.userModel.userId);

                          }, ),
                        ),
                      ],
                    )

                  ],
                );
              }).toList(),
          ),
     /* ListView.builder(
             itemCount: actionToAccess.first.accessableActions.length,
      itemBuilder: (context,index) {
        return
          Container(
            width: MediaQuery.of(context).size.width,
            height: 68.0,
              child: _buildActionsRow(actionToAccess.first.accessableActions[index],
                  widget.accessableActionVM.carId)
          );
      }
      ),*/
      ),
          ),

              Positioned(
                child: new MagicarAppbar(
                  backgroundColorAppBar: Colors.transparent,
                  title: new MagicarAppbarTitle(
                    currentColor: Colors.indigoAccent,
                   actionIcon: null,
                    actionFunc: () {},
                  ),
                  actionsAppBar: null,
                  elevationAppBar: 0.0,
                  iconMenuAppBar: Icon(
                    Icons.arrow_back, color: Colors.indigoAccent,),
                  toggle: () {Navigator.of(context).pop();},
                ),
              ),
            ],
          );
      }
      else
        {
          return Container(width: 0.0,height: 0.0,);
        }
  },
    ),
    );
  }
}
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class SwitchItem {
  SwitchItem({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
    this.selected=true,
    this.actionTitle,
    this.actionCode
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  bool selected;
  String actionTitle;
  String actionCode;
}
