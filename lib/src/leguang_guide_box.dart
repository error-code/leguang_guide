import 'package:flutter/material.dart';

class LeguangGuideBox extends StatefulWidget {
  const LeguangGuideBox({
    super.key,
    this.title,
    required this.offset,
    this.current = 0,
    this.count = 0,
    this.onNext,
    this.onInit
  });
  final String? title;
  final Offset offset;
  final int count;
  final int current;
  final VoidCallback? onNext;
  final ValueChanged<Size>? onInit;

  @override
  State<LeguangGuideBox> createState() => _LeguangGuideBoxState();
}

class _LeguangGuideBoxState extends State<LeguangGuideBox> {

  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
      final size = box.size;
      final position = box.localToGlobal(Offset.zero);
      print("尺寸: $size");
      widget.onInit?.call(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (_,box){
            double width = MediaQuery.sizeOf(context).width;
            double minWidth = 200;
            double maxWidth = width*.8;
            // if(maxWidth<minWidth){
            //   maxWidth = minWidth;
            // }
            return AnimatedContainer(
              key: _key,
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
                  Text(widget.title??'未命名',style:const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  )),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                      bottom: 5
                    ),
                    child: Text('新手教程：${widget.current+1}/${widget.count}',style: TextStyle(
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
            onTap: widget.onNext,
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
}
