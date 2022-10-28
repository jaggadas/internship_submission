import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internship_submission/Firebase.dart';
import 'package:flutter_internship_submission/Homepage.dart';
import 'package:flutter_internship_submission/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:sn_progress_dialog/progress_dialog.dart';
/** Login Page
 * handles clicking image with image_picker widget
 * handles location service with geolocator widget
 * handles timestamp with DateTime widget
 * Uses Firebase Service for data upload
 * **/
class LoginPage extends StatefulWidget {
  static const id="loginpage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  File? imageFile=null;

  bool isImagePicked=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(backgroundColor: kPrimaryColor,title: Text("Login"),elevation: 0,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(decoration: BoxDecoration(color: kSecondaryColor,borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              isImagePicked?
              Container(width: double.infinity,height: 500,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),image: DecorationImage(fit: BoxFit.cover, image: FileImage(imageFile!,))),)
                  :
              Container(child: Image.asset("assets/user_image.png")),
              RoundedButton(color: Colors.white, title: "Take Photo", onPressed: ()async{
                    final ImagePicker _picker = ImagePicker();
                    // Pick an image
                    final image = await _picker.pickImage(source: ImageSource.camera);
                    imageFile=File(image!.path);
                    setState(() {
                      isImagePicked=true;
                    });
                  }),
              RoundedButton(color: Colors.white, title: "Login", onPressed: ()async{
                try {
                      if(isImagePicked){
                        ProgressDialog pd = ProgressDialog(context: context);
                        pd.show(max: 100, msg: 'Please Wait',progressBgColor: kSecondaryColor,progressValueColor: kPrimaryColor,);
                      //Firebase Anonymous sign in
                      final userCredential = await FirebaseAuth.instance.signInAnonymously();
                      //Location
                      LocationPermission permission = await Geolocator.requestPermission();
                      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
                      double longitude=position.longitude;
                      double latitude=position.latitude;
                      //TimeStamp
                      String timeStamp=DateTime.now().toString();
                      print("latitude"+latitude.toString()+"longitude"+longitude.toString()+"timestamp"+timeStamp);
                      if(await FirebaseService().uploadData(context, imageFile!, latitude, longitude, timeStamp)==true)
                        {
                          pd.close();
                      Navigator.pushNamed(context, HomePage.id);}

                      }else{print("Image is not picked");}

                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case "operation-not-allowed":
                      print("Anonymous auth hasn't been enabled for this project.");
                      break;
                    default:
                      print("Unknown error.");
                  }
                }
                  })
            ],),
          ),
          ),
        ),
      )

    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton({
    required this.color, required this.title,  required this.onPressed
  });
  Color color;
  String title;
  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        child: MaterialButton(
          onPressed:onPressed,
          minWidth: double.infinity,
          height: 42.0,
          child: Text(
            title,style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }
}
