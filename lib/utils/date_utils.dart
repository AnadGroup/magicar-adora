

import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:intl/intl.dart';
import 'dart:math' as mat;

class DateTimeUtils{

 static DateTime convertIntoDateTimeObject(String dateTime)
 {
   String newDT=dateTime;
   try {
     if(dateTime.contains('/')){
       newDT=dateTime.replaceAll('/', '-');
     }
     DateTime dateTimeObj = new DateFormat("yyyy-MM-dd hh:mm:ss", "en-US")
         .parse(newDT);
     if (dateTimeObj != null)
       return dateTimeObj;
   }
   catch(e){
     print(e.toString());
     return null;
   }
   return null;
 }


  static String getDateNow() {
   DateTime today=DateTime.now();
   String dateTimeObj = new DateFormat("yyyyMMdd", "en-US")
       .format(today);
   if (dateTimeObj != null)
     return dateTimeObj;
   return '';
  }
 static String getDateFrom(DateTime from) {
   //DateTime today=DateTime.now();
   if(from!=null) {
     String dateTimeObj = new DateFormat("yyyyMMdd", "en-US")
         .format(from);
     if (dateTimeObj != null)
       return dateTimeObj;
   }
   return '';
 }
 static String getTimeNowString() {
   DateTime today=DateTime.now();
   String dateTimeObj = new DateFormat("hhmmss", "en-US")
       .format(today);
   if (dateTimeObj != null)
     return dateTimeObj;
   return '';
 }

 static String getTimeFrom(DateTime from) {
   //DateTime today=DateTime.now();
   if(from!=null) {
     String dateTimeObj = new DateFormat("HHmmss", "en-US")
         .format(from);
     if (dateTimeObj != null)
       return dateTimeObj;
   }
   return '';
 }

 static DateTime convertIntoDateObject(String dateTime)
 {
   try {
     if(dateTime.contains('/')){
       dateTime=dateTime.replaceAll('/', '-');
     }
     DateTime dateTimeObj = new DateFormat("yyyy-MM-dd", "en-US")
         .parse(dateTime);
     if (dateTimeObj != null)
       return dateTimeObj;
   }
   catch(e){
     print(e.toString());
     return null;
   }
   return null;
 }


 static DateTime convertIntoTimeOnly2(String dateTime) {
   try {
     DateTime dateTimeObj = new DateFormat("HH:mm:ss", "en-US")
         .parse(dateTime);
     if (dateTimeObj != null)
       return dateTimeObj;
   }
   catch(e){
     print(e.toString());
     return null;
   }
   return null;
 }

 static DateTime convertIntoTimeOnly(String dateTime) {
   String newTime=dateTime;
   try {
     var timeValues=dateTime.split(':');
     if(timeValues!=null && timeValues.length==2) {
         newTime=dateTime+':00';
       } else if(timeValues!=null && timeValues.length==2) {}

     DateTime dateTimeObj = new DateFormat("HH:mm:ss", "en-US")
         .parse(newTime);
     if (dateTimeObj != null)
       return dateTimeObj;
   }
   catch(e){
     print(e.toString());
     return null;
   }
   return null;
 }

 static double diffDaysFromDateToDate(String fromDate,String toDate)
 {
    String fromDate_temp=DartHelper.isNullOrEmptyString(fromDate);
    String toDate_temp=DartHelper.isNullOrEmptyString(toDate);
    if(fromDate_temp==null || fromDate_temp.isEmpty)
      fromDate_temp='0/0/0';
    if(toDate_temp==null || toDate_temp.isEmpty)
      toDate_temp='0/0/0';

    var fDate=fromDate_temp.split('/');
   var tDate=toDate_temp.split('/');

    int fy=int.tryParse( DartHelper.isNullOrEmpty( fDate[0]) ? 0 : fDate[0]);
    int ty=int.tryParse(DartHelper.isNullOrEmpty( tDate[0]) ? 0 : tDate[0]);

   int fm=int.tryParse( DartHelper.isNullOrEmpty( fDate[1]) ? 0 : fDate[1]);
   int tm=int.tryParse( DartHelper.isNullOrEmpty( tDate[1]) ? 0 : tDate[1]);

   int fd=int.tryParse( DartHelper.isNullOrEmpty( fDate[2]) ? 0 : fDate[2]);
   int td=int.tryParse( DartHelper.isNullOrEmpty( tDate[2]) ? 0 : tDate[2]);

   Jalali fromJ=Jalali(fy,fm,fd);
   Jalali toJ=Jalali(ty,tm,td);

   DateTime fdt= fromJ.toDateTime();
   DateTime tdt= toJ.toDateTime();

   Duration duration= tdt.difference(fdt);
   int result= duration.inDays;
      if(result<0)
        result=result*-1;
     var nowDate=Jalali.now();
     DateTime nDate=nowDate.toDateTime();
     Duration newDiff=tdt.difference(nDate);
     int resDiff=newDiff.inDays;
     if(result > 0)
      return ((resDiff / result));
     else
       return 0;

 }
 static int diffMinsFromDateToDate4(DateTime fromDate,DateTime toDate) {

   Duration duration = fromDate.difference(toDate);
   int result = duration.inMinutes;
   return result;
 }
 static int diffDaysFromDateToDate3(String fromDate,String toDate) {
   String fromDate_temp = DartHelper.isNullOrEmptyString(fromDate);
   String toDate_temp = DartHelper.isNullOrEmptyString(toDate);
   if (fromDate_temp == null || fromDate_temp.isEmpty)
     fromDate_temp = '0/0/0';
   if (toDate_temp == null || toDate_temp.isEmpty)
     toDate_temp = '0/0/0';

   var fDate = fromDate_temp.split('/');
   var tDate = toDate_temp.split('/');

   int fy = int.tryParse(DartHelper.isNullOrEmpty(fDate[0]) ? 0 : fDate[0]);
   int ty = int.tryParse(DartHelper.isNullOrEmpty(tDate[0]) ? 0 : tDate[0]);

   int fm = int.tryParse(DartHelper.isNullOrEmpty(fDate[1]) ? 0 : fDate[1]);
   int tm = int.tryParse(DartHelper.isNullOrEmpty(tDate[1]) ? 0 : tDate[1]);

   int fd = int.tryParse(DartHelper.isNullOrEmpty(fDate[2]) ? 0 : fDate[2]);
   int td = int.tryParse(DartHelper.isNullOrEmpty(tDate[2]) ? 0 : tDate[2]);

   Jalali fromJ = Jalali(fy, fm, fd);
   Jalali toJ = Jalali(ty, tm, td);

   DateTime fdt = fromJ.toDateTime();
   DateTime tdt = toJ.toDateTime();

   Duration duration = tdt.difference(fdt);

   int result = duration.inDays;
   return result;
 }

 static int diffDaysFromDateIsGreaterThanToDate(String fromDate,String toDate) {
   String fromDate_temp = DartHelper.isNullOrEmptyString(fromDate);
   String toDate_temp = DartHelper.isNullOrEmptyString(toDate);
   if (fromDate_temp == null || fromDate_temp.isEmpty)
     fromDate_temp = '0/0/0';
   if (toDate_temp == null || toDate_temp.isEmpty)
     toDate_temp = '0/0/0';

   var fDate = fromDate_temp.split('/');
   var tDate = toDate_temp.split('/');

   int fy = int.tryParse(DartHelper.isNullOrEmpty(fDate[0]) ? 0 : fDate[0]);
   int ty = int.tryParse(DartHelper.isNullOrEmpty(tDate[0]) ? 0 : tDate[0]);

   int fm = int.tryParse(DartHelper.isNullOrEmpty(fDate[1]) ? 0 : fDate[1]);
   int tm = int.tryParse(DartHelper.isNullOrEmpty(tDate[1]) ? 0 : tDate[1]);

   int fd = int.tryParse(DartHelper.isNullOrEmpty(fDate[2]) ? 0 : fDate[2]);
   int td = int.tryParse(DartHelper.isNullOrEmpty(tDate[2]) ? 0 : tDate[2]);

   Jalali fromJ = Jalali(fy, fm, fd);
   Jalali toJ = Jalali(ty, tm, td);

   DateTime fdt = fromJ.toDateTime();
   DateTime tdt = toJ.toDateTime();

   Duration duration = tdt.difference(fdt);
      int result = duration.inDays;
      return result;


 }
 static int diffDaysFromDateToDate2(String fromDate,String toDate)
 {
   String fromDate_temp=DartHelper.isNullOrEmptyString(fromDate);
   String toDate_temp=DartHelper.isNullOrEmptyString(toDate);
   if(fromDate_temp==null || fromDate_temp.isEmpty)
     fromDate_temp='0/0/0';
   if(toDate_temp==null || toDate_temp.isEmpty)
     toDate_temp='0/0/0';

   var fDate=fromDate_temp.split('/');
   var tDate=toDate_temp.split('/');

   int fy=int.tryParse( DartHelper.isNullOrEmpty( fDate[0]) ? 0 : fDate[0]);
   int ty=int.tryParse(DartHelper.isNullOrEmpty( tDate[0]) ? 0 : tDate[0]);

   int fm=int.tryParse( DartHelper.isNullOrEmpty( fDate[1]) ? 0 : fDate[1]);
   int tm=int.tryParse( DartHelper.isNullOrEmpty( tDate[1]) ? 0 : tDate[1]);

   int fd=int.tryParse( DartHelper.isNullOrEmpty( fDate[2]) ? 0 : fDate[2]);
   int td=int.tryParse( DartHelper.isNullOrEmpty( tDate[2]) ? 0 : tDate[2]);

   Jalali fromJ=Jalali(fy,fm,fd);
   Jalali toJ=Jalali(ty,tm,td);

   DateTime fdt= fromJ.toDateTime();
   DateTime tdt= toJ.toDateTime();

   Duration duration= tdt.difference(fdt);
   int result= duration.inDays;
   if(result<0)
     result=result*-1;
   var nowDate=Jalali.now();
   if(result>0 && result<366) {
     DateTime nDate = nowDate.toDateTime();
     Duration newDiff = tdt.difference(nDate);
     int resDiff = newDiff.inDays;
     return ((resDiff));
   }
   return 0;

 }

 static String getDateJalali(){
   Jalali fromJ=Jalali.now();
   String result=fromJ.year.toString()+'/'+fromJ.month.toString()+'/'+fromJ.day.toString();
   return result;
 }

 static String getTimeNow(){
   DateTime fromJ=DateTime.now();
   String result=fromJ.hour.toString()+':'+fromJ.minute.toString()+':'+fromJ.second.toString();
   return result;
 }
 static String getDateJalaliFromDateTimeObj(DateTime now){
  Jalali j=Jalali.fromDateTime(now);
   String result=j.year.toString()+'/'+j.month.toString()+'/'+j.day.toString();
   return result;
 }

 static String getDateJalaliThis(Jalali now){

   String result=now.year.toString()+'/'+now.month.toString()+'/'+now.day.toString();
   return result;
 }
 static String getDateJalaliWithAddDays(int addDays){

   Jalali fromJ=Jalali.now().addDays(addDays);
   String result=fromJ.year.toString()+'/'+fromJ.month.toString()+'/'+fromJ.day.toString();
   return result;
 }
 static String convertIntoDateTime(String date){
   String newDate='';
  // PersianDateTime perdate=PersianDateTime();
   if(date!=null && date.isNotEmpty) {
     var fDate = date.split('/');
     if (fDate != null && fDate.length == 3) {
       Jalali j = Jalali(int.tryParse(fDate[0]),
           int.tryParse(fDate[1]),
           int.tryParse(fDate[2]));

       var temp = Gregorian.fromJalali(j);
       temp.toDateTime().add(new Duration(hours: 23,minutes: 59));
       newDate = DateTime.parse(temp.toDateTime().toString()).toString();

       return newDate;
     }
     return '';
   }
   return '';
 }

 static String convertIntoDateTimeWithTime(String date,int hours,int mines){
   String newDate='';
   // PersianDateTime perdate=PersianDateTime();
   if(date!=null && date.isNotEmpty) {
     var fDate = date.split('/');
     if (fDate != null && fDate.length == 3) {
       Jalali j = Jalali(int.tryParse(fDate[0]),
           int.tryParse(fDate[1]),
           int.tryParse(fDate[2]));

       var temp = Gregorian.fromJalali(j);
       var newDateTime= temp.toDateTime().add(new Duration(hours: hours,minutes: mines));
       newDate = DateTime.parse(newDateTime.toString()).toString();

       return newDate;
     }
     return '';
   }
   return '';
 }
 static String convertIntoDate(String date){
   String newDate='';
   // PersianDateTime perdate=PersianDateTime();
   if(date!=null && date.isNotEmpty) {
     var fDate = date.split('/');
     if (fDate != null && fDate.length == 3) {
       Jalali j = Jalali(int.tryParse(fDate[0]),
           int.tryParse(fDate[1]),
           int.tryParse(fDate[2]));
       var temp = Gregorian.fromJalali(j);
       newDate = DateTime.parse(temp.toDateTime().toString()).toString();
       DateTime dte=convertIntoDateObject(newDate);
       DateFormat dtf= new DateFormat("yyyy-MM-dd","en-US");
       return dtf.format(dte);
       //return newDate;
     }
     return '';
   }
   return '';
 }


 static Jalali convertIntoDateTimeJalali(String date){
   if(date!=null && date.isNotEmpty) {
     var fDate = date.split('/');
     if (fDate != null && fDate.length == 3) {
       Jalali j = Jalali(int.tryParse(fDate[0]),
           int.tryParse(fDate[1]),
           int.tryParse(fDate[2]));
       return j;
     }
     return null;
   }
 }
}


DateTimeUtils dateTimeUtils=new DateTimeUtils();
