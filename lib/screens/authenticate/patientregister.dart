import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappmain/models/user.dart';
import 'package:flutter/material.dart';

class PatientRegisterPage extends StatefulWidget {
  final User user;
  PatientRegisterPage({this.user});
  @override
  _PatientRegisterPageState createState() =>
      _PatientRegisterPageState(user: user);
}

class _PatientRegisterPageState extends State<PatientRegisterPage> {
  final User user;
  String name, age, gender = "Male";
  _PatientRegisterPageState({this.user});
  bool isInt(String s) {
    return int.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your Name';
                  }
                  return null;
                },
                onChanged: (String val) => name = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your Age';
                  } else if (!isInt(value)) {
                    return 'Please Enter a Number.';
                  }
                  return null;
                },
                onChanged: (String val) => age = val,
              ),
              // DropdownButtonFormField<String>(
              //   value: gender,
              //   items: ['Male', 'Female']
              //       .map<DropdownMenuItem<String>>((String val) =>
              //           DropdownMenuItem<String>(value: val, child: Text(val)))
              //       .toList(),
              //   onSaved: (String newval) {
              //     gender = newval;
              //   },
              //   onChanged: (String newval) {
              //     setState(() {
              //       gender = newval;
              //     });
              //   },
              // ),
              RaisedButton(
                onPressed: () {
                  if (!_formKey.currentState.validate()) return null;
                  Map<String, dynamic> patient = new Map<String, dynamic>();
                  patient['name'] = name;
                  patient['age'] = int.parse(age);
                  patient['gender'] = gender;
                  patient['uid'] = user.uid;
                  patient['email'] = user.email;
                  Firestore.instance
                      .collection('Patient')
                      .document()
                      .setData(patient);
                  Navigator.pop(context);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue[500],
              )
            ],
          ),
        ),
      ),
    );
  }
}