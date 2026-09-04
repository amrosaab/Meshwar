import 'package:rxdart/rxdart.dart';

class RideRepository {
  final BehaviorSubject<bool> _paymentReceivedController =
      BehaviorSubject.seeded(false);

  Stream<bool> get paymentReceivedStream => _paymentReceivedController.stream;

  void updatePaymentReceived(bool value) {
    _paymentReceivedController.add(value);
  }
}
