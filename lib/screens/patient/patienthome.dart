import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappmain/models/patient.dart';
import 'package:flutterappmain/models/user.dart';
import 'package:flutterappmain/screens/authenticate/patientregister.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutterappmain/models/hospital.dart';
import 'package:flutterappmain/screens/patient/hospital_info.dart';
import 'package:flutterappmain/screens/patient/upcoming_appointment.dart';
import 'package:flutterappmain/services/auth.dart';

class PatientHomePage extends StatefulWidget {
  @override
  _PatientHomePageState createState() {
    return _PatientHomePageState();
  }
}

class _PatientHomePageState extends State<PatientHomePage> {
  final AuthService _auth = AuthService();
  Position _currentPosition;
  Map<GeoPoint, double> distances = new Map<GeoPoint, double>();
  final Geolocator geol = Geolocator()..forceAndroidLocationManager;
  @override
  Widget build(BuildContext context) {
    Patient curuser = Provider.of<Patient>(context);
    if (curuser.name == null) return PatientRegisterPage(user: Provider.of<User>(context, listen: false));
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Hospitals'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: _buildBody(context),
      drawer: Drawer(
          child: ListView(
        // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(curuser.name),
              accountEmail: Text(curuser.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  curuser.name[0].toUpperCase(),
                  style: TextStyle(fontSize: 40.0),
                ),
              )),
          ListTile(
              leading: Icon(Icons.assignment_ind),
              title: Text('Upcoming Appointments'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (context) => UpcomingAppointment()));
              }),
          ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Prescriptions'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: (context) => null));
              }),
          ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Medicine Orders'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: (context) => null));
              }),
        ],
      )),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_currentPosition == null) {
      return Center(child: Column(children: <Widget>[
        FlatButton(
          color: Colors.green,
          child: Text("Please Enable Location"),
          onPressed: () {
            _getCurrentLocation();
          }),
      ],),);
    }
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Hospitals').snapshots(),
        builder: (context, snapshot) {
          // if (snapshot.hasData)
          return _buildList(context, snapshot.data.documents);
          // return Container();
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return FutureBuilder(
      future: _getdistances(snapshot),
      builder: (context, snapshot2) {
        // if (snapshot2.hasData)
        snapshot.sort(cmp);
        return ListView(
          padding: const EdgeInsets.only(top: 10.0),
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList(),
        );
        // return Container();
      },
    );
  }

  Future<double> distance(GeoPoint loc) async {
    return await geol.distanceBetween(_currentPosition.latitude,
        _currentPosition.longitude, loc.latitude, loc.longitude);
  }

  int cmp(DocumentSnapshot x, DocumentSnapshot y) {
    GeoPoint locx = x.data['location'];
    GeoPoint locy = y.data['location'];
    return (distances[locx] < distances[locy]) ? -1 : 1;
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Hospital.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(distformat(distances[record.loc])),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => HospitalInfo(record: record)));
          },
        ),
      ),
    );
  }

  _getCurrentLocation() {
    geol
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getdistances(List<DocumentSnapshot> snapshot) async {
    // distances = snapshot.map((data) async => await );
    for (DocumentSnapshot e in snapshot) {
      GeoPoint loc = e.data['location'];
      distances[loc] = await distance(loc);
    }
  }

  String distformat(double distance) {
    if (distance < 1000) {
      return distance.truncate().toString() + ' m away';
    } else {
      double distround = distance / 1000;
      return distround.toStringAsFixed(2) + ' km away';
    }
  }
}
