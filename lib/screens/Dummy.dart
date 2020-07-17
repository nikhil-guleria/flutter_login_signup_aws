import 'dart:typed_data';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter_aws_login/app_constants/Dialogs.dart';
import 'package:flutter_aws_login/app_constants/SizeConfig.dart';
import 'package:flutter_aws_login/app_constants/StringConstants.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;


Uint8List username;
class Dummy extends StatefulWidget {
  Dummy({ Uint8List name})
  {
    username = name;
  }


  @override
  _Dummy createState() => _Dummy();
}

class _Dummy extends State<Dummy> {
  final GlobalKey<State> codeloader = new GlobalKey<State>();
  final GlobalKey<FormState> _confirmFormKey = GlobalKey<FormState>();
  final focusemail = FocusNode();
  final focuspassword = FocusNode();
  final userPool = new CognitoUserPool(StringConstants.awsUserPoolId, StringConstants.awsClientId);
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController codecontroller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: 500,
          width: 400,
          //color: Color.fromARGB(50, 50, 50, 50),
            child: Image.memory(username)),
    );
  }

}
/*class RectanglePainter extends CustomPainter {
  RectanglePainter(this.image);

  ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) {
      canvas.drawRect(
          new Rect.fromLTRB(100.0, 50.0, 300.0, 200.0),
          new Paint()
            ..color = Color.fromARGB(255, 50, 50, 255)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6.0);
    } else {
      canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
    }
  }

  @override
  bool shouldRepaint(RectanglePainter old) {
    return true;
  }
}*/
