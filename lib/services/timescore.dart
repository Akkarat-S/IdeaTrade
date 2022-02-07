class TimeScore {
  String timescore(String start) {
    //String start = "30/12/2022 21:19";
    DateTime _now = DateTime.now();
    String date =
        '${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}';
    print(start);

    List<String> partdate = start.split(" ");
    List<String> startday = partdate[0].split("/");
    int sday = int.parse(startday[0]);
    int smount = int.parse(startday[1]);
    int syear = int.parse(startday[2]);

    List<String> starttime = partdate[1].split(":");
    int sh = int.parse(starttime[0]);
    int sm = int.parse(starttime[1]);

    print("$sday/$smount/$syear $sh:$sm");

    //print(date);
    List<String> partlimit = date.split(" ");
    List<String> limit = partlimit[0].split("/");
    int lday = int.parse(limit[0]);
    int lmount = int.parse(limit[1]);
    int lyear = int.parse(limit[2]);

    List<String> timelimit = partlimit[1].split(":");
    int lh = int.parse(timelimit[0]);
    int lm = int.parse(timelimit[1]);

    print("$lday/$lmount/$lyear $lh:$lm");

    int year = syear - lyear;
    //int subyear = year*12;
    int mount = smount - lmount;
    //int submount = mount*30;
    int day = sday - lday;
    int h = sh - lh;
    int m = sm - lm;

    print("$day/$mount/$year $h:$m");

    if (m < 0) {
      m = m + 60;
      h = h - 1;
      if (h < 0) {
        h = h + 24;
        day = day - 1;
        if (mount < 0) {
          // 4 6 9 11 # 30
          if (smount == 4 || smount == 6 || smount == 9 || smount == 11) {
            smount = smount - 1;
            mount = mount - 1;
            day = day + 30;
          }
          // 2 #28
          else if (smount == 2) {
            smount = smount - 1;
            mount = mount - 1;
            day = day + 28;
          }
          // 1 3 5 7 8 10 12 #31
          else if (smount == 1 ||
              smount == 3 ||
              smount == 5 ||
              smount == 7 ||
              smount == 8 ||
              smount == 10 ||
              smount == 12) {
            smount = smount - 1;
            mount = mount - 1;
            day = day + 31;
          }
        }
      }
    }
    day = day + year * 365;
    day = day + mount * 30;
    h = h + day * 24;
    for (int x = 0; x < 1;) {
      if (m < 0) {
        h = h - 1;
        m = m + 60;
      } else {
        x = x + 1;
      }
    }
    print("$h:$m");
    return "$h:$m";
  }
}
