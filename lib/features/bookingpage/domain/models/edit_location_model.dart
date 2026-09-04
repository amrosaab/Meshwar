import '../../../home/domain/models/stop_address_model.dart';
import '../../../home/domain/models/user_details_model.dart';

class EditLocation {
  final OnTripRequestData requestData;
  final List<AddressModel> dropAddressList;

  EditLocation({required this.requestData, required this.dropAddressList});
}
