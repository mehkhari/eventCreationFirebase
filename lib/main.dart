import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/firebase_helper.dart';
import 'package:demo/theme/customColors.dart';
import 'package:demo/views/editEvent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _calendarControllerToday = AdvancedCalendarController.today();
  final List<DateTime> events = [
    DateTime.now(),
    DateTime(2022, 10, 10),
  ];
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> collectionReference = FirebaseCloud.readEmployee();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:const Text("ListEventScreen",style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            AdvancedCalendar(
              controller: _calendarControllerToday,
              events: events,
              startWeekDay: 1,
            ),
            Expanded(child:
            StreamBuilder(
              stream: collectionReference,
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasData){
                  return ListView(
                    children: snapshot.data!.docs.map((e){
                      return Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const[
                                  Text("24",style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black54
                                  ),),
                                  Text("Sun",style: TextStyle(
                                      color: Colors.black54
                                  ),)
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width*0.8,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${e['eventName']}",style:const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 18
                                  ),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditEvent(
                                          docId: e.id,
                                          eventName: "${e['eventName']}",
                                        )));
                                      }, child:const Text("Edit",style: TextStyle(
                                          color: Colors.blueGrey
                                      ),)),
                                      TextButton(onPressed: ()async{
                                        var response=await FirebaseCloud.deleteEmployee(docId: e.id);
                                        if(response.code==200){
                                          debugPrint("Deleted id ${e.id}");
                                        }
                                         }, child:const Text("Remove",style: CustomColors.customRedStyle,)),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }else{
                 return CircularProgressIndicator();
                }
              },
            )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                fixedSize: Size(double.maxFinite, 40)
              ),
                onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EditEvent(
                  eventName: "",
                  docId: "",
                )));
                },
                child:const Text("Add new Event",style: CustomColors.customRedStyle,)
            )
          ],
        ),
      ),
    );
  }
}
