import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


double baseHeight = 640.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery
      .of(context)
      .size
      .height / baseHeight;
}

String getDateFormat(DateTime datetime) {
  return getStringFromDateTime(datetime);
}

String getStringFromDateTime(DateTime today) {
  String dateSlug =
      "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(
      2, '0')}-${today.year.toString()}";
  print(dateSlug);
  return dateSlug;
}
double screenWidth(BuildContext context) {
  return MediaQuery
      .of(context)
      .size
      .width;
}

double screenHeight(BuildContext context) {
  return MediaQuery
      .of(context)
      .size
      .height;
}

Widget setupAlertDialoadContainer(BuildContext context,String icon,String title,) {
  return Container(
      height:screenHeight(context)/2.4, // Change as per your requirement
      width: screenWidth(context)/2, // Change as per your requirement
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0)),child:
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 7.5, right: 7.5, top: 2,bottom: 4.0),
              color: Color(0xfffbb448),
              child: Center(
                  child: Image.asset("assets/images/"+icon,height:35,width:100)
              ),
            )),
            Container(height: 120, width: screenWidth(context)/1.3,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 6.0,top: 15.0,right: 6.0),
                child:Column( mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(alignment:Alignment.center,child:Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize:16.0,fontWeight: FontWeight.w500,color: Colors.black),),)

                  ],

                )
            ),
            Container(height:screenHeight(context)/10,alignment:Alignment.center,child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        decoration: new BoxDecoration(
                            color:Color(0xfffbb448),
                            borderRadius: new BorderRadius.all(
                              const Radius.circular(22.0),
                            )),

                        padding: EdgeInsets.only(top:10),
                        width: screenWidth(context)/4,
                        height: 40,
                        child: Text(
                          "OK",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600,),
                        )),
                  ),
                )],
            ),
            ),
          ]));
}