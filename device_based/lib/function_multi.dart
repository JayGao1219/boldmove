import 'package:flutter/material.dart';

class functionMulti extends StatefulWidget{
  @override
  functionMulti({
    Key key,
    @required this.text,
    @required this.state0,
    @required this.states,
    @required this.curState,
  }):super(key: key);
  final List text;
  final int state0;
  final List states;
  final String curState;
  _functionMulti createState()=>new _functionMulti();
}

class _functionMulti extends State<functionMulti>{
  List _text;
  int _state0;
  List _states;
  String _curState;
  @override
  void initState(){
    super.initState();
    _text=widget.text;
    _state0=widget.state0;
    _states=widget.states;
    _curState=widget.curState;
  }
  
  void _pressForward(){
    setState(() {
      _state0++;
      _state0%=widget.states.length;
      _curState=widget.states[_state0];
      print(_curState);
    });
  }
  
  void _pressBackward(){
    setState(() {
      _state0--;
      _state0%=_states.length;
      _curState=_states[_state0];
      print(_curState);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_text[0]),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              _curState,
              style: Theme.of(context).textTheme.headline4,
            ),
            new Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: Icon(Icons.fast_rewind), onPressed: _pressBackward),
                  IconButton(icon: Icon(Icons.fast_forward), onPressed: _pressForward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}