import 'package:flutter/material.dart';
import '../modal/details_modal.dart';

import '../constant.dart';

class RocketImages extends StatefulWidget {
  const RocketImages({
    Key key,
    this.rocket,
  }) : super(key: key);

  final RocketDetails rocket;

  @override
  _RocketImagesState createState() => _RocketImagesState();
}

class _RocketImagesState extends State<RocketImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: (238 / 375) * MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.rocket.id.toString(),
              child: Image.network(widget.rocket.imgUrl[selectedImage]),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.rocket.imgUrl.length,
                (index) => buildSmallRocketPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallRocketPreview(int index) {
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
        height: (48 / 375) * MediaQuery.of(context).size.width,
        width: (48 / 375) * MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.rocket.imgUrl[index]),
      ),
    );
  }
}
