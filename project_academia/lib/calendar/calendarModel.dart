class CalendarItem {
  static String table = "events";
  
  int id;
  String name;
  String date;
  String time;

  CalendarItem({this.id, this.name, this.date, this.time});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name, 
      'date': date,
      'time': time
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

    static CalendarItem fromMap(Map<String, dynamic> map) {
    return CalendarItem(
        id: map['id'],
        name: map['name'],
        time: map['time'],
        date: map['date']);
  }
}
