import 'package:flutter/material.dart';
import '../modal/details_modal.dart';
import '../theme/colors.dart';

class LaunchImages extends StatefulWidget {
  const LaunchImages({
    Key key,
    this.launch,
  }) : super(key: key);

  final LaunchDetails launch;

  @override
  _LaunchImagesState createState() => _LaunchImagesState();
}

class _LaunchImagesState extends State<LaunchImages> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   width: 60,
        //   child: AspectRatio(
        //     aspectRatio: 1,
        //     child: Hero(
        //       tag: widget.launch.missionName.toString(),
        //       child: Image.asset(widget.launch.imgUrl[selectedImage]),
        //     ),
        //   ),
        // ),
        SizedBox(height: (20 / 375) * MediaQuery.of(context).size.width),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.launch.imgUrl.length,
                (index) => buildSmallLaunchPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallLaunchPreview(int index) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: (48 / 375) * width,
        width: (48 / 375) * width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: primary.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.launch.imgUrl[index]),
      ),
    );
  }
}
