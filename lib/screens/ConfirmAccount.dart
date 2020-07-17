import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter_aws_login/app_constants/Dialogs.dart';
import 'package:flutter_aws_login/app_constants/SizeConfig.dart';
import 'package:flutter_aws_login/app_constants/StringConstants.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

import 'LoginScreen.dart';

String username;
class ConfirmAccount extends StatefulWidget {
  ConfirmAccount({ String name})
  {
    username = name;
  }


  @override
  _ConfirmAccount createState() => _ConfirmAccount();
}

class _ConfirmAccount extends State<ConfirmAccount> {
  final GlobalKey<State> codeloader = new GlobalKey<State>();
  final GlobalKey<FormState> _confirmFormKey = GlobalKey<FormState>();
  final focusemail = FocusNode();
  final focuspassword = FocusNode();
  final userPool = new CognitoUserPool(StringConstants.awsUserPoolId, StringConstants.awsClientId);
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController codecontroller = new TextEditingController();

  Widget _submitButton() {
    return InkWell(
      onTap: () async {

        if (_confirmFormKey.currentState.validate()) {
          String message;
          Dialogs.showLoadingDialog(context, codeloader);
          final cognitoUser = new CognitoUser(namecontroller.text.toString(), userPool);
          try {
           await cognitoUser.confirmRegistration(codecontroller.text.toString()).then((value)
           {
             Navigator.of(codeloader.currentContext, rootNavigator: true).pop();

             if(value) {
               Fluttertoast.showToast(msg:"Account Verified Successfully", toastLength: Toast.LENGTH_LONG,);
               Navigator.push(
                   context, MaterialPageRoute(builder: (context) =>
                   LoginScreen())
               );
             }
           });
          } on CognitoClientException catch (e) {
            if (e.code == 'InvalidParameterException' ||
                e.code == 'CodeMismatchException' ||
                e.code == 'NotAuthorizedException' ||
                e.code == 'UserNotFoundException' ||
                e.code == 'ResourceNotFoundException')
            {
              message = e.message;
              Navigator.of(codeloader.currentContext, rootNavigator: true).pop();
              Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_LONG,);
            } else {
              Navigator.of(codeloader.currentContext, rootNavigator: true).pop();
              message = 'Unknown client error occurred';
              Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_LONG,);
            }
          } catch (e) {
            Navigator.of(codeloader.currentContext, rootNavigator: true).pop();
            message = 'Unknown error occurred';
            Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_LONG,);
          }
        }
      },
      child:Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
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
          'Submit',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
  ErrorMessageDialog(err){
    //Navigator.of(_forgetInLoader.currentContext, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(err.message),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );

  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Conf',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'irm ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Acc',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
            TextSpan(
              text: 'ount',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  String emailValidator(String value) {
    if(value.length == 0){
      return 'Please enter Username ';
    }
  }
  String codeValidator(String value) {
    if(value.length == 0){
      return 'Please enter Confirmation Code ';
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroller.text = username;
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _confirmFormKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*6),
                        child:  _title(),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*15),
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                          /* foregroundDecoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 2.0
                            )
                        ),*/
                          child:Column(children: <Widget>[

                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:15.0
                              ),
                              color: Color(0xfff3f3f4),
                              foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0
                                  )
                              ),
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*4,bottom: SizeConfig.blockSizeVertical*3),
                              child: TextFormField(
                                  controller: namecontroller,
                                  textInputAction: TextInputAction.done,
                                  validator: emailValidator,
                                  decoration: InputDecoration(
                                    hintText: "Username or Email",
                                    hintStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.w600,color: Colors.black45),
                                    border: InputBorder.none,
                                    //   fillColor: Color(0xfff3f3f4),
                                    //  filled: true
                                  )),),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:15.0
                              ),
                              color: Color(0xfff3f3f4),
                              foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0
                                  )
                              ),
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2,bottom: SizeConfig.blockSizeVertical*3),
                              child: TextFormField(
                                  controller: codecontroller,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  validator: codeValidator,
                                  decoration: InputDecoration(
                                    hintText: "Confirmation Code",
                                    hintStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.w600,color: Colors.black45),
                                    border: InputBorder.none,
                                    //   fillColor: Color(0xfff3f3f4),
                                    //  filled: true
                                  )),),
                          ],)
                      ),
                      Container(
                        margin: EdgeInsets.only(top:30.0),
                        child: _submitButton(),
                      ),

                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Positioned(top: SizeConfig.blockSizeVertical*5, left: 0, child: _backButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black,size: 26,),
            ),
            Text('Back',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

}
