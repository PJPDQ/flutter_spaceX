import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacex_project/theme/colors.dart';
import '../modal/details_modal.dart';
import 'package:google_fonts/google_fonts.dart';
import '../details/body.dart';

const List<TabChoice> choices = <TabChoice>[
  TabChoice(choice: 'One Launch Endpoint', icon: Icons.airport_shuttle),
  TabChoice(choice: 'One Rocket Endpoint', icon: Icons.flight),
];

class DetailedPage extends StatefulWidget {
  final int flight_num;
  final String rocket_id;
  const DetailedPage({Key key, this.flight_num, this.rocket_id})
      : super(key: key);

  @override
  _DetailedPageState createState() => _DetailedPageState(
      flight_num: this.flight_num, rocket_id: this.rocket_id);
}

class _DetailedPageState extends State<DetailedPage>
    with SingleTickerProviderStateMixin {
  int flight_num;
  String rocket_id;
  _DetailedPageState({this.flight_num, this.rocket_id});
  bool isLoading = false;
  LaunchDetails flightDetail;
  RocketDetails rocketDetail;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    this.fetchLaunch();
    _tabController = new TabController(length: choices.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  fetchLaunch() async {
    var flightUrl = "https://api.spacexdata.com/v3/launches/$flight_num";
    var rocketUrl = "https://api.spacexdata.com/v3/rockets/$rocket_id";
    print(flightUrl);
    print(rocketUrl);
    var flightResponse = await http.get(flightUrl);
    var rocketResponse = await http.get(rocketUrl);
    if (flightResponse.statusCode == 200 && rocketResponse.statusCode == 200) {
      var launchItems = json.decode(flightResponse.body);
      var rocketItems = json.decode(rocketResponse.body);
      print(launchItems);
      print(rocketItems);
      setState(() {
        flightDetail = LaunchDetails(
            flightNum: launchItems["flight_number"],
            missionName: launchItems["mission_name"],
            launchYear: launchItems["launch_year"],
            rocketId: launchItems["rocket"]["rocket_id"],
            rocketName: launchItems["rocket"]["rocket_name"],
            details: launchItems["details"],
            imgUrl: launchItems["links"]["flickr_images"].cast<String>(),
            missionPatch: launchItems["links"]["mission_patch"],
            wikiLink: launchItems["links"]["wikipedia"],
            articleLink: launchItems["links"]["article_link"]);
        rocketDetail = RocketDetails(
            id: rocketItems["id"],
            costsPerLaunch: rocketItems["cost_per_launch"],
            successRate: rocketItems["success_rate_pct"],
            firstFlight: rocketItems["first_flight"],
            country: rocketItems["country"],
            company: rocketItems["company"],
            height: rocketItems["height"]["meters"],
            diameter: rocketItems["diameter"]["meters"],
            mass: rocketItems["mass"]["kg"],
            wikiLink: rocketItems["wikipedia"],
            description: rocketItems["description"],
            rocketId: rocketItems["rocket_id"],
            rocketName: rocketItems["rocket_name"]);
        isLoading = false;
      });
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: choices.length,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Rocket and Launch Detail Page'),
                bottom: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: choices.map<Widget>((TabChoice choice) {
                    return Tab(
                      text: choice.choice,
                    );
                  }).toList(),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  getLaunch(),
                  getRocket(),
                ],
              ),
            )));
  }

  Widget getLaunch() {
    if (flightDetail == null || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(flightDetail.missionPatch),
            fit: BoxFit.cover,
          )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      offset: Offset(0, -4),
                      blurRadius: 8)
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      flightDetail.missionName.toString(),
                      style: GoogleFonts.ptSans(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ]),
              )
            ]),
          ),
        )
      ],
    ));
  }

  Widget getRocket() {
    if (rocketDetail == null || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return Scaffold(
        body: Stack(
      children: [
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: NetworkImage(rocketDetail.imgUrl), fit: BoxFit.cover)),
        // ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      offset: Offset(0, -4),
                      blurRadius: 8)
                ]),
            child: Column(children: [
              Text(
                flightDetail.missionName.toString(),
                style: GoogleFonts.ptSans(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ]),
          ),
        )
      ],
    ));
  }

  // Widget getBody() {
  //   if (rocketDetail == null || flightDetail == null || isLoading) {
  //     return Center(
  //         child: CircularProgressIndicator(
  //       valueColor: new AlwaysStoppedAnimation<Color>(primary),
  //     ));
  //   }
  //   var mission_name = flightDetail.missionName;
  //   var img = flightDetail.imgUrl;
  //   return Scaffold(
  //     body: Center(
  //       child: CustomScrollView(
  //         slivers: <Widget>[
  //           SliverAppBar(
  //             title: Text(mission_name),
  //             backgroundColor: primary,
  //             expandedHeight: 350.0,
  //             flexibleSpace: FlexibleSpaceBar(
  //               centerTitle: true,
  //               title: Text(mission_name),
  //               background: Stack(fit: StackFit.expand, children: <Widget>[
  //                 Image.network(
  //                   img,
  //                   fit: BoxFit.cover,
  //                 ),
  //                 const DecoratedBox(
  //                     decoration: BoxDecoration(
  //                         gradient: LinearGradient(
  //                             begin: Alignment(0, 0.5),
  //                             end: Alignment.center,
  //                             colors: <Color>[
  //                       Color(0x60000000),
  //                       Color(0x00000000),
  //                     ])))
  //               ]),
  //             ),
  //           ),
  //           SliverFixedExtentList(
  //             itemExtent: 200.00,
  //             delegate: SliverChildListDelegate([
  //               Text(flightDetail['mission_name']),
  //               Text(flightDetail['flight_number'].toString()),
  //               Text(flightDetail['launch_year']),
  //               Text(flightDetail['rocket']['rocket_id']),
  //               Text(flightDetail['rocket']['rocket_name']),
  //               Text(flightDetail['links']['mission_patch'])
  //             ]),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
