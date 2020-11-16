import 'dart:io';

import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
//import 'package:install_plugin/install_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadAPK extends StatefulWidget {

  var appleStoreLink='';
  DownloadAPK({this.appleStoreLink});
  _DownloadAPKState createState() => _DownloadAPKState();
}

class _DownloadAPKState extends State<DownloadAPK> {

  File _apkFilePath;

  TextEditingController _controller = TextEditingController(
      text: "");
  var apkUrl = "";
  var apkFileName='nardisshop.apk';
  var progress = "";
  var _apkPath='';
  bool downloading = false;

  Future<void> _download() async {
    Dio dio = Dio();

    var dirToSave = await getApplicationDocumentsDirectory();
    _apkPath=dirToSave.path+"/"+apkFileName;
    await dio.download(_controller.text, "${dirToSave.path}/nardisshop.apk",
        onReceiveProgress: (rec, total) {
          setState(() {
            downloading = true;
            progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        });

    try {} catch (e) {
      throw e;
    }
    setState(() {
      _apkFilePath=File(dirToSave.path+"/"+apkFileName);
      downloading = false;
      progress = "کامل شد";
      if(Platform.isAndroid)
        onInstallApk();
      else if(Platform.isIOS)
        onGotoAppStore(widget.appleStoreLink);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('دانلود فایل جدید برنامه'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            downloading ? CircularProgressIndicator() : SizedBox(),
            SizedBox(height: 10),
            downloading ? Text(progress) : SizedBox(),
            SizedBox(height: 15),

            SizedBox(height: 30),
            RaisedButton(
              child: Text('دریافت فایل برنامه'),
              onPressed: _download,
              color: Colors.red,
            ),
            RaisedButton(
              child: Text('انصراف'),
              onPressed: (){ RxBus.post(new ChangeEvent(message:'DOWNLOAD_CANCELED'));},
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }



  void onInstallApk() async {
    if (_apkPath.isEmpty) {
      print('make sure the apk file is set');
      return;
    }
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
     /* InstallPlugin.installApk(_apkPath, 'com.beauty.nardis')
          .then((result) {
        print('install apk $result');
      }).catchError((error) {
        print('install apk error: $error');
      });*/
    } else {
      print('مجوز دسترسی نصب وجود ندارد!');
    }
  }

  void onGotoAppStore(String url) {
    url = url.isEmpty
        ? ''
        : url;
   // InstallPlugin.gotoAppStore(url);
  }
}