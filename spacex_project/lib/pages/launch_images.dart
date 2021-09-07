import 'package:flutter/material.dart';
import '../modal/details_modal.dart';
import '../theme/colors.dart';
import '.././size_config.dart';

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
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.launch.missionName.toString(),
              child: Image.asset(widget.launch.imgUrl[selectedImage]),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.launch.imgUrl.length,
                (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
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
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: primary.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.asset(widget.launch.imgUrl[index]),
      ),
    );
  }
}
