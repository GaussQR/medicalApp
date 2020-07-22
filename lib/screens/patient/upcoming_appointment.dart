import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappmain/models/appointment.dart';
import 'package:flutterappmain/models/patient.dart';
import 'package:flutterappmain/screens/patient/appointment_info.dart';
import 'package:provider/provider.dart';

class UpcomingAppointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Appointments').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              String userUid = Provider.of<Patient>(context, listen: false).reference.documentID;
              return ListView(
                padding: const EdgeInsets.only(top: 10.0),
                children: snapshot.data.documents.where((element){
                    String appPatientId = element.data['patient_id'].documentID;
                    return  appPatientId == userUid;
                  })
                    .map((data) => _buildListItem(context, data))
                    .toList(),
              );
          }
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    IconData status = Icons.error;
    TextAppointment appointment = TextAppointment.fromSnapshot(document);
    if (appointment.status == "Approved") status = Icons.check_circle_outline;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(appointment.classofDisease),
          subtitle: Text(appointment.hospitalName),
          trailing: Icon(status),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => AppointmentInfo(rec: appointment)));
            return null;
          },
        ),
      ),
    );
  }
}