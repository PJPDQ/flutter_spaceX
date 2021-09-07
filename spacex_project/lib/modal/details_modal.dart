import 'package:flutter/cupertino.dart';

class LaunchDetails {
  final int flightNum;
  final String missionName;
  final String launchYear;
  final String rocketId;
  final String rocketName;
  final String details;
  final List<String> imgUrl;
  final String missionPatch;
  final String wikiLink;
  final String articleLink;
  const LaunchDetails(
      {this.flightNum,
      this.missionName,
      this.launchYear,
      this.rocketId,
      this.rocketName,
      this.details,
      this.imgUrl,
      this.missionPatch,
      this.wikiLink,
      this.articleLink});
}

class RocketDetails {
  final int id;
  final int costsPerLaunch;
  final int successRate;
  final String firstFlight;
  final String country;
  final String company;
  final double height;
  final double diameter;
  final int mass;
  final String wikiLink;
  final String description;
  final String rocketId;
  final String rocketName;
  const RocketDetails(
      {this.id,
      this.costsPerLaunch,
      this.successRate,
      this.firstFlight,
      this.country,
      this.company,
      this.height,
      this.diameter,
      this.mass,
      this.wikiLink,
      this.description,
      this.rocketId,
      this.rocketName});
}

class TabChoice {
  final String choice;
  final IconData icon;
  final RocketDetails rocket;
  final LaunchDetails launch;
  const TabChoice({this.choice, this.icon, this.rocket, this.launch});
}
