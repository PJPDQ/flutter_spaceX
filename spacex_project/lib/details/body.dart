import 'package:flutter/material.dart';
import 'package:spacex_project/modal/details_modal.dart';

import '../pages/launch_images.dart';
import '../size_config.dart';

class Body extends StatelessWidget {
  final LaunchDetails launch;
  const Body({Key key, this.launch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LaunchImages(launch: launch),
      ],
    );
  }
}
