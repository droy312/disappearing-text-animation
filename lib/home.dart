import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  TextEditingController _controller;
  bool _isBtnEnabled;
  String _text = '';
  List<String> _textCharsList = [];

  final OutlineInputBorder _textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: Colors.redAccent,
      width: 1.5,
    ),
  );

  void _isBtnEnabledFunc(String text) {
    setState(() {
      _isBtnEnabled = (text != null && text.trim() != '') ? true : false;
    });
  }

  double getOpacity(int index, double value) {
    if ((_text.length - index) * value <= 1) {
      return (_text.length - index) * value;
    } else {
      return 1;
    }
  }

  void _startAnimation() {
    setState(() {
      _text = _controller.text;
    });

    _textCharsList = [];
    for (int i = 0; i < _text.length; i++) {
      setState(() {
        _textCharsList.add(_text[i]);
      });
    }
    setState(() {});

    _animationController.forward().then((value) {
      _animationController.reverse().then((value) {
        setState(() {
          _text = '';
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _isBtnEnabled = false;
    _controller = TextEditingController();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              // *** Top part ***
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // *** Text Field ***
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                          border: _textFieldBorder,
                          focusedBorder: _textFieldBorder,
                          hintText: 'Enter text...',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (text) {
                          _isBtnEnabledFunc(text);
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    // *** Enter Button ***
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        onPressed: _isBtnEnabled ? _startAnimation : null,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.redAccent,
                        disabledColor: Colors.grey[500],
                        child: Text(
                          'Enter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // *** Text Animation ***
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _textCharsList.asMap().entries.map((e) {
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final double value = _animationController.value;
                          return Opacity(
                            opacity: getOpacity(e.key, value),
                            child: child,
                          );
                        },
                        child: Text(
                          (_text != null && _text.trim() != '')
                              ? _text[e.key]
                              : '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
