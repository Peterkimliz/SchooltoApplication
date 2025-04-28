class LoggedData {
  String userId;
  String type;
  String email;
  bool accountCreated;
  bool emailVerified;

  LoggedData(
      {required this.userId,
      required this.accountCreated,
      required this.type,
      required this.email,
      required this.emailVerified});
}
