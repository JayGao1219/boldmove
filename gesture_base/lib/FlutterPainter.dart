import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'dart:math';

import 'base_pie_entity.dart';

class FlutterPainter extends CustomPainter {
  final List<PieData> pieData;
  final List<double> center;

  FlutterPainter({this.pieData,this.center});

  double radius;
  double line1;
  double line2;

  ///初始化画笔
  var lineP = Paint()
    ..strokeWidth = 5.0
    ..strokeCap = StrokeCap.round;

  TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  @override
  void paint(Canvas canvas, Size size){
    if (size.width > size.height)
      radius = size.height / 3;
    else
      radius = size.width / 3;
    line1 = radius / 3;
    line2 = radius / 2;

    if(pieData.length==0) return;
    int lens=pieData.length;

    canvas.translate(center[0], center[1]);
    ///先绘制全角的，再转加上1/2，再加上1/4

    Rect rect=Rect.fromLTRB(-radius, -radius, radius, radius);
    double currentAngle=0.0;
    double increment=2*pi/lens;

    for(int i=0;i<lens;++i){
      var entity=pieData[i];
      Color cc=RandomColor().randomColor();
      lineP..color=cc;
      canvas.drawArc(rect, currentAngle, increment, true, lineP);
      _drawLineAndText(canvas,currentAngle,increment,radius,entity.getTitle(),cc);
      currentAngle+=increment;
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _drawLineAndText(Canvas canvas,double currentAngle,double angle,double r,String name,Color color){
    var startX = r * (cos((currentAngle + (angle / 2))));
    var startY = r * (sin((currentAngle + (angle / 2))));

    var stopX = (r + line1) * (cos((currentAngle + (angle / 2))));
    var stopY = (r + line1) * (sin((currentAngle + (angle / 2))));

    // 2、计算坐标在左边还是在右边，并计算横线结束坐标
    var endX;
    if (stopX - startX > 0) {
      endX = stopX + line2;
    } else {
      endX = stopX - line2;
    }

    // 3、绘制斜线和横线
    canvas.drawLine(Offset(startX, startY), Offset(stopX, stopY), lineP);
    canvas.drawLine(Offset(stopX, stopY), Offset(endX, stopY), lineP);

    // 4、绘制文字
    // 绘制下方名称
    // 上下间距偏移量
    var offset = 4;
    // 1、测量文字
    var tp = _newVerticalAxisTextPainter(name, color);
    tp.layout();
    var w = tp.width;
    // 2、计算文字坐标
    var textStartX;
    if (stopX - startX > 0) {
      if (w > line2) {
        textStartX = (stopX + offset);
      } else {
        textStartX = (stopX + (line2 - w) / 2);
      }
    } else {
      if (w > line2) {
        textStartX = (stopX - offset - w);
      } else {
        textStartX = (stopX - (line2 - w) / 2 - w);
      }
    }
    tp.paint(canvas, Offset(textStartX, stopY + offset));

  }

  TextPainter _newVerticalAxisTextPainter(String text, Color color) {
    return _textPainter
      ..text = TextSpan(
        text: text,
        style: new TextStyle(
          color: color,
          fontSize: 12.0,
        ),
      );
  }
}

class PieData extends BasePieEntity {
  final String title;
  //final double data;
  //final Color color;

  PieData(this.title);

  // @override
  // Color getColor() {
  //   return color;
  // }

  // @override
  // double getData() {
  //   return data;
  // }

  @override
  String getTitle() {
    return title;
  }
}

