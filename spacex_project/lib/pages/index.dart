import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spacex_project/theme/colors.dart';
import 'package:http/http.dart' as http;

class IndexPage extends StatefulWidget {
  // const IndexPage({ Key? key }) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List launches = [];
  List sortedLaunch = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchLaunches();
  }

  fetchLaunches() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://api.spacexdata.com/v3/launches?limit=10";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        launches = sortedLaunch = items;
        isLoading = false;
      });
    } else {
      print("error");
      launches = sortedLaunch = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listing of Launches"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (launches.contains(null) || launches.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
        itemCount: launches.length,
        itemBuilder: (context, index) {
          return getCard(launches[index]);
        });
  }

  onSortDate() {
    setState(() {
      sortedLaunch.sort(
          (a, b) => b['launch_date_local'].compareTo(a['launch_date_local']));
    });
  }

  onSortMissionName() {
    setState(() {
      sortedLaunch
          .sort((a, b) => b['mission_name'].compareTo(a['mission_name']));
    });
  }

  Widget getCard(index) {
    var mission_name = index['mission_name'];
    var mission_year = index['launch_year'];
    var rocket = index['rocket']['rocket_name'];
    var flight_num = index['flight_number'];
    var flight_img = index['links']['mission_patch'];
    return Card(
      child: new InkWell(
        onTap: () {
          print("Tapped");
        },
        child: ListTile(
            title: Row(
          children: <Widget>[
            Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(60 / 2),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(flight_img.toString())))),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  mission_name.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  mission_year.toString(),
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  flight_num.toString(),
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  rocket.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}
