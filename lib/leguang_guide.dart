library leguang_guide;

import 'package:flutter/material.dart';
import 'package:leguang_guide/leguang_guide_view.dart';
import 'leguang_guide_entity.dart';
export 'leguang_guide_entity.dart';

class LeguangGuide{

  static show({
    required BuildContext context,
    List<GuideEntity> guides = const [],
    String tips = '新手教程'
  }){

    if(guides.isEmpty) return;

    List<GuideStepEntity> steps = [];
    for(var item in guides){
      final RenderBox renderBox = item.keyId.currentContext!.findRenderObject() as RenderBox;
      // 获取 widget 的大小
      final size = renderBox.size;

      print('Size: ${size.width} x ${size.height}');

      // 获取 widget 相对于屏幕的位置
      final position = renderBox.localToGlobal(Offset.zero);
      print('Position: ${position.dx}, ${position.dy}');
      steps.add(GuideStepEntity(
        title: item.title??'',
        size: Size(
          size.width+4,
          size.height+4
        ),
        offset: Offset(position.dx-2, position.dy-2)
      ));
    }

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (_){
        return LeguangGuideView(
          steps: steps,
        );
      }
    );
  }
}

