import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/service_type.dart';

import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';

import 'package:flutter/material.dart';
import 'package:anad_magicar/ui/screen/service/service_item_slideable.dart';

class ServiceForm extends StatefulWidget {
  int carId;
  ServiceVM serviceVM;
  List<ApiService> servcies;
  ServiceForm({Key key,this.carId,this.serviceVM,this.servcies}) : super(key: key);

  @override
  _ServiceFormState createState() {
    return _ServiceFormState();
  }
}

class _ServiceFormState extends State<ServiceForm> {

  List<ServiceType> servcieTypes=new List();

  @override
  void initState() {
    servcieTypes=centerRepository.getServiceTypes();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
            new Padding(padding: EdgeInsets.only(top: 6.0,bottom: 20.0),
              child:
              Container(
                child: StreamBuilder<Message>(
                  stream: changeServiceNotyBloc.noty,
                  builder: (context,snapshot) {
                    if(snapshot.hasData && snapshot.data!=null){
                      Message msg=snapshot.data;
                      if(msg.type=='SERVICE_DELETED'){
                        widget.servcies.removeWhere((s)=>s.ServiceId==msg.index);
                      }
                    }
                    return
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: widget.servcies.length,
                        itemBuilder: (context, index) {
                          ApiService sTemp = widget.servcies[index];
                          var sT = servcieTypes.where((s) =>
                          s.ServiceTypeId ==
                              widget.servcies[index].ServiceTypeId).toList();
                          ServiceType sType;
                          if (sT != null && sT.length > 0) {
                            sType = sT.first;
                            sTemp.serviceType = sType;
                          }
                          sTemp.car=widget.serviceVM.car;
                         // return ServiceItem(serviceItem: sTemp);
                          return ServiceItemSlideable(serviceItem: sTemp);
                        });
                  }
    ),
              ),
            );


  }
}

NotyBloc<Message> changeServiceNotyBloc=new NotyBloc<Message>();
