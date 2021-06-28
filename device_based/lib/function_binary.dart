import 'package:flutter/material.dart';

class functionBinary extends StatefulWidget{
  @override
  functionBinary({
    Key key,
    @required this.text,
    @required this.state0,
  }):super(key: key);
  final List text;
  final bool state0;
  _functionBinary createState()=>new _functionBinary();
}

class _functionBinary extends State<functionBinary>{
  List _text;
  bool _state0;
  @override
  void initState(){
    super.initState();
    _text=widget.text;
    _state0=widget.state0;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_text[0]),
      ),
      body: Center(
        child: Switch(
              value: _state0,
              onChanged: (value){
                setState(() {
                  print("change to");
                  print(_state0);
                  _state0=value;
                });
                },
            )
        ),

      );
  }
}