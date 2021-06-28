import 'dart:convert';
import 'dart:async';
import 'dart:ffi';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';

import 'package:gesture_base/FlutterPainter.dart';

class DeviceList extends StatefulWidget{
  DeviceList({Key key}):super(key: key);
  @override
  _DeviceLists createState()=>new _DeviceLists();
}

class _DeviceLists extends State<DeviceList>{

  final List tabName=["S1","S2s1","S2s2","S2s3"];
  final List studyName=['functions_study1',
    'functions_study2_scenario1',
    'functions_study2_scenario2',
    'functions_study2_scenario3'];
  int cur_scenario=0;


  String jsonContext="";
  List devices;
  String wholeInfo="";
  List curDeviceName=[[],[],[],[]];

  StreamController<double> _streamController = StreamController();
  Timer _timer;
  double totalTimeNumber = 6000;
  double currentTimeNumber = 6000;

  List op_text=["⛔️","⏹","⏪","⏩","📶"];
  String _op='No Gesture';
  int cur_op=0;//0-没有动作，1-单击，2-左滑，3-右滑，4-双指按压
  double direction=0.0;
  bool isSlider=false;
  bool _isShow=false;
  List op_names=['null','单击','左滑','右滑','双击'];
  double _state0=0.0;
  List _states=[0.0,100.0];

  // ///加入动画，目前看来不是必须
  // AnimationController controller;
  // Animation animation;
  List <PieData> pieDatas=[];
  List <double> centers=[0.0,0.0];

  Future<String> getLocalFile() async {
    return await rootBundle.loadString('assets/functions_study.json');
  }

  @override
  void initState() {
    super.initState();
    getLocalFile().then((String value){
      wholeInfo=value;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    ///关闭
    _streamController.close();
    _timer.cancel();
  }

  void startTimer() {
    ///间隔100毫秒执行时间
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      ///间隔100毫秒执行一次 每次减100
      currentTimeNumber -= 100;

      ///如果计完成取消定时
      if (currentTimeNumber <= 0) {
        _timer.cancel();
        currentTimeNumber = 0;
      }

      ///流数据更新
      _streamController.add(currentTimeNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("gesture-based"),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              FlatButton(
                color: Colors.blue,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text(tabName[0]),
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {cur_scenario=0;},
              ),

              FlatButton(
                color: Colors.blue,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text(tabName[1]),
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {cur_scenario=1;},
              ),

              FlatButton(
                color: Colors.blue,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text(tabName[2]),
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {cur_scenario=2;},
              ),

              FlatButton(
                color: Colors.blue,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text(tabName[2]),
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {cur_scenario=3;},
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: buildStreamBuilder(),
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                child: Center(
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.blueGrey,
                      width: 300.0,
                      height: 300.0,
                      child: Text(_op),
                    ),
                    onTapDown: (details){
                      print('点击');
                      print(details.globalPosition);
                      updateText(1);
                    },
                    onDoubleTapDown: (details){
                      print('双击');
                    },
                    onLongPress: (){
                      print("长按");
                    },
                    onPanStart: (details){
                      print('开始滑动');
                    },
                    onPanUpdate: (details){
                      print("滑动更新");
                      print(details.globalPosition);
                      print(details.localPosition);
                    },
                    onPanEnd: (details){
                      print("滑动结束");

                    },
                    onDoubleTap: (){
                      updateText(4);
                      isSlider=true;
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                      direction+=details.delta.dx;
                      print('左右滑动');
                      print(details.globalPosition);
                      print(details.localPosition);
                    },
                    onHorizontalDragEnd: (details){
                      print("左右滑动结束");
                      if(direction>0.0)
                        updateText(3);
                      else
                        updateText(2);
                      direction=0.0;
                    },
                  ),

                ),
              ),

              /*
              CustomPaint(
                painter: FlutterPainter(
                  pieData: pieDatas,center: centers
                ),
                child: GestureDetector(
                  onTap: (){
                    updateText(1);
                  },
                  onDoubleTap: (){
                    updateText(4);
                    isSlider=true;
                  },
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    direction+=details.delta.dx;
                  },
                  onHorizontalDragEnd: (details){
                    if(direction>0.0)
                      updateText(3);
                    else
                      updateText(2);
                    direction=0.0;
                  },
                ),
              )

               */
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                child: Slider(
                  value: _state0,
                  onChanged: (data){
                    print('change:$data');
                    setState(() {
                      _state0 = data;
                    });
                  },
                  onChangeStart: (data){
                    print('start:$data');
                  },
                  onChangeEnd: (data){
                    print('end:$data');
                  },
                  min: _states[0],
                  max: _states[1],
                  divisions: (_states[1]-_states[0]).toInt(),
                  label: '$_state0',
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                ),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _isShow,
              ),
            ],
          )
        ],
      ),
    );
  }

  void updateText(int op_type){
    //0-没有动作，1-单击，2-左滑，3-右滑，4-双指按压
    setState(() {
      cur_op=op_type;
      _op=op_names[op_type];
      if(op_type==4)
        _isShow=true;
      else
        _isShow=false;
    });
    //开始计时器
    currentTimeNumber=totalTimeNumber;
    if(!_timer.isActive){
      startTimer();
    }
  }

  StreamBuilder<double> buildStreamBuilder(){
    return StreamBuilder<double>(
      stream: _streamController.stream,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Text(
              op_text[cur_op],
              style: TextStyle(fontSize: 22, color: Colors.blue),
            ),
            CircularProgressIndicator(
              value: 1.0 - snapshot.data / totalTimeNumber,)
          ],
        );
      },
    );
  }
}

