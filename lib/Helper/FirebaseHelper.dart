import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static const String insuranceCollection = 'Insurance';

  static Future<void> updateInsurance(int type, String insuranceText) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection(insuranceCollection);
    DocumentReference doc;
    if (type == 0)
      doc = reference.doc('truk_company');
    else
      doc = reference.doc('common');

    doc.set({'insurance': insuranceText});
  }

  static Future<String> getInsurance(int type) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection(insuranceCollection);
    DocumentReference doc;
    if (type == 0)
      doc = reference.doc('truk_company');
    else
      doc = reference.doc('common');

    DocumentSnapshot snapshot = await doc.get();
    dynamic data = snapshot.data();

    return data['insurance']!;
  }
}
