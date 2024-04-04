
import 'package:erp_teacher/features/Notes/ui/notes.dart';
import 'package:erp_teacher/features/attendance/ui/attendance.dart';
import 'package:flutter/material.dart';

import '../../bus location/ui/bus_location.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
    body:SizedBox(
      child:GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            elevation: 2,
            color: Colors.blueGrey,
            child: IconButton(
              onPressed: (){
                Navigator.push(context , MaterialPageRoute(builder: (context)=>const BusLocation()));
              },
              icon:Image.asset("assets/images/location.png")
            )
          ),
          Card(
              elevation: 2,
              color: Colors.blueGrey,
              child: IconButton(
                onPressed: (){
                  Navigator.push(context , MaterialPageRoute(builder: (context)=>const Attendance()));
                },
                icon: Image.asset("assets/images/attendance.png",color: Colors.white70,),
              )
          ),
          Card(
              elevation: 2,
              color: Colors.blueGrey,
              child: IconButton(
                onPressed: (){
                  Navigator.push(context , MaterialPageRoute(builder: (context)=>const Notes()));
                },
                icon: Image.asset("assets/images/notes.png",),
              )
          ),
        ],
      )
    )
    );
  }
}
