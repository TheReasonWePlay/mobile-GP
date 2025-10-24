import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  int present = 29;
  int late = 18;
  int agent = 32;
  int percent = 86;

  Widget topWid = Container(
    height: 300,
    margin: EdgeInsets.all(0),
    decoration: BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blueAccent,
          Colors.deepPurpleAccent,
      ])
    ),
    child: Container(
      margin: EdgeInsets.only(top: 60, left: 40, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, color: Colors.white,),
              Text("Thursday, October 23",
                style:
                  TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
              ),
            ],
          ),
          Container(height: 20,),
          Text("Welcome back",
            style:
            TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Here's today's attendance overview",
            style:
            TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    )
  );

  late Widget averageCard = Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: 210, left: 20, right: 20),
        height: 180,
        padding: EdgeInsets.only(top: 0, left: 30, right: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              margin: EdgeInsets.only(top: 64),
              child: Column(
                children: [
                  Text("Attendance Rate",
                    style:
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                  Text("$present of $agent checked in"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: 95,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blueAccent,
                        Colors.deepPurpleAccent,
                      ])
              ),
              child: Text("$percent%",
                style:
                TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      //---------------------------------------------------------------
      Container(
        margin: EdgeInsets.only(top: 5, left: 20, right: 20),
        height: 140,
        padding: EdgeInsets.only(top: 10, left: 0, right: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.greenAccent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Present", style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),),
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Icon(Icons.person_outline, color: Colors.white,),
                              )
                            ],
                          ),
                        ),
                        Text("$present", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),)
                      ],
                    ),
                  ),
                  Container(
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.orangeAccent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Late", style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),),
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Icon(Icons.watch_later_outlined, color: Colors.white,),
                              )
                            ],
                          ),
                        ),
                        Text("$late", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),)
                      ],
                    ),
                  )
                ],
              )
          ],
        ),
      ),
      //---------------------------------------------------------------------
      Container(
        margin: EdgeInsets.only(top: 48, left: 20, right: 20),
        height: 90,
        padding: EdgeInsets.only(top: 0, left: 30, right: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
            Colors.blueAccent,
            Colors.deepPurpleAccent,
          ]),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              margin: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Quick Scan", style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                  Text(" Make Attendance", style: TextStyle(
                    color: Colors.white,
                  ),),
                ],
              ),
            ),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Icon(Icons.arrow_forward, color: Colors.white,),
            ),
          ],
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            topWid,
            averageCard,
          ],
        )
      ],
    );
  }
}