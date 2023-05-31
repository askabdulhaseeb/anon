import 'package:firedart/firedart.dart';

import '../../models/agency/agency.dart';

class AgencyAPI {
  final CollectionReference _collection =
      Firestore.instance.collection('agencies');

  Future<void> add(Agency value) async {
    try {
      await _collection.document(value.agencyID).set(value.toMap());
    } catch (e) {
      throw 'Something going wrong';
    }
  }
}
