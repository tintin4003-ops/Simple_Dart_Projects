class PaymentResult {
  final bool success;
  final String message;
  final String? transactionId;

  PaymentResult.success(this.message, this.transactionId) : success = true;

  PaymentResult.failure(this.message)
      : success = false,
        transactionId = null;

  @override
  String toString() {
    if (success) return "SUCCESS: $message (txn: $transactionId)";
    return "FAILED: $message";
  }
}
