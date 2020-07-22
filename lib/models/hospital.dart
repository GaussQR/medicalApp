import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappmain/models/user.dart';
class Hospital extends User {
	final String name;
	final GeoPoint loc;
	List<DocumentReference> doctors;
	final String phoneNo;
	final String facilities;
	final DocumentReference reference;
	Hospital.fromSnapshot(DocumentSnapshot snapshot)
		: this.loc = snapshot.data['location'],
      this.name = snapshot.data['name'],
			this.doctors = snapshot.data['Doctors'].cast<DocumentReference>(),
			this.phoneNo = snapshot.data['contact_no'],
			this.facilities = snapshot.data['facilities'],
			this.reference = snapshot.reference,
      super(uid: snapshot.data['uid'],  email: snapshot.data['email']);
}