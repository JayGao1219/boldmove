import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'function_binary.dart';
import 'function_multi.dart';
import 'function_range.dart';

class functionList extends StatelessWidget {
  functionList({
    Key key,
    @required this.text, // 接收一个text参数
    @required this.deviceName,
  }) : super(key: key);
  final List text;
  final String deviceName;

  clickFunction(String functionName,BuildContext context){
    //三种类型，有三个跳转选项
    //看对应function那么对应哪种state，一共有三种state
    for(int i=0;i<text.length;++i)
     if(functionName==text[i]["function"]){
       String title=text[i]["device"][0]+"'s "+text[i]["function"];
       if(text[i]['state'].length==1) {
         //范围
         print(text[i]["state"]);
         List<String> range=text[i]["state"][0].split("-");
         double begin=double.parse(range[0]);
         double end=double.parse(range[1]);
         double rangeState=double.parse(text[i]["state0"]);
         rangeState=begin>rangeState?begin:rangeState;
         Navigator.push(
             context,
             MaterialPageRoute(builder: (context){
               return functionRange(text: [title], state0: rangeState, states: [begin,end]);
             })
         );
       }
       else if(text[i]["state"][0]=="ON") {
         bool binaryState=int.parse(text[i]["state0"]).isOdd;
         Navigator.push(
             context,
             MaterialPageRoute(builder: (context){
               return functionBinary( text: [title],state0:binaryState);
             })
         );
       }
       else {
         int mutiState=int.parse(text[i]["state0"]);
         String state=text[i]["state"][mutiState];
         Navigator.push(
             context,
             MaterialPageRoute(builder: (context){
               return functionMulti(text: [title],
                 state0: mutiState, curState:state,states: text[i]["state"],);
             })
         );
         //多值
       }
       break;
     }
  }

  renderListByIndex(){
    List functionName=[];
    for(int i=0;i<text.length;++i){
      functionName.add(text[i]["function"]);
    }
    functionName=functionName.toSet().toList();//去重，得到所有函数的名字

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
                  functionName[index],
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                onTap: (){
                  print(functionName[index]);
                  this.clickFunction(functionName[index],context);
                },
              ),
            ),
          );
        },
        childCount: functionName.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName),
      ),
      body: new Container(
        child: new CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            renderListByIndex()
          ],
        ),
      ),
    );
  }
}