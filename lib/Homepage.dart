import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_internship_submission/constants.dart';
/** Home Page
 * shows all data using firebase
 * uses cachednetworkimage to cache network images
 * **/
class HomePage extends StatelessWidget {

  static const id="homepage";
  FirebaseFirestore firestore= FirebaseFirestore.instance;
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: kPrimaryColor,appBar: AppBar(title: Text("Home"),elevation: 0,backgroundColor: kPrimaryColor,),
      body:StreamBuilder<QuerySnapshot>(

        builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }else{
        final userData = snapshot.data?.docs;
        if (userData?.length != 0) {

          return Column(
            children: [

              Expanded(
                // child: Container(),
                child: ListView.builder(
                    itemCount: userData!.length,
                    itemBuilder: (BuildContext context ,int index){
                      DocumentSnapshot user = userData[index];
                      double userLatitude=user.get(kLatitude);
                      double userLongitude=user.get(kLongitude);
                      String timeStamp=user.get(kTimestamp);
                      String imageUrl=user.get(kImage);
                      print(userLatitude.toString()+"   "+userLongitude.toString()+"   "+timeStamp+"   "+imageUrl);
                      return LoginItem(Latitude: userLatitude, Longitude: userLongitude, timeStamp: timeStamp, imageUrl: imageUrl);

                    }),
              ),
            ],
          );
        }else{
          return Expanded(child: Center(child: Text("No Logins")));}}
    },
    stream: firestore.collection(kData).where(kUserId,isEqualTo: auth.currentUser!.uid).snapshots(),
    ),
    );
  }
}
class LoginItem extends StatelessWidget {
  LoginItem(
        {required this.Latitude,
          required this.Longitude,
          required this.timeStamp,
          required this.imageUrl
      }) {

  }
  double Latitude;
  double Longitude;
  String timeStamp;
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Container(

            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20) ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(width: double.infinity,height: 300,decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                      ,image: DecorationImage(fit: BoxFit.cover, image:
                      CachedNetworkImageProvider(imageUrl))),),
                 SizedBox(height: 10,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Latitude :"+Latitude.toString(),style: TextStyle(fontSize: 16),),
                      Text("Longitude :"+Longitude.toString(),style: TextStyle(fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text("Timestamp :"+timeStamp,style: TextStyle(fontSize: 16),),
                  SizedBox(height: 10,),
                ]),
          ),
        ]));
  }
}