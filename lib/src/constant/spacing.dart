import 'package:flutter/cupertino.dart';

class verticalspace extends StatelessWidget {
  double height;
  verticalspace({super.key, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class horizontalspace extends StatelessWidget {
  double width;
  horizontalspace({super.key, this.width = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
