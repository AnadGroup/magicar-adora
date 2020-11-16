/*
import 'dart:core';

class DecodeData {

   List<String> getBodyRecords(String body) {

   List<String> result = new List();

    int bodyC = 1;
    if (!body.equals("")) {
      String tempTime = "";
      String tempN = "";
      String tempE = "";


      while (bodyC < body.length()) {
        int angle = 0;
        int tempAngle = 0;
        Boolean angleFlag = true;
        Boolean isGPS_Valid = true;

        while ((bodyC < body.length()) && (body.charAt(bodyC) != 'n')) {
          //Log.d("sss",String.valueOf(body.charAt(bodyC)));
          bodyC = bodyC + 1;
        }

        if ((bodyC < body.length()) && (body.charAt(bodyC) == 'n')) {
          String pT = fix2Char(body.charAt(bodyC + 1)) + ":" + fix2Char(body.charAt(bodyC + 2)) + ":" + fix2Char(body.charAt(bodyC + 3));
          String pNGeneral = fix2Char(body.charAt(bodyC + 4)) + "*" + fix2Char(body.charAt(bodyC + 5)) + "'" + fix2Char(body.charAt(bodyC + 6)) + "." + fix2Char(body.charAt(bodyC + 7)) + "0";
          String pEGeneral = fix2Char(body.charAt(bodyC + 8)) + "*" + fix2Char(body.charAt(bodyC + 9)) + "'" + fix2Char(body.charAt(bodyC + 10)) + "." + fix2Char(body.charAt(bodyC + 11)) + "0";
          float spd = (byte) (body.charAt(bodyC + 12));

          bodyC = bodyC + 1;

          String pN = "" + ne_To_Deg(pNGeneral);
          String pE = "" + ne_To_Deg(pEGeneral);

          if (tempTime == "") {
            isGPS_Valid = true;
          } else {
            isGPS_Valid = checkGPSValidation(tempTime, tempN, tempE, pT, pN, pE);
            try {
              angle = angleFromCoordinate(Double.parseDouble(pN), Double.parseDouble(pE), Double.parseDouble(tempN), Double.parseDouble(tempE));
            } catch (Exception e) {
    angle = -1;
    }
    angleFlag = false;
    }

    tempN = pN;
    tempE = pE;
    tempTime = pT;
    if (isGPS_Valid && (angleFlag || Math.abs(tempAngle - angle) > 25)) {
    String res = pT + "," + pNGeneral + "," + pN + "," + pEGeneral + "," + pE + "," + spd;
    result.add(res);

    }
  }

  }
  }

    return result;
  }


   double ne_To_Deg(String s) {
    double temp = 0;
    try {

      String[] star = s.split("\\*");
      String[] min = star[1].split("\\'");
      String[] sec = min[1].split("\\.");

      double L = Double.valueOf(min[0]) / 60;
      L = L + Double.valueOf(sec[0]) / (60 * 60);
      L = L + Double.valueOf(sec[1]) / (60 * 60 * 1000);
      temp += Double.valueOf(star[0]) + L;
    } catch (Exception exp) {
    temp = 0;
    }

    return temp;
  }

   String fix2Char(char L) {
    String Result = "" + (int) L;
    if (Result.length() < 2)
      Result = "0" + Result;
    return Result;
  }

   bool checkGPSValidation(String OldTime, String OldN, String OldE, String CurrentTime, String CurrentN, String CurrentE) {
    double DeltaD = 0;
    double DeltaT = 0;
    double V = 0;
    DeltaT = getDeltaTime(CurrentTime, OldTime);
    DeltaD = getDeltaDistance(CurrentN, CurrentE, OldN, OldE);
    V = 0;
    try {
      V = DeltaD / DeltaT;
    } catch (Exception e) {
    V = 0;
    }
    if (DeltaD > 2)
    return false;
    else
    return true;
  }

   double getDeltaDistance(String CurrentN, String CurrentE, String OldN, String OldE) {
    return getDeltaDistance(Double.valueOf(CurrentN), Double.valueOf(CurrentE), Double.valueOf(OldN), Double.valueOf(OldE));
  }

   double getDeltaDistance(double Lat1, double Long1, double Lat2, double Long2) {
    double dDistance = Double.MIN_VALUE;
    double dLat1InRad = Lat1 * (Math.PI / 180.0);
    double dLong1InRad = Long1 * (Math.PI / 180.0);
    double dLat2InRad = Lat2 * (Math.PI / 180.0);
    double dLong2InRad = Long2 * (Math.PI / 180.0);
    double dLongitude = dLong2InRad - dLong1InRad;
    double dLatitude = dLat2InRad - dLat1InRad;
    double a = Math.sin(dLatitude / 2) * Math.sin(dLatitude / 2) +
        Math.cos(dLat1InRad) * Math.cos(dLat2InRad) *
            Math.sin(dLongitude / 2) * Math.sin(dLongitude / 2);
    double c = 2.0 * Math.asin(Math.sqrt(a));
    final Double kEarthRadiusKms = 6367.5;
    dDistance = kEarthRadiusKms * c;
    return dDistance;
  }

   int getDeltaTime(String CurrentTime, String OldTime) {
    String[] ct = CurrentTime.split(":", -1);
    String[] ot = OldTime.split(":", -1);
    int ict = Integer.parseInt(ct[0] + "") * 3600 + Integer.parseInt(ct[1] + "") * 60 + Integer.parseInt(ct[2] + "");
    int iot = Integer.parseInt(ot[0] + "") * 3600 + Integer.parseInt(ot[1] + "") * 60 + Integer.parseInt(ot[2] + "");
    return ict - iot;
  }

   int angleFromCoordinate(double lat1, double long1, double lat2, double long2) {
    int Angel = 0;
    try {
      double direction = Math.atan2(lat1 - lat2, long1 - long2);
      direction = Math.toDegrees(direction);
      Angel = Integer.parseInt(Math.round(direction + 360) + "");
      Angel = Angel % 360;
      Angel = 360 - Angel;
      Angel = (Angel / 15) * 15;
      if (Angel == 360) Angel = 0;
    } catch (Exception e) {
    }
    return Angel;
  }

   String code_Pass(String s) {
    int l = 0;
    for (int i = 0; i < s.length(); ++i) {
      l = l * 7;
      l = l + (byte) s.charAt(i);
    }
    return "" + l;
  }
}
*/
