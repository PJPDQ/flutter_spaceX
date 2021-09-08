import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spacex_project/controller/details_pages.dart';
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
  List<String> dropDown = <String>[
    "Launch Date",
    "Mission name",
    "Launch Success"
  ];

  @override
  void initState() {
    super.initState();
    this.fetchLaunches();
  }

  fetchLaunches() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://api.spacexdata.com/v3/launches";
    var response = await http.get(Uri.parse(url));
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

  void sortOptions(String value) {
    print("sorting...");
    sortedLaunch = launches.map((e) => e).toList();
    switch (value) {
      case 'Launch Date':
        print('Launch date');
        sortedLaunch.sort((first, second) =>
            first['launch_date_local'].compareTo(second['launch_date_local']));
        print(sortedLaunch.length);
        break;
      case 'Mission name':
        print('Mission Name');
        sortedLaunch.sort((first, second) =>
            first['mission_name'].compareTo(second['mission_name']));
        print(sortedLaunch.length);
        break;
      case 'Launch Success':
        print('LaunchSuccess');
        sortedLaunch = launches
            .where((launch) => launch['launch_success'] == true)
            .toList();
        print(sortedLaunch.length);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Listing of Launches'),
          new DropdownButton<String>(
              underline: Container(),
              icon: Icon(Icons.sort, color: Colors.white),
              items: dropDown.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  sortOptions(value);
                });
              })
        ],
      )),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (sortedLaunch.contains(null) || sortedLaunch.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
        itemCount: sortedLaunch.length,
        itemBuilder: (context, index) {
          return getCard(sortedLaunch[index]);
        });
  }

  Widget getCard(index) {
    var mission_name = index['mission_name'];
    var mission_year = index['launch_year'];
    var rocket = index['rocket']['rocket_name'];
    var rocket_id = index['rocket']['rocket_id'];
    var flight_num = index['flight_number'];
    var flight_img = index['links']['mission_patch'];
    return Card(
      child: new InkWell(
        onTap: () {
          print("Tapped");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  DetailedPage(flight_num: flight_num, rocket_id: rocket_id),
            ),
          );
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
