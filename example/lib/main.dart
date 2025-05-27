import 'package:flutter/material.dart';
import 'package:leguang_guide/leguang_guide.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: const Color(0xff01908A),
        // appBarTheme: AppBarTheme(
        //   backgroundColor:
        // ),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: '引导测试'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();

  void begin(){
    LeguangGuideTool.show(
      context: context,
      guides: [
        GuideEntity(keyId: key4,title: '点击列表元素1点击列表元素1点击列表元素1点击列表元素1点击列表元素1点击列表元素1'),
        GuideEntity(keyId: key1,title: '点击元素1'),
        GuideEntity(keyId: key2,title: '点击元素2点击元素2点击元素2点击元素2点击元素2点击元素2点击元素2'),
        GuideEntity(keyId: key3,title: '点击元素3'),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff01908A),
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Container(
                  key: key1,
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  alignment: Alignment.center,
                  child: const Text('元素1'),
                ),
                Padding(
                  padding:const EdgeInsets.only(
                    left: 20
                  ),
                  child: Container(
                    key: key2,
                    width: 100,
                    height: 30,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text('元素2'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              key: key3,
              color: Colors.grey.shade200,
              height: 50,
              alignment: Alignment.center,
              child: const Text('元素3'),
            ),
            ListView.separated(
              itemCount: 30,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 10),
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_,index)=>const Divider(height: 2),
              itemBuilder: (_,index){
                return Container(
                  color: const Color(0xff01908A),
                  height: 50,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Text('列表元素$index'),
                      ),
                      Container(
                        key: index==6?key4:null,
                        color: Colors.deepOrange,
                        width: 80,
                        child: Text('右侧'),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: begin,
        tooltip: 'Increment',
        child: Text('引导'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
