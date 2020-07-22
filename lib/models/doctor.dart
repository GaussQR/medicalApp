import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappmain/models/user.dart';
class Doctor extends User {
	final String name;
	final DocumentReference hospitalId;
	final String speciality;
	final DocumentReference reference;
	Doctor.fromSnapshot(DocumentSnapshot snapshot)
		: this.name = snapshot.data['name'],
      this.hospitalId = snapshot.data['hospital_id'],
			this.speciality = snapshot.data['speciality'],
			this.reference = snapshot.reference,
      super(uid: snapshot.data['uid'], email: snapshot.data['email']);
}