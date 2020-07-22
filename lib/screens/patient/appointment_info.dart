import 'package:flutter/material.dart';
import 'package:flutterappmain/models/appointment.dart';

class AppointmentInfo extends StatelessWidget {
  final TextAppointment rec;
  AppointmentInfo({this.rec});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Info'),
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(rec.hospitalName,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    leading: Icon(
                      Icons.local_hospital,
                      color: Colors.blue[500],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(rec.sympText),
                    leading: Icon(
                      Icons.contact_mail,
                      color: Colors.blue[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}