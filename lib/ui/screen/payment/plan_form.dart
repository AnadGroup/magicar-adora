import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/data/ds/plan_detail_ds.dart';
import 'package:anad_magicar/data/ds/plan_ds.dart';
import 'package:anad_magicar/model/plan_model.dart';
import 'package:anad_magicar/model/viewmodel/init_plan_data.dart';
import 'package:flutter/material.dart';

class PlanForm extends StatefulWidget {



  PlanForm({Key key}) : super(key: key);

  @override
  _PlanFormState createState() {
    return _PlanFormState();
  }
}

class _PlanFormState extends State<PlanForm> {


  Future<List<PlanModel>> planModel;
  Future<InitPlanData> initPlans;
  PlanDS planDS;
  PlanDetailDS planDetailDS;

  Future<InitPlanData> loadPlan() async {
    List<PlanModel> planList = await planDS.getAll(BaseRestDS.GET_PLANS_URL);
    InitPlanData planData = new InitPlanData(plans: planList, planDetail: null);
    return planData;
  }

  buildInfoRows(PlanModel plan) {
    return new Row(
      children: <Widget>[
        new Text('')
      ],
    );
  }

  buildRemainChargeUI(PlanModel plan) {

  }

  @override
  void initState() {
    super.initState();
    initPlans = loadPlan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      FutureBuilder<InitPlanData>(
          future: initPlans,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null) {
              InitPlanData result = snapshot.data;

              return
                new Column(
                  children: <Widget>[
                    buildInfoRows(result.plans[0]),
                    buildRemainChargeUI(result.plans[0]),
                  ],
                );
            }
            return CircularProgressIndicator();
          }
      ),
    );
  }
}