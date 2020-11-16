import 'package:anad_magicar/model/plan_detail_model.dart';
import 'package:anad_magicar/model/plan_model.dart';
import 'package:flutter/material.dart';

class InitPlanData {

  List<PlanModel> plans;
  PlanDetailModel planDetail;

  InitPlanData({
    @required this.plans,
    @required this.planDetail,
  });

  Map<String, dynamic> toMap() {
    return {
      'plans': this.plans.map((p) => p.toMap()).toList(),
      'planDetail': this.planDetail.toMap(),
    };
  }

  factory InitPlanData.fromMap(Map<String, dynamic> map) {
    return new InitPlanData(
      plans: (map['plans']).map((p) => PlanDetailModel.fromMap(p)).toList(),
      planDetail: PlanDetailModel.fromMap( map['planDetail']),
    );
  }

  factory InitPlanData.fromJson(Map<String, dynamic> json) {
    return InitPlanData(plans: (json["plans"]).map((p) => PlanModel.fromJson(p)).toList(),
      planDetail: PlanDetailModel.fromJson(json["planDetail"]),);
  }

  Map<String, dynamic> toJson() {
    return {"plans": this.plans.map((p) => p.toJson()).toList(), "planDetail": this.planDetail.toJson(),};
  }


}