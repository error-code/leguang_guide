import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:leguang_guide/src/leguang_guide_box.dart';
import '../leguang_guide.dart';


class LeguangGuideView extends StatefulWidget {
  const LeguangGuideView({super.key,this.steps = const []});
  final List<GuideStepEntity> steps;

  @override
  State<LeguangGuideView> createState() => _LeguangGuideViewState();
}

class _LeguangGuideViewState extends State<LeguangGuideView> {

  int current = -1;
  Offset offset = const Offset(0, 0);
  Size size = const Size(0, 0);
  String title = '';
  GlobalKey key = GlobalKey();
  double titleHeight = 0;
  List<Size> sizeList = [];
  bool isBegin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sizeList = List.generate(widget.steps.length, (_)=>Size.zero);
  }

  void toNext(){
    current++;
    if(current==widget.steps.length){
      Navigator.pop(context);
      return;
    }
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 组件渲染完成后执行的操作
      // 延迟到下一帧渲染完成后执行
      print("Widget渲染完成，延迟操作");
      offset = widget.steps[current].offset;
      size = widget.steps[current].size;
      titleHeight = sizeList[current].height;
      title = widget.steps[current].title;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            /// 先渲染
            Positioned(
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0,
                child: widgetList(),
              ),
            ),
            Positioned.fill(
              child: ClipPath(
                clipper: TransparentClipper(
                  boxOffset: offset,
                  boxSize: size
                ), // 定义透明区域
                child: Container(
                  color: const Color(0xff14232E).withOpacity(0.5), // 半透明遮罩层
                ),
              ),
            ),
            Positioned(
              top: kToolbarHeight-10,
              right: 20,
              child: skipWidget(),
            ),
            if(current>-1)
              tipsWidget(),
          ],
        ),
      ),
    );
  }

  Widget widgetList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.steps.length, (index){
        return LeguangGuideBox(
          title: widget.steps[index].title,
          offset: offset,
          onInit: (_){
            sizeList[index] = _;
            if(!isBegin){
              isBegin = true;
              toNext();
            }
          },
        );
      }),
    );
  }


  Widget tipsWidget(){

    double width = MediaQuery.sizeOf(context).width;
    double left = offset.dx;
    double? top = offset.dy+size.height+4;
    bool isBottom = top>MediaQuery.sizeOf(context).height/2;
    if(isBottom){
      top-= size.height+100+titleHeight;
    }
    var boxSize = sizeList[current];
    if(left>width-boxSize.width){
      left = width-boxSize.width;
    }
    var lineLeft = (offset.dx-(width-boxSize.width)+size.width/3);
    print('lineLeft->$lineLeft');
    if(lineLeft<0) lineLeft = 20;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      left: left,
      top: top,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isBottom?[
          LeguangGuideBox(
            title: title,
            offset: offset,
            onNext: toNext,
            current: current,
            count: widget.steps.length,
          ),
          const SizedBox(height: 5),
          lineWidget(lineLeft),
          dotWidget(lineLeft),
        ]:[
          dotWidget(lineLeft),
          const SizedBox(height: 5),
          lineWidget(lineLeft),
          LeguangGuideBox(
            title: title,
            offset: offset,
            onNext: toNext,
            current: current,
            count: widget.steps.length,
          )
        ],
      ),
    );
  }

  Widget titleWidget({
    String? tit
  }){
    return Stack(
      children: [
        LayoutBuilder(
          builder: (_,box){
            double width = MediaQuery.sizeOf(context).width;
            double minWidth = 200;
            double maxWidth = width-offset.dx-20;
            if(maxWidth<minWidth){
              maxWidth = minWidth;
            }
            return AnimatedContainer(
              // key: key,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: const Color(0xff01908A),
                borderRadius: BorderRadius.circular(10)
              ),
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minWidth: minWidth
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tit??title,style:const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  )),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                      bottom: 5
                    ),
                    child: Text('新手教程：${current+1}/${widget.steps.length}',style: TextStyle(
                      color: Colors.white.withOpacity(.6),
                      fontSize: 12
                    )),
                  )
                ],
              ),
            );
          },
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: GestureDetector(
            onTap: toNext,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white
                  )
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
              child: const Text('知道了',style: TextStyle(
                  fontSize: 12,
                  color: Colors.white
              )),
            ),
          ),
        )
      ],
    );
  }

  Widget dotWidget(double left){
    return Container(
      margin: EdgeInsets.only(
        left: left
      ),
      decoration: BoxDecoration(
        color: const Color(0xff01908A).withOpacity(.4),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        width: 13,
        height: 13,
        decoration: BoxDecoration(
          color: const Color(0xff01908A),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget lineWidget(double left){
    return Container(
      margin: EdgeInsets.only(
        left: left,
        top: 0,
        bottom: 0
      ),
      width: 16,
      height: 70,
      child: CustomPaint(
        painter: DashedLinePainter(),
      ),
    );
  }



  Widget skipWidget(){
    return InkWell(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white
          )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        child: const Text('跳过',style: TextStyle(
          color: Colors.white
        )),
      ),
    );
  }

}

class TransparentClipper extends CustomClipper<Path> {

  const TransparentClipper({
    required this.boxOffset,
    required this.boxSize
  });

  final Offset boxOffset;
  final Size boxSize;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height)); // 背景全区域
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(boxOffset.dx, boxOffset.dy, boxSize.width, boxSize.height), const Radius.circular(5)));
    path.fillType = PathFillType.evenOdd; // 排除圆形区域
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // 线条颜色
      ..strokeWidth = 1.5 // 线条宽度
      ..style = PaintingStyle.stroke;

    // 虚线的设置
    const double dashHeight = 5; // 每段虚线的高度
    const double dashSpacing = 5; // 虚线之间的间隔
    double startY = 0; // 起始位置

    while (startY < size.height) {
      // 绘制一段虚线
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      // 更新起始位置，跳过间隔
      startY += dashHeight + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}