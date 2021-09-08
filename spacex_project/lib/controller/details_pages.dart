import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:spacex_project/views/rocket_images.dart';
import 'package:spacex_project/theme/colors.dart';
import '../constant.dart';
import '../modal/details_modal.dart';

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
    var flightResponse = await http.get(Uri.parse(flightUrl));
    var rocketResponse = await http.get(Uri.parse(rocketUrl));
    if (flightResponse.statusCode == 200 && rocketResponse.statusCode == 200) {
      setState(() {
        flightDetail = LaunchDetails.fromJson(json.decode(flightResponse.body));
        rocketDetail = RocketDetails.fromJson(json.decode(rocketResponse.body));
        isLoading = false;
      });
    } else {
      print("error");
      setState(() {
        isLoading = false;
        flightDetail = LaunchDetails();
        rocketDetail = RocketDetails();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
        ));
  }

  Widget getLaunch() {
    if (flightDetail == null || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    print(flightDetail.missionName);
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      body: getBody(flightDetail),
    );
  }

  Widget getBody(launch) {
    var size = MediaQuery.of(context).size;
    print(flightDetail.imgUrl.length);

    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(flightDetail.missionPatch),
                  fit: BoxFit.cover),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/icons/back-icon.svg")),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.45),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    child: Container(
                      width: 150,
                      height: 7,
                      decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    flightDetail.missionName,
                    style: TextStyle(fontSize: 20, height: 1.5),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(flightDetail.missionPatch),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            flightDetail.rocketId +
                                " " +
                                flightDetail.rocketName,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            flightDetail.launchYear,
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text((() {
                    if (flightDetail.details != null) {
                      return flightDetail.details;
                    }
                    return '';
                  })()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Gallery",
                    style: TextStyle(fontSize: 18),
                  ),
                  // LaunchImages(launch: flightDetail),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List.generate(flightDetail.imgUrl.length, (index) {
                        return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          flightDetail.imgUrl[index]),
                                      fit: BoxFit.cover)),
                            ));
                      }),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getRocket() {
    var width = MediaQuery.of(context).size.width;
    if (rocketDetail == null || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView(
      children: [
        RocketImages(rocket: rocketDetail),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: (20 / 375) * width),
              child: Text(
                rocketDetail.rocketName,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: (20 / 375) * width,
                right: (64 / 375) * width,
              ),
              child: Text(
                rocketDetail.description,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (20 / 375) * width,
                vertical: 10,
              ),
              child: _getRocketDetails(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getRocketDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Text(
          'Specification:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Success Rate: " + rocketDetail.successRate.toString() + "%",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Cost /Launch: US" +
              new String.fromCharCodes(new Runes('\u0024')) +
              rocketDetail.costsPerLaunch.toString(),
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'First Flight: ' + rocketDetail.firstFlight,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Company: ' + rocketDetail.company,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Dimension (height): ' + rocketDetail.height.toString() + 'meters',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Dimension (Diameter): ' +
              rocketDetail.diameter.toString() +
              'meters',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Mass: ' + rocketDetail.mass.toString() + 'kg',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Wikipedia: ' + rocketDetail.wikiLink,
          style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
    // }
  }
}
