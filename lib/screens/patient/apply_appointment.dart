import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterappmain/models/hospital.dart';
import 'package:flutterappmain/models/patient.dart';
import 'package:provider/provider.dart';
import 'package:flutterappmain/services/globals.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart'; //uploadimage.
import 'package:file_picker/file_picker.dart';

class ApplyAppointment extends StatefulWidget {
  final Hospital record;
  ApplyAppointment({@required this.record});
  @override
  _ApplyAppointmentState createState() =>
      _ApplyAppointmentState(record: record);
}

class _ApplyAppointmentState extends State<ApplyAppointment> {
  final _formKey = GlobalKey<FormState>();
  String symp, classofDisease;
  final Hospital record;
  String fileType;

  var fileName;
  
  _ApplyAppointmentState({@required this.record});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply for Appointment')),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: classofDisease,
                  items: classesDiseases
                      .map<DropdownMenuItem<String>>((String val) =>
                          DropdownMenuItem<String>(
                              value: val, child: Text(val)))
                      .toList(),
                  onChanged: (String newval) {
                    setState(() {
                      classofDisease = newval;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter your symptoms'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Symptoms';
                    }
                    return null;
                  },
                  onChanged: (String val) => symp = val,
                ),
                ListTile(
                  title: Text(
                    'Image',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.image,
                    color: Colors.redAccent,
                  ),
                  onTap: () {
                    setState(() {
                      fileType = 'image';
                    });
                    filePicker(context);
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return null;
                    }
                    Map<String, dynamic> appt = new Map<String, dynamic>();
                    appt['hospital_id'] = record.reference;
                    Patient curr = Provider.of<Patient>(context, listen: false);
                    appt['patient_id'] = curr.reference;
                    appt['symptoms_text'] = symp;
                    appt['class'] = classofDisease;
                    appt['hospital_name'] = record.name;
                    appt['patient_name'] = curr.name;
                    appt['status'] = "Pending";
                    Firestore.instance
                        .collection('Appointments')
                        .document()
                        .setData(appt);
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
          )),
    );
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("$fileType/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'image') {
        File file = await FilePicker.getFile(type: FileType.image);
        setState(() {
          fileName = basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
    } on PlatformException catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported File exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
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
}
