import 'package:cloud_firestore/cloud_firestore.dart';

class TextAppointment{
	final DocumentReference hospitalId;
  final String hospitalName;
	final DocumentReference patientId;
  final String patientName;
	final String sympText;
  final String classofDisease;
  String status;
	final DocumentReference reference;
	String doctorId;
	TextAppointment.fromSnapshot(DocumentSnapshot snapshot)
		: this.hospitalId = snapshot.data['hospital_id'],
      this.hospitalName = snapshot.data['hospital_name'],
			this.patientId = snapshot.data['patient_id'],
      this.patientName = snapshot.data['patient_name'],
			this.sympText = snapshot.data['symptoms_text'],
      this.classofDisease = snapshot.data['class'],
      this.status = snapshot.data['status'],
			this.reference = snapshot.reference;
	void updateDoctor(String dId) => doctorId = dId;
  void updateStatus(String sts) => status = sts;
}