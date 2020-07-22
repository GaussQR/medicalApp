import 'package:flutter/material.dart';
import 'package:flutterappmain/models/hospital.dart';
import 'package:flutterappmain/screens/patient/apply_appointment.dart';

class HospitalInfo extends StatelessWidget {
  final Hospital record;
  HospitalInfo({Key key, @required this.record}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Apply for Appointment')),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(record.name,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    leading: Icon(
                      Icons.local_hospital,
                      color: Colors.blue[500],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(record.phoneNo,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    leading: Icon(
                      Icons.contact_phone,
                      color: Colors.blue[500],
                    ),
                  ),
                  ListTile(
                    title: Text(record.email),
                    leading: Icon(
                      Icons.contact_mail,
                      color: Colors.blue[500],
                    ),
                  ),
                  ListTile(
                    title: Text(record.facilities,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    leading: Icon(
                      Icons.description,
                      color: Colors.blue[500],
                    ),
                  ),
                  RaisedButton(
                      color: Colors.blue[500],
                      child: Text(
                        'Apply Here',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (context) =>
                                ApplyAppointment(record: record)));
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}
