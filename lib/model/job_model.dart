class JobModel {
  String jobID;
  String CreaterID;
  String DateTime;
  String DateTimeLimit;
  String Time;
  String JobImage;
  String JobTeam;
  String Note;
  String Recive;
  String Status;
  String Subject;
  String Reason;

  JobModel(
      {required this.jobID,
      required this.CreaterID,
      required this.DateTime,
      required this.DateTimeLimit,
      required this.Time,
      required this.JobImage,
      required this.JobTeam,
      required this.Note,
      required this.Recive,
      required this.Status,
      required this.Subject,
      required this.Reason});
}
