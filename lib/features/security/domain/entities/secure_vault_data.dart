class SecureVaultData {
  const SecureVaultData({
    required this.savedPassword,
    required this.privateNotes,
    required this.phoneNumber,
    required this.cardNumber,
  });

  final String savedPassword;
  final String privateNotes;
  final String phoneNumber;
  final String cardNumber;

  static const empty = SecureVaultData(
    savedPassword: '',
    privateNotes: '',
    phoneNumber: '',
    cardNumber: '',
  );
}
