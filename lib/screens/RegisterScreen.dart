
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter_aws_login/app_constants/Dialogs.dart';
import 'package:flutter_aws_login/app_constants/SizeConfig.dart';
import 'package:flutter_aws_login/app_constants/StringConstants.dart';
import 'package:flutter_aws_login/screens/ConfirmAccount.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';


class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<RegisterScreen> {
  final GlobalKey<State> _SignUpLoader = new GlobalKey<State>();
  final GlobalKey<FormState> _registerFormKey = new GlobalKey<FormState>();
  TextEditingController usernameInputController = new TextEditingController();
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
  final userPool = new CognitoUserPool(StringConstants.awsUserPoolId, StringConstants.awsClientId);

  final focusfirstname = FocusNode();
  final focuslastname = FocusNode();
  final focusemail = FocusNode();
  final focuspassword = FocusNode();
  final focusConfirmPassword = FocusNode();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String emailValidator(String value)
  {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(value.length == 0){
      return 'Please enter a email ';
    }
    if (!regex.hasMatch(value))
    {
      return 'Email format is invalid';
    }
    else {
      return null;
    }
  }
  String pwdValidator(String value) {
    if(value.length == 0){
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
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
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black,size: 26),
            ),
            Text('Back',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () async {

          if (_registerFormKey.currentState.validate()){
            FocusScope.of(context).unfocus();
            Dialogs.showLoadingDialog(context, _SignUpLoader);
            List<AttributeArg> attrs = new List();
            attrs.add(new AttributeArg(name:"family_name",value:"Test"));
            attrs.add(new AttributeArg(name:"given_name",value:"Test"));
            String message;
              try {
                await userPool.signUp( emailInputController.text.toString(), pwdInputController.text.toString(),userAttributes:attrs ).then((value)
                {
                  Navigator.of(_SignUpLoader.currentContext, rootNavigator: true).pop();
                  Fluttertoast.showToast(msg: "User Registered Successfully",toastLength: Toast.LENGTH_LONG,);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>
                        ConfirmAccount(name: emailInputController.text.toString(),))
                    );
                });

              } on CognitoClientException catch (e) {
                Navigator.of(_SignUpLoader.currentContext, rootNavigator: true).pop();
                if (e.code == 'UsernameExistsException' ||
                    e.code == 'InvalidParameterException' ||
                    e.code == 'ResourceNotFoundException')
                {
                  message = e.message;
                  Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_LONG,);
                } else {
                  message = 'Unknown client error occurred';
                  Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_LONG,);
                }
              } catch (e)
              {
                message = 'Unknown error occurred';
                Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,);
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
            'Register Now',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
    );
  }

  Widget _loginAccountLabel()
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
            Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical:10.0
              ),
              child:Text(
                'Login',
                style: TextStyle(
                    color: Color(0xfff79c4f),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'R',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'egi',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ster',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context)
  {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _registerFormKey,
            child:Container(
              height: MediaQuery.of(context).size.height,
              child:Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                        _title(),

                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 15.0),
                          child:Text(
                            "Email",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),),
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
                          margin: EdgeInsets.only(top: 8.0),
                          child: TextFormField(

                              focusNode: focusemail,
                              textInputAction: TextInputAction.next,
                              controller: emailInputController,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (v){
                                FocusScope.of(context).requestFocus(focuspassword);
                              },
                              validator: emailValidator,
                              decoration: InputDecoration(
                                hintText: "Email",
                                border: InputBorder.none,
                                //fillColor: Color(0xfff3f3f4),
                                // filled: true
                              )),),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 15.0),
                          child:Text(
                            "Password",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),),
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
                          margin: EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                              controller: pwdInputController,
                              focusNode: focuspassword,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              validator: pwdValidator,
                              decoration: InputDecoration(
                                hintText: "Password",
                                border: InputBorder.none,
                                //   fillColor: Color(0xfff3f3f4),
                                //   filled: true
                              )),),
                        Container(
                            margin: EdgeInsets.only(top: 40.0),
                            child:_submitButton()),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _loginAccountLabel(),
                  ),
                  Positioned(top: SizeConfig.blockSizeVertical*5, left: 0, child: _backButton()),
                ],
              ),
            )
        ),
      ),
    );
  }
  ErrorMessageDialog(err)
  {
    Navigator.of(_SignUpLoader.currentContext, rootNavigator: true).pop();
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
}
