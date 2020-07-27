import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappmain/models/user.dart';
import 'package:flutterappmain/screens/authenticate/authenticate.dart';
import 'package:flutterappmain/screens/patient/patienthome.dart';
import 'package:flutter/material.dart';
import 'package:flutterappmain/models/patient.dart';
import 'package:flutterappmain/models/hospital.dart';
import 'package:flutterappmain/models/doctor.dart';
import 'package:provider/provider.dart';

getType(String uid) async {
  QuerySnapshot strm = await Firestore.instance
      .collection('Patient')
      .where("uid", isEqualTo: uid)
      .getDocuments();
  if (strm.documents.length != 0)
    return MapEntry(0, Patient.fromSnapshot(strm.documents[0]));
  QuerySnapshot strm1 = await Firestore.instance
      .collection('Doctors')
      .where("uid", isEqualTo: uid)
      .getDocuments();
  if (strm1.documents.length != 0)
    return MapEntry(1, Doctor.fromSnapshot(strm1.documents[0]));
  QuerySnapshot strm2 = await Firestore.instance
      .collection('Hospitals')
      .where("uid", isEqualTo: uid)
      .getDocuments();
  if (strm2.documents.length != 0)
    return MapEntry(2, Hospital.fromSnapshot(strm2.documents[0]));
  return MapEntry(3, null);
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);
    print(user);
    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder(
        future: getType(user.uid),
        builder: (context, res) {
          if (res.hasData) {
            MapEntry<int, dynamic> typ = res.data;
            if (typ.key == 0) {
              return Provider<Patient>(
                create: (_) => typ.value,
                child: MaterialApp(title: 'Brew Crew', home: PatientHomePage()));
            }
            else if (typ.key == 1) {
              return null; //Doctor Home Page.
            }
            else if (typ.key == 2) {
              return null; //Hospital Home Page.
            }
            else return Authenticate();
          }
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              ]));
        },
      );
    }
  }
}
