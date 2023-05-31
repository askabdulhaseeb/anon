import '../../models/agency/agency.dart';

class AgencyAPI {
  static const String _collectionName = 'agencies';
  Future<void> add(Agency value) async {
    try {} catch (e) {
      throw 'Something going wrong';
    }
  }
}
