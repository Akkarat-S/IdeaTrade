class LogModel {
  String logID;
  String JobID;
  String DateLog;
  String Owner;
  String Status;
  String Type;
  DateTime DateAt;

  LogModel(
      {required this.logID,
      required this.JobID,
      required this.DateLog,
      required this.Owner,
      required this.Status,
      required this.Type,
      required this.DateAt});
}
