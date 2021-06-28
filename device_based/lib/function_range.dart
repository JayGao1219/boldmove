import 'package:flutter/material.dart';

class functionRange extends StatefulWidget{
  @override
  functionRange({
    Key key,
    @required this.text,
    @required this.state0,
    @required this.states,
  }):super(key: key);
  final List text;
  final double state0;
  final List states;
  _functionRange createState()=>new _functionRange();
}

class _functionRange extends State<functionRange>{
  List _text;
  double _state0;
  List _states;
  @override
  void initState(){
    super.initState();
    _text=widget.text;
    _state0=widget.state0;
    _states=widget.states;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_text[0]),
      ),
      body: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Slider'),
            Slider(
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
              // semanticFormatterCallback: (double newValue) {
              //   return '${newValue.round()} dollars}';
              // },
            )
          ],
        )
      ),
    );
  }
}