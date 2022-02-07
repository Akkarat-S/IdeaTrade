class Limitout {
  String TimeLimit(String start, String select) {
    //String s = "30/12/2022 23:19";
    //String timeselect = "45";
    String s = start, timeselect = select;
    print(s);
    print(timeselect);
    int timeout = int.parse(timeselect);

    List<String> ds = s.split(" ");
    //print(ds[1]);
    List<String> sday = ds[0].split("/");
    int day = int.parse(sday[0]);
    int mount = int.parse(sday[1]);
    int year = int.parse(sday[2]);

    List<String> time = ds[1].split(":");
    late int h, m;
    h = int.parse(time[0]);
    m = int.parse(time[1]);

    m = timeout + m;
    if (m > 60) {
      h = h + 1;
      m = m - 60;

      if (h > 23) {
        h = h - 24;
        day = day + 1;
        //print(day);

        // 4 6 9 11 # 30
        if (mount == 4 || mount == 6 || mount == 9 || mount == 11) {
          if (day > 30) {
            day = day - 30;
            mount = mount + 1;

            if (mount > 12) {
              mount = mount - 12;
              year = year + 1;
            }
          }
        }
        // 2 #28
        else if (mount == 2) {
          if (day > 28) {
            day = day - 28;
            mount = mount + 1;

            if (mount > 12) {
              mount = mount - 12;
              year = year + 1;
            }
          }
        }
        // 1 3 5 7 8 10 12 #31
        else if (mount == 1 ||
            mount == 3 ||
            mount == 5 ||
            mount == 7 ||
            mount == 8 ||
            mount == 10 ||
            mount == 12) {
          if (day > 31) {
            day = day - 31;
            mount = mount + 1;

            if (mount > 12) {
              mount = mount - 12;
              year = year + 1;
            }
          }
        }
      }
    }
    //print("$day/$mount/$year $h:$m");
    return "$day/$mount/$year $h:$m";
  }
}
