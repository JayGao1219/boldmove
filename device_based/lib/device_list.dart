import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';

import 'function_list.dart';
import 'floating_control.dart';

class DeviceList extends StatefulWidget{
  DeviceList({Key key}):super(key: key);
  @override
  _DeviceLists createState()=>new _DeviceLists();
}

class _DeviceLists extends State<DeviceList>
    with TickerProviderStateMixin{//先实现场景1，后面再改数据结构
  TabController tabController;
  final ScrollController scrollController = new ScrollController();
  final int tabLength = 4;
  final double maxHeight = kToolbarHeight;
  final double minHeight = 30;
  final double tabIconSize = 30;

  final List tabName=["S1","S2s1","S2s2","S2s3"];
  final List studyName=['functions_study1',
    'functions_study2_scenario1',
    'functions_study2_scenario2',
    'functions_study2_scenario3'];

  List<Widget> renderTabs(double shrinkOffset) {
    double offset = (shrinkOffset > tabIconSize) ? tabIconSize : shrinkOffset;
    return List.generate(tabLength, (index) {
      return Column(
        children: <Widget>[
          Opacity(
            opacity: 1 - offset / tabIconSize,
            child: Icon(
              Icons.map,
              size: tabIconSize - offset,
            ),
          ),
          new Expanded(
            child: new Center(
              child: new Text(
                tabName[index],
              ),
            ),
          )
        ],
      );
    });
  }
  String jsonContext="";
  List devices;
  String tt;
  List curDeviceName=[[],[],[],[]];

  Future<String> getLocalFile() async {
    return await rootBundle.loadString('assets/functions_study.json');
  }

  clickDevice(int indexTab,String curDeviceName){
    //indexTab：study几场景几，
    List ccontext=json.decode(tt)[studyName[indexTab]];
    List whole=[];
    for(int i=0;i<ccontext.length;++i){
      if(ccontext[i]['device'][0]==curDeviceName){
        whole.add(ccontext[i]);
      }
    }
    //导航到新路由
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context){
        //传入参数，一个list，里面是对应的函数以及功能
        return functionList(text:whole,deviceName: curDeviceName,);
      })
    );

  }

  renderListByIndex() {
    int indexTab = tabController.index;
    //对于每个tab，找到对应的device，返回一个list，indexTab是对应的index
    if(curDeviceName[indexTab].length==0) {
      getLocalFile().then((String value) {
        tt = value;
        devices = json.decode(tt)[studyName[indexTab]];
        for (int i = 0; i < devices.length; ++i) {
          curDeviceName[indexTab].add(devices[i]["device"][0]);
        }
        curDeviceName[indexTab] = curDeviceName[indexTab].toSet().toList();
        print(curDeviceName);
      });
    }



    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Card(
            color: Colors.blueAccent,
            //z轴的高度，设置card的阴影
            elevation: 20.0,
            //设置shape，这里设置成了R角
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),),
            //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
            clipBehavior: Clip.antiAlias,
            semanticContainer: false,

            child: new Container(
              color: Colors.deepPurpleAccent,
              width: 200,
              height: 70,
              alignment: Alignment.center,
              child:GestureDetector(
                child:new Text(
                  curDeviceName[indexTab][index],
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                onTap: (){
                  print(curDeviceName[indexTab][index]);
                  this.clickDevice(indexTab,curDeviceName[indexTab][index]);
                },
              ),
            ),
          );
        },
        childCount: curDeviceName[indexTab].length,
      ),
    );
  }


  @override
  void initState() {
    tabController = new TabController(length: tabLength, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("device-based"),
      ),
      body: new Container(
        child: new CustomScrollView(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          slivers: <Widget>[
            ///动态放大缩小的tab控件
            SliverPersistentHeader(
              pinned: true,

              /// SliverPersistentHeaderDelegate 的实现
              delegate: GSYSliverHeaderDelegate(
                  maxHeight: maxHeight,
                  minHeight: minHeight,
                  changeSize: true,
                  vSync: this,
                  snapConfig: FloatingHeaderSnapConfiguration(
                    curve: Curves.bounceInOut,
                    duration: const Duration(milliseconds: 10),
                  ),
                  builder: (BuildContext context, double shrinkOffset,
                      bool overlapsContent) {
                    return Container(
                      height: maxHeight,
                      color: Colors.blue,
                      child: TabBar(
                        indicatorColor: Colors.cyanAccent,
                        unselectedLabelColor: Colors.white.withAlpha(100),
                        labelColor: Colors.cyanAccent,
                        controller: tabController,
                        tabs: renderTabs(shrinkOffset),
                        onTap: (index) {
                          setState(() {});
                          scrollController.animateTo(0,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.fastOutSlowIn);
                        },
                      ),
                    );
                  }),
            ),
            renderListByIndex(),
            //new FloatingControl(),
          ],
        ),
      ),
    );
  }
}

///动态头部处理
class GSYSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  GSYSliverHeaderDelegate(
      {@required this.minHeight,
        @required this.maxHeight,
        @required this.snapConfig,
        this.child,
        this.builder,
        this.vSync,
        this.changeSize = false});

  final double minHeight;
  final double maxHeight;
  final Widget child;
  final Builder builder;
  final TickerProvider vSync;
  final bool changeSize;
  final FloatingHeaderSnapConfiguration snapConfig;
  AnimationController animationController;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  TickerProvider get vsync => vSync;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (builder != null) {
      return builder(context, shrinkOffset, overlapsContent);
    }
    return child;
  }

  @override
  bool shouldRebuild(GSYSliverHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => snapConfig;
}

typedef Widget Builder(
    BuildContext context, double shrinkOffset, bool overlapsContent);


