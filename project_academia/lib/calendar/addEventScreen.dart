// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:sample1/calendar/calendarModel.dart';
// import 'package:sample1/calendar/db.dart';
// import 'package:sample1/calendar/validation.dart';
// import 'package:table_calendar/table_calendar.dart';

// class AddEvent extends StatefulWidget {

//   @override
//   _AddEventState createState() => _AddEventState ();
// }

// class _AddEventState extends State<AddEvent> {

//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _title; 
//   TextEditingController _description;
//   TextEditingController _datePick;
//   DateTime _eventDate;
//   TimeOfDay _time;
//   bool processing;
//   String header = "Add New Task";
//   String buttonText = "Save";
//   bool addNewTask = true;
  
//   DateTime _date = DateTime.now();
//   TextEditingController _dateController = TextEditingController();

//   final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

//   DateTime _selectedDay = DateTime.now();
//   List<dynamic> _selectedEvents = [];
//   Map<DateTime, List<dynamic>> _events = {};
//   List<CalendarItem> _data = [];



//   @override
//   void initState() {
//     super.initState();
//     _title = TextEditingController();
//     _description = TextEditingController();
//     _datePick = TextEditingController();
//     _eventDate = DateTime.now();
//     _time = TimeOfDay.now();
//     // if (widget.event != null) {
//     //   populateForm();
//     // }
//     processing = false;
//     DB.init().then((value) => _fetchEvents());
//   }

//   Future<bool> _onBackPressedWithButton() async {
//     Navigator.of(context).pop(false);
//     return false;
//   }

//   void _addEvent(String event) async {
//     CalendarItem item =
//         CalendarItem(date: _selectedDay.toString(), name: event);
//     await DB.insert(CalendarItem.table, item);
//     _selectedEvents.add(event);
//     _fetchEvents();

//     Navigator.pop(context);
//   }

//   void _fetchEvents() async {
//     _events = {};
//     List<Map<String, dynamic>> _results = await DB.query(CalendarItem.table);
//     _data = _results.map((item) => CalendarItem.fromMap(item)).toList();
//     _data.forEach((element) {
//       DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
//           .format(DateTime.parse(element.date.toString())));
//       if (_events.containsKey(formattedDate)) {
//         _events[formattedDate].add(element.name.toString());
//       } else {
//         _events[formattedDate] = [element.name.toString()];
//       }
//     });
//     setState(() {});
//   }

//   // void _create(BuildContext context) {
//   //   String _name = "";
//   //   var content = TextField(
//   //     style: GoogleFonts.montserrat(
//   //         color: Color.fromRGBO(105, 105, 108, 1), fontSize: 16),
//   //     autofocus: true,
//   //     decoration: InputDecoration(
//   //       labelStyle: GoogleFonts.montserrat(
//   //           color: Color.fromRGBO(59, 57, 60, 1),
//   //           fontSize: 18,
//   //           fontWeight: FontWeight.normal),
//   //       labelText: 'Event Name',
//   //     ),
//   //     onChanged: (value) {
//   //       _name = value;
//   //     },
//   //   );
//   //   var btn = FlatButton(
//   //     child: Text('Save',
//   //         style: GoogleFonts.montserrat(
//   //             color: Color.fromRGBO(59, 57, 60, 1),
//   //             fontSize: 16,
//   //             fontWeight: FontWeight.bold)),
//   //     onPressed: () => _addEvent(_name),
//   //   );
//   //   var cancelButton = FlatButton(
//   //       child: Text('Cancel',
//   //           style: GoogleFonts.montserrat(
//   //               color: Color.fromRGBO(59, 57, 60, 1),
//   //               fontSize: 16,
//   //               fontWeight: FontWeight.bold)),
//   //       onPressed: () => Navigator.of(context).pop(false));
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) => Dialog(
//   //       shape: RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.circular(6),
//   //       ),
//   //       elevation: 0.0,
//   //       backgroundColor: Colors.transparent,
//   //       child: Stack(
//   //         children: <Widget>[
//   //           Container(
//   //             padding: EdgeInsets.all(6),
//   //             decoration: BoxDecoration(
//   //               color: Colors.white,
//   //               shape: BoxShape.rectangle,
//   //               borderRadius: BorderRadius.circular(6),
//   //               boxShadow: [
//   //                 BoxShadow(
//   //                   color: Colors.black26,
//   //                   blurRadius: 10.0,
//   //                   offset: const Offset(0.0, 10.0),
//   //                 ),
//   //               ],
//   //             ),
//   //             child: Column(
//   //               mainAxisSize: MainAxisSize.min, // To make the card compact
//   //               children: <Widget>[
//   //                 SizedBox(height: 16.0),
//   //                 Text("Add Event",
//   //                     style: GoogleFonts.montserrat(
//   //                         color: Color.fromRGBO(59, 57, 60, 1),
//   //                         fontSize: 18,
//   //                         fontWeight: FontWeight.bold)),
//   //                 Container(padding: EdgeInsets.all(20), child: content),
//   //                 Row(
//   //                     mainAxisSize: MainAxisSize.min,
//   //                     children: <Widget>[btn, cancelButton]),
//   //               ],
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   _handleDatePicker() async {
//     final DateTime date = await showDatePicker(
//       context: context, 
//       initialDate: _date, 
//       firstDate: DateTime.now(), 
//       lastDate: DateTime(2050),
//     );
//     if (date != null && date != _date){
//       setState(() {
//         _date = date;
//       });
//       _dateController.text = _dateFormatter.format(date);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String _name = "";
//     return WillPopScope(
//       onWillPop: _onBackPressedWithButton,
//       child: Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               alignment: Alignment.bottomLeft,
//               height: 80,
//               child: IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: () {
//                     _onBackPressedWithButton();
//                   }),
//             ),
//             Container(
//                 padding: EdgeInsets.symmetric(horizontal: 32),
//                 child: Text(header,
//                     style:
//                         TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
//             Expanded(
//               child: Form(
//                 key: _formKey,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: MediaQuery.removePadding(
//                     context: context,
//                     removeTop: true,
//                     child: ListView(
//                       //physics: BouncingScrollPhysics(),
//                       // crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 8.0),
//                           child: TextFormField(
                            
//                             controller: _title,
//                             //validator: validateTextInput,
//                             decoration: InputDecoration(
//                                 labelText: "Title",
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10))),
//                                     onChanged: (value) {
//                                     _name = value;
//                                   },
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 8.0),
//                           child: TextFormField(
//                             textInputAction: TextInputAction.done,
//                             controller: _description,
//                             minLines: 3,
//                             maxLines: 5,
//                             //validator: validateTextInput,
//                             decoration: InputDecoration(
//                                 labelText: "description",
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10))),
//                           ),
//                         ),
//                         SizedBox(height: 10.0),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 20, 
//                             vertical: 10,
//                           ),
//                           child: TextFormField(
//                             textInputAction: TextInputAction.done,
//                             controller: _dateController,
//                             style: TextStyle(
//                               fontSize: 18,
//                             ),
//                             onTap: _handleDatePicker,
//                             decoration: InputDecoration(
//                               labelText: 'Date',
//                               labelStyle: TextStyle(fontSize: 18),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10.0),
//                         ListTile(
//                           title: Text("Select Date of Task"),
//                           subtitle: Text(
//                               "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
//                           onTap: () async {
//                             DateTime picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: _eventDate,
//                                 firstDate: DateTime(_eventDate.year - 5),
//                                 lastDate: DateTime(_eventDate.year + 5));
//                             if (picked != null) {
//                               setState(() {
//                                 _eventDate = picked;
//                               });
//                             }
//                           },
//                         ),
//                         SizedBox(height: 10.0),
//                         ListTile(
//                           title: Text("Select Time of Task"),
//                           subtitle: Text(_time.format(context)),
//                           onTap: () async {
//                             TimeOfDay picked = await showTimePicker(
//                                 context: context, initialTime: _time);

//                             if (picked != null) {
//                               setState(() {
//                                 _time = picked;
//                               });
//                             }
//                           },
//                         ),
//                         SizedBox(height: 10.0),
//                         processing
//                             ? Center(child: CircularProgressIndicator())
//                             : Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16.0),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: <Widget>[
//                                     ElevatedButton(
//                                       child: Text(buttonText),
//                                       style: ElevatedButton.styleFrom(
//                                         padding: EdgeInsets.symmetric(
//                                                 horizontal: 40, vertical: 40),
//                                                 primary: Colors.redAccent,
//                                                 onPrimary: Colors.white,
//                                                 shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(25.0),),
//                                       ),
                                        
//                                         onPressed: () async {
//                                           // if (_formKey.currentState
//                                           //     .validate()) {
//                                           //   setState(() {
//                                           //     processing = true;
//                                           //   });
//                                           //   saveTask();
//                                           // }
//                                           _addEvent(_name);
//                                         }),
//                                     SizedBox(height: 10.0),
//                                     Container(
//                                       child: !addNewTask
//                                           ? ElevatedButton(
//                                               child: Text("Delete",),
//                                               style: ElevatedButton.styleFrom(
//                                                 padding: EdgeInsets.symmetric(
//                                                 horizontal: 40, vertical: 40),
//                                                 primary: Colors.redAccent,
//                                                 onPrimary: Colors.white,
//                                                 shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(25.0),),
//                                               ),
//                                               onPressed: () {
//                                                 // setState(() {
//                                                 //   processing = true;
//                                                 // });
//                                                 // deleteTask();
//                                               }
//                                           )
//                                           : Container(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
