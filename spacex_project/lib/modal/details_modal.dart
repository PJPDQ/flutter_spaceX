import 'package:flutter/cupertino.dart';

double checkDouble(dynamic value) {
  if (value is String) {
    return double.parse(value);
  } else {
    return value + .0;
  }
}

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

  LaunchDetails(
      {this.flightNum,
      this.launchYear,
      this.missionName,
      this.missionPatch,
      this.details,
      this.rocketId,
      this.rocketName,
      this.imgUrl,
      this.wikiLink,
      this.articleLink});

  factory LaunchDetails.fromJson(Map<String, dynamic> json) {
    return LaunchDetails(
      flightNum: json['flight_num'],
      launchYear: json['launch_year'],
      missionName: json['mission_name'],
      missionPatch: json['links']['mission_patch'],
      details: json['details'],
      rocketId: json['rocket']['rocket_id'],
      rocketName: json['rocket']['rocket_name'],
      imgUrl: json["links"]["flickr_images"].cast<String>(),
      wikiLink: json["links"]["wikipedia"],
      articleLink: json["links"]["article_link"],
    );
  }
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
  final List<String> imgUrl;
  RocketDetails(
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
      this.rocketName,
      this.imgUrl});

  factory RocketDetails.fromJson(Map<String, dynamic> json) {
    return RocketDetails(
        id: json["id"],
        costsPerLaunch: json["cost_per_launch"] ?? 0,
        successRate: json["success_rate_pct"] ?? 0,
        firstFlight: json["first_flight"],
        country: json["country"],
        company: json["company"],
        height: checkDouble(json["height"]["meters"]),
        diameter: checkDouble(json["diameter"]["meters"]),
        mass: json["mass"]["kg"] ?? 0,
        wikiLink: json["wikipedia"],
        description: json["description"],
        rocketId: json["rocket_id"],
        rocketName: json["rocket_name"],
        imgUrl: json['flickr_images'].cast<String>());
  }
}

class TabChoice {
  final String choice;
  final IconData icon;
  const TabChoice({this.choice, this.icon});
}
