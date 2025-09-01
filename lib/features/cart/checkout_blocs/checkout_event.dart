sealed class CheckoutEvent {}

final class CheckoutSubmitted extends CheckoutEvent {
  final String fullName;
  final String phoneNumber;
  final String address;
  final String email;

  final bool isDeliverable;

  CheckoutSubmitted({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.isDeliverable,
  });
}
