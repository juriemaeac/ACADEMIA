import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Attendance extends StatelessWidget {

  String subNow;
  @override
  Widget build(BuildContext context) {

    TextStyle def = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm aa').format(now);
    return Scaffold(
      backgroundColor: Colors.grey[25],
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                formattedDate + " — $formattedTime",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                'Current Class:',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE28C7E),
                  borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Course Code:", style: def),
                          SizedBox(height: 15.0),
                          Text("Course Name:", style: def),
                          SizedBox(height: 15.0),
                          Text("Time", style: def),
                          SizedBox(height: 15.0),
                          Text("Professor:", style: def),
                          SizedBox(height: 15.0),
                          Text("Status:", style: def),
                        ],
                      ),
                    ),
                  ),
                  height: 200.0,
                ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Say Present!',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600)),
                  ),
                  color: Colors.red[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    )
                  ),
                  onPressed: () {},
                ),
              ),
              Text(
                'Next Class:',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE28C7E),
                  borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Course Name:", style: def),
                          SizedBox(height: 24.0),
                          Text("Time", style: def),
                          SizedBox(height: 24.0),
                          Text("Status:", style: def),
                        ],
                      ),
                    ),
                  height: 150.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
