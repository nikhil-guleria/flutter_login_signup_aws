import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter_aws_login/Utils/SharedPref.dart';
import 'package:flutter_aws_login/app_constants/Dialogs.dart';
import 'package:flutter_aws_login/app_constants/StringConstants.dart';
import 'package:flutter_aws_login/screens/ConfirmAccount.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomeScreen.dart';
import 'RegisterScreen.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>
{
  final GlobalKey<State> _SignInLoader = new GlobalKey<State>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final focusemail = FocusNode();
  final focuspassword = FocusNode();
  final userPool = new CognitoUserPool(StringConstants.awsUserPoolId, StringConstants.awsClientId);
  TextEditingController usernameInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
    Widget _submitButton() {
     return InkWell(
       onTap: () async {
        FocusScope.of(context).unfocus();

        if (_loginFormKey.currentState.validate())
        {
          String message;
          Dialogs.showLoadingDialog(context, _SignInLoader);
          final cognitoUser = new CognitoUser(usernameInputController.text.toString(), userPool);
          final authDetails = new AuthenticationDetails(
            username: usernameInputController.text.toString(),
            password: pwdInputController.text.toString(),
          );
          try
          {
           await cognitoUser.authenticateUser(authDetails).then((value)
           {
             Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
             SharedPreferencesTest().sessiontoken("set",value: value.getIdToken().getJwtToken());
             Navigator.pushReplacement(
                 context, MaterialPageRoute(builder: (context) => HomeScreen())
             );
           });
          } on CognitoUserNewPasswordRequiredException catch (e)
          {
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
            // handle New Password challenge
          } on CognitoUserMfaRequiredException catch (e)
          {
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
            // handle SMS_MFA challenge
          } on CognitoUserSelectMfaTypeException catch (e) {
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
            // handle SELECT_MFA_TYPE challenge
          } on CognitoUserMfaSetupException catch (e) {
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
            // handle MFA_SETUP challenge
          } on CognitoUserTotpRequiredException catch (e)
          {
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
            // handle SOFTWARE_TOKEN_MFA challenge
          } on CognitoUserCustomChallengeException catch (e) {
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
            // handle CUSTOM_CHALLENGE challenge
          } on CognitoUserConfirmationNecessaryException catch (e) {
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
            // handle User Confirmation Necessary
          } on CognitoClientException catch (e) {
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
            // handle Wrong Username and Password and Cognito Client
          }catch (e) {
            print(e);
            Navigator.of(_SignInLoader.currentContext, rootNavigator: true).pop();
            Fluttertoast.showToast(msg:e.message, toastLength: Toast.LENGTH_LONG,);
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
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider()
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }



  Widget _createAccountLabel()
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: ()
            {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterScreen())
      );
            },
            child:Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Register',
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
          text: 'L',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'og',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'in',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

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
  String pwdValidator(String value)
  {
    if(value.length == 0){
      return 'Please enter a password';

    }
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _loginFormKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>
              [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:30.0),
                        child:  _title(),
                      ),
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
                            controller: usernameInputController,
                            focusNode: focusemail,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focuspassword);
                            },
                            validator: emailValidator,
                            decoration: InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              //fillColor: Color(0xfff3f3f4),
                              //filled: true
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
                          //cursorColor: Color(0xfff3f3f4),
                            controller: pwdInputController,
                            focusNode: focuspassword,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
                            validator: pwdValidator,
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: InputBorder.none,
                              // fillColor: Color(0xfff3f3f4),
                              // filled: true
                            )
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top:30.0),
                        child: _submitButton(),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ConfirmAccount())
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Confirm Account ?',
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),

                      _divider(),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _createAccountLabel(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
