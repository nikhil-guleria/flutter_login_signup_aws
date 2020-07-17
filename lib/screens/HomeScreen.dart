import 'dart:convert';
import 'dart:io';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:flutter_aws_login/Utils/SharedPref.dart';
import 'package:flutter_aws_login/Utils/customgallery/delegate/badge_delegate.dart';
import 'package:flutter_aws_login/Utils/customgallery/delegate/checkbox_builder_delegate.dart';
import 'package:flutter_aws_login/Utils/customgallery/delegate/sort_delegate.dart';
import 'package:flutter_aws_login/Utils/customgallery/entity/options.dart';
import 'package:flutter_aws_login/Utils/customgallery/provider/i18n_provider.dart';
import 'package:flutter_aws_login/Utils/photo.dart';
import 'package:flutter_aws_login/app_constants/AppColors.dart';
import 'package:flutter_aws_login/app_constants/Dialogs.dart';
import 'package:flutter_aws_login/app_constants/Photo.dart';
import 'package:flutter_aws_login/app_constants/SizeConfig.dart';
import 'package:flutter_aws_login/app_constants/StringConstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import 'VideoRecorder.dart';

String username;
class HomeScreen extends StatefulWidget {
  HomeScreen({String data});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>
{
  final GlobalKey<State> codeloader = new GlobalKey<State>();
  final GlobalKey<FormState> _confirmFormKey = GlobalKey<FormState>();
  final focusemail = FocusNode();
  final focuspassword = FocusNode();
  final userPool = new CognitoUserPool(StringConstants.awsUserPoolId, StringConstants.awsClientId);
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController codecontroller = new TextEditingController();
  List<File> allfiles = new List();
  File _image;
  String jwtoken="";
  final GlobalKey<State> fileloader = new GlobalKey<State>();

  Future<String> getdevicetoken() async
  {
    var login=await SharedPreferencesTest().sessiontoken("get");
    print(login);
    return login;
  }
  final picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroller.text = username;
    getdevicetoken().then((value) {
      setState(()
      {
        jwtoken = value;
      });
    });
  }
  @override
  Widget build(BuildContext context)
  {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.syncColor,
        centerTitle: true,
        title: Text("HOME",textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Lato',fontSize: SizeConfig.blockSizeVertical*2,color: Colors.black,fontWeight: FontWeight.w600,
        ),
      )),
      body: SingleChildScrollView(
        child: Container(
          child:Column(children: <Widget>
          [
            Container(
              height: SizeConfig.blockSizeVertical*50,
              margin:EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,vertical:SizeConfig.blockSizeVertical*2),
              foregroundDecoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.0
                  )
              ),
              padding: EdgeInsets.all(6.0),
              child: ListView.builder(
                cacheExtent: 10,
                addAutomaticKeepAlives: false,
                itemCount: allfiles.length,
                itemBuilder: (context, pos) {
                  var name = allfiles.elementAt(pos).path.split('/').last;
                  return Container(
                    margin: EdgeInsets.only(bottom: 7.0),
                    padding: EdgeInsets.symmetric(vertical: 7.0,horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                      Expanded(child:
                      Text(name,style: TextStyle(fontWeight:
                      FontWeight.w400,color: Colors.black,fontSize: 16.0),)),
                      /*InkWell(
                          onTap:(){
                            setState(() {
                              allfiles.removeAt(pos);
                            });
                          },
                          child:
                          Container(
                              margin:EdgeInsets.only(left: 20.0),
                              child:
                              Icon(Icons.close,color: Colors.black,size: 24.0,))),*/
                      Column(children: <Widget>[
                        InkWell(child:Container(
                          width: SizeConfig.blockSizeHorizontal*24,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                          child: Text(
                            'Delete',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ) ,onTap: ()
                        {
                          setState(() {
                            allfiles.removeAt(pos);
                          });
                        },),
                        InkWell(child:Container(
                          margin: EdgeInsets.only(top: 8.0),
                          width: SizeConfig.blockSizeHorizontal*24,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                          child: Text(
                            'Upload',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ) ,onTap: ()
                        {
                            upload(allfiles.elementAt(pos));
                        },)
                      ],)



                    ],),
                  );
                },
              ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              InkWell(child:Container(
                width: SizeConfig.blockSizeHorizontal*24,
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                child: Text(
                  'Camera',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ) ,onTap: ()
              async {
                _checkPermission().then((hasGranted) async {
                  if (hasGranted) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets
                                .zero,
                            content: setupAlertDialoadContainer(
                                context),
                          );
                        }
                    );
                  }
                  else
                  {
                    Fluttertoast.showToast(msg: "Storage Permission not Granted");
                  }
                });

              },),InkWell(child:Container(
                width: SizeConfig.blockSizeHorizontal*24,
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                child: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ) ,onTap: ()
              {
              _checkPermission().then((hasGranted) async {
              if (hasGranted) {
                _pickAsset(context, PickType.all);
                setState(() {

                });
              }
              else
                {
                  Fluttertoast.showToast(msg: "Storage Permission not Granted");
                }
              });
              },)
            ],),

          ],)
        ),
      ),
    );
  }



  void _pickAsset(BuildContext context,PickType type, {List<AssetPathEntity> pathList}) async
  {
    /// context is required, other params is optional.
    /// context is required, other params is optional.
    /// context is required, other params is optional.

    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      // BuildContext required
      context: context,

      /// The following are optional parameters.
      themeColor: AppColors.primaryColor,
      // the title color and bottom color

      textColor: Colors.black,
      // text color
      padding: 1.0,
      // item padding
      dividerColor: Colors.grey,
      // divider color
      disableColor: Colors.grey.shade300,
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
      maxSelected: 20,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.english,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 3,
      // item row count
      thumbSize: 150,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.black,
        unselectedColor: Colors.black,
        checkColor: AppColors.primaryColor,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox
      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget

      pickType: type,

      photoPathList: pathList,
    );
    if (imgList == null || imgList.isEmpty) {
      return;
    } else {
      List<String> r = [];
      for (var e in imgList) {
        var file = await e.file;
        r.add(file.absolute.path);
        allfiles.add(new File(file.absolute.path));
      }

    }
    setState(() {});
  }

  upload (File file) async {
    Dialogs.showLoadingDialog(context, fileloader);
    final _userPool = CognitoUserPool(StringConstants.awsUserPoolId, StringConstants.awsClientId);
    print(jwtoken);
    /*final _cognitoUser = CognitoUser("dilpreet", _userPool);
    final authDetails =
    AuthenticationDetails(username: 'dilpreet', password: 'Admin@123');

    CognitoUserSession _session;
    try {
      _session = await _cognitoUser.authenticateUser(authDetails);
    } catch (e) {
      print(e);
    }
*/
    final _credentials = CognitoCredentials(StringConstants.identityPoolId, _userPool);
    await _credentials.getAwsCredentials(jwtoken);

    const _s3Endpoint ='https://testflutteraws.s3.amazonaws.com';
  //  final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    final length = await file.length();
   /* final uri = Uri.parse(_s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));*/
    final policy = Policy.fromS3PresignedPost(
        '${path.basename(file.path)}',
        'testflutteraws',
        300,
        _credentials.accessKeyId,
        length,
        _credentials.sessionToken,
        region: StringConstants.region);
    final key = SigV4.calculateSigningKey(
        _credentials.secretAccessKey, policy.datetime, StringConstants.region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());
    FormData formData = new FormData.fromMap({
      "key": policy.key,
      "acl": 'public-read',
      "X-Amz-Credential": policy.credential,
      "X-Amz-Algorithm": "AWS4-HMAC-SHA256",
      "X-Amz-Date": policy.datetime,
      "Policy": policy.encode(),
      "X-Amz-Signature": signature,
      "x-amz-security-token": _credentials.sessionToken,
    });
      if (file!=null)
      {
        var filename = file
            .path
            .split('/')
            .last;
        if(!filename.contains("."))
        {
          filename = filename+".jpg";
        }
        formData.files.add(MapEntry("file",
            await MultipartFile.fromFile(file
                .path, filename: filename)));
      }
    try {

      await Dio().post(_s3Endpoint,
        data: formData,
      ).then((value)
      {
        Navigator.of(fileloader.currentContext, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: 'File Uploaded',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white
        );
      });
    } catch (e) {
      Navigator.of(fileloader.currentContext, rootNavigator: true).pop();

    }
    }
    /*req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;
    req.fields['x-amz-security-token'] = _credentials.sessionToken;*/

   /* try {
      final res = await req.send();
      await for (var value in res.stream.transform(utf8.decoder)) {

        print(value);
      }
    } catch (e) {
      print(e.toString());
    }*/

  Widget setupAlertDialoadContainer(BuildContext context) {

    return Container(
        height: 240.0, // Change as per your requirement
        width: 80.0, // Change as per your requirement
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 45,
                padding: EdgeInsets.only(left: 10, right: 10, top: 2,bottom: 4.0),
                color: AppColors.primaryColor,
                child: Center(
                  child: Text(
                    "Please Select One Option",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 20),
                child: Material(
                  color: AppColors.primaryColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        const Radius.circular(50.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        final pickedFile = await picker.getImage(source: ImageSource.camera);
                        setState(() {
                          allfiles.add(File(pickedFile.path));
                        });
                      },
                      child: Container(
                          width: 100,
                          child: Text(
                            "IMAGE",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 20),
                child: Material(
                  color: AppColors.primaryColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        const Radius.circular(50.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => VideoRecorderExample())
                        ).then((value) {
                          setState(() {
                            allfiles.addAll(value);
                          });
                        });
                        setState(() {});
                      },
                      child: Container(
                          width: 100,
                          child: Text(
                            "VIDEO",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 20),
                child: Material(
                  color: AppColors.primaryColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        const Radius.circular(40.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          width: 100,
                          child: Text(
                            "CANCEL",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                  ),
                ),
              ),
            ])
    );}
  Future<bool> _checkPermission() async {

    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}
