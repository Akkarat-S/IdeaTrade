class NowDate {
  String datetime() {
    DateTime _now = DateTime.now();
    String date = '${_now.day}/${_now.month}/${_now.year}';
    String day = '${_now.day}';
    String month = '${_now.month}';
    String year = '${_now.year}';
    var num = _now.year + 543;
    String d = '';
    if (month == '1') {
      d = "ม.ค.";
    } else if (month == '2') {
      d = "ก.พ.";
    } else if (month == '3') {
      d = "มี.ค.";
    } else if (month == '4') {
      d = "เม.ย.";
    } else if (month == '5') {
      d = "พ.ค.";
    } else if (month == '6') {
      d = "มิ.ย.";
    } else if (month == '7') {
      d = "ก.ค.";
    } else if (month == '8') {
      d = "ส.ค.";
    } else if (month == '9') {
      d = "ก.ย.";
    } else if (month == '10') {
      d = "ต.ค.";
    } else if (month == '11') {
      d = "พฤ.ย.";
    } else if (month == '12') {
      d = "ธ.ค.";
    }
    //print(date);
    String now = "$day $d $num";
    //print("$day $d $num");
    return now;
  }
}
