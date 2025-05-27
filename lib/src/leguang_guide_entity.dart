import 'package:flutter/widgets.dart';

class GuideEntity{
  final GlobalKey keyId;
  String? title;

  GuideEntity({
    required this.keyId,
    this.title
  });
}

class GuideStepEntity{
  final String title;
  final Size size;
  final Offset offset;

  GuideStepEntity({
    required this.title,
    required this.size,
    required this.offset
  });
}