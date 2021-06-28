import 'package:flutter/material.dart';
import 'device_list.dart';


void main() {
  runApp(
    new MaterialApp(
      title: 'Gesture-based',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new DeviceList(),
    ),
  );
}
