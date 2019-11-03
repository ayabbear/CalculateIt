import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_expressions/math_expressions.dart';

// Colors
const clrArmadillo = Color(0xff4f4841);
const clrDune = Color(0xff3a3736);
const clrGray = Color(0xff7e7e7d);
const clrSunshade = Color(0xfffea22b);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove debug mode banner
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variables -----

  String output = '';
  String result = '';

  bool isOpen = false;
  bool isPressed = false;

  // Functions -----
  void onButtonClick(String btnValue) {
    // limit length of output
    try {
      if (output.length >= 15) {
        output = output.substring(0, 15);
      }

      // calculate expressions
      if (btnValue == 'AC') {
        output = '';
        result = '';
        isOpen = false;
        isPressed = false;
      } else if (btnValue == '( )') {
        if (isOpen) {
          output = output + ')';
          isOpen = false;
        } else {
          output = output + '(';
          isOpen = true;
        }
      } else if (btnValue == 'x') {
        output = output + '*';
      } else if (btnValue == '<<') {
        isPressed = true;
        if (isPressed && output.isEmpty) {
          // do nothing
        } else {
          output = output.substring(0, output.length - 1);
        }
      } else if (btnValue == '=') {
        if (output.substring(output.length - 1) == '%') {
          String x = '';
          double y = 0.0;

          x = output.substring(0, output.length - 1);
          y = double.parse(x) * 0.01;

          result = y.toString();
        } else {
          parseOutput(output);
        }
      } else {
        output = output + btnValue;
      }
    } catch (e) {
      result = 'error';
    }

    setState(() {
      // output = result;
    });
  }

  void parseOutput(String output) {
    try {
      String out = '';
      String x = '';
      String y = '';

      bool isOutOnce = false;
      bool isPercentage = false;

      double xy;

      // determine of percentage or regular exp
      for (int i = 0; i < output.length; i++) {
        out = output[i];
        if (out == '%') {
          isOutOnce = true;
          isPercentage = true;
        } else {
          if (isOutOnce) {
            y = y + out;
          } else {
            x = x + out;
          }
        }
      }

      // calculate if percentage or not
      if (isPercentage) {
        xy = (double.parse(y) * .01) * double.parse(x);
        result = xy.toString();
      } else if (!isPercentage) {
        Parser parser = new Parser();
        Expression exp;

        exp = parser.parse(output);
        result = exp.evaluate(EvaluationType.REAL, null).toString();

        if (result.substring(result.length - 2) == '.0') {
          result = result.substring(0, result.length - 2);
        }
      }

      // limit length of result
      if (result.length >= 10) {
        result = result.substring(0, 10) + '..';
      }
    } catch (e) {
      result = 'error';
    }
  }

  // Widgets -----
  Widget btnStyle1(String btnValue) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: FlatButton(
        color: clrGray,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
        ),
        child: Text(
          '$btnValue',
          style: TextStyle(
            color: Colors.white,
            fontSize: (30.0),
            fontWeight: (FontWeight.w900),
          ),
        ),
        onPressed: () {
          onButtonClick(btnValue);
        },
      ),
    );
  }

  Widget btnStyle2(String btnValue) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: FlatButton(
        color: clrGray,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
        ),
        child: Text(
          '$btnValue',
          style: TextStyle(
            color: Colors.white,
            fontSize: (30.0),
            fontWeight: (FontWeight.w900),
          ),
        ),
        onPressed: () {
          onButtonClick(btnValue);
        },
      ),
    );
  }

  Widget btnStyle3(String btnValue) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: FlatButton(
        color: clrSunshade,
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
        ),
        child: Text(
          '$btnValue',
          style: TextStyle(
            color: Colors.white,
            fontSize: (30.0),
            fontWeight: (FontWeight.w900),
          ),
        ),
        onPressed: () {
          onButtonClick(btnValue);
        },
      ),
    );
  }

  Widget btnStyle4(String btnValue) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: FlatButton(
        color: clrSunshade,
        padding: EdgeInsets.fromLTRB(5.0, 35.0, 5.0, 35.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
        ),
        child: Text(
          '$btnValue',
          style: TextStyle(
            color: Colors.white,
            fontSize: (35.0),
            fontWeight: (FontWeight.w900),
          ),
        ),
        onPressed: () {
          onButtonClick(btnValue);
        },
      ),
    );
  }

  // Mainline -----
  @override
  Widget build(BuildContext context) {
    // Initialize adaptive screen
    double defaultHeight = 2340;
    double defaultWidth = 1080;
    ScreenUtil.instance = ScreenUtil(height: defaultHeight, width: defaultWidth)
      ..init(context);

    // Set orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: clrDune,
      body: Container(
        height: ScreenUtil().setHeight(defaultHeight), // 100%
        width: ScreenUtil().setWidth(defaultWidth), // 100%
        child: Column(
          children: <Widget>[
            /** OUTPUT PART ----- */
            Expanded(
              flex: 3,
              child: Container(
                height: ScreenUtil().setHeight(585), // 20%
                width: ScreenUtil().setWidth(1080), // 100%
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.centerRight,
                color: clrDune,
                child: Text(
                  // '123456789',
                  '$output',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            /** CALCULATION PART ----- */
            Expanded(
              flex: 8,
              child: Container(
                height: ScreenUtil().setHeight(1755), // 75%
                width: ScreenUtil().setWidth(1080), // 100%
                padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                decoration: BoxDecoration(
                  color: clrArmadillo,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45.0),
                    topRight: Radius.circular(45.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    // results ---------------------------------------------
                    Container(
                      height: ScreenUtil().setHeight(351), // 20% of 75%
                      width: ScreenUtil().setWidth(1080), // 100%
                      child: Row(
                        children: <Widget>[
                          // equal sign ------------------------------------
                          Container(
                            width:
                                ScreenUtil().setWidth(162), // 15% of 100% row
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              '=',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          // equals to -------------------------------------
                          Container(
                            width:
                                ScreenUtil().setWidth(864), // 80% of 100% row
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              // '787878',
                              '$result',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // buttons ---------------------------------------------
                    Container(
                      height: ScreenUtil().setHeight(1333.8), // 76% of 75%
                      width: ScreenUtil().setWidth(1080), // 100%
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          // left side buttons ---------------------------
                          Container(
                            width:
                                ScreenUtil().setWidth(648), // 60% of 100% row
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('( )'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('%'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: FlatButton(
                                          color: clrGray,
                                          padding: EdgeInsets.all(15.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(15.0),
                                          ),
                                          child: Image.asset(
                                              'assets/images/del.png',
                                              width: 35.0,
                                              height: 35.0),
                                          onPressed: () {
                                            onButtonClick('<<');
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('7'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('8'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('9'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('4'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('5'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('6'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('1'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('2'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('3'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        child: btnStyle2('0'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: btnStyle1('.'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // right side buttons --------------------------
                          Container(
                            width:
                                ScreenUtil().setWidth(378), // 35% of 100% row
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 10,
                                          child: Container(
                                            child: btnStyle3('AC'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: btnStyle4('/'),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: btnStyle4('x'),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: btnStyle4('+'),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: btnStyle4('-'),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 10,
                                          child: Container(
                                            child: btnStyle3('='),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
