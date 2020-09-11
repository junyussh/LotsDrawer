import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import "settingUI.dart";
import 'RandomCore.dart';
import 'globals.dart' as globals;

void main() => runApp(AppMainUI());

class AppMainUI extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draw lots App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        Navigator.defaultRouteName: (context) =>
            HomePage(title: 'Draw lots App'),
        //SettingUI.routeName: (context) => SettingUI(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _randomNum = 0;
  var randomNumList = <int>[];
  String roundStr;
  String allStr;
  TextEditingController _start = TextEditingController();
  TextEditingController _end = TextEditingController();

  RandomCore rdc = new RandomCore(1, 10);
  Random random = new Random();

  bool _checkNum() {
    if (_start.text == "" ||
        int.parse(_start.text) < 0 ||
        int.parse(_start.text) > 10000) {
      Fluttertoast.showToast(
          msg: "valid number is between 0 to 10000",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    if (_end.text == "" ||
        int.parse(_end.text) < 0 ||
        int.parse(_end.text) > 10000) {
      Fluttertoast.showToast(
          msg: "valid number is between 0 to 10000",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    if (int.parse(_end.text) < int.parse(_start.text)) {
      String tmp = _end.text;
      _end.text = _start.text;
      _start.text = tmp;
    }

    if (!rdc.check()) {
      Fluttertoast.showToast(
          msg: "All numbers have been selected!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    return true;
  }

  void _resetApp() {
    randomNumList.clear();
    _start.text = "";
    _end.text = "";
    _getNumberList(true);
    rdc.reset();
    setState(() {
      roundStr = "";
    });
    Fluttertoast.showToast(
        msg: "App has been reset.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String _getNumberList(bool isclean) {
    if (isclean) {
      return "";
    }
    return rdc.getNumberString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black87,
            ),
            tooltip: "設定",
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new SettingUI()),
              );
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.75),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      )
                    ]),
                height: 100,
                child: Center(
                  child: Text(
                    _randomNum.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Container(
                    height: 130,
                    // width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Start",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: _start,
                                onChanged: (tmp) {
                                  randomNumList.clear();
                                  rdc = new RandomCore(int.parse(_start.text),
                                      int.parse(_end.text));
                                },
                                decoration: InputDecoration(
                                  hintText: "Start",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.grey[700].withOpacity(0.5),
                                        width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.grey[850].withOpacity(0.75),
                                        width: 1.5),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.trending_up,
                            color: Colors.black45,
                            size: 30,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                onChanged: (tmp) {
                                  rdc = new RandomCore(int.parse(_start.text),
                                      int.parse(_end.text));
                                  randomNumList.clear();
                                },
                                controller: _end,
                                decoration: InputDecoration(
                                  hintText: "End",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.grey[700].withOpacity(0.5),
                                        width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.grey[850].withOpacity(0.75),
                                        width: 1.5),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "End",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.grey[400].withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50,
                    child: RaisedButton.icon(
                      label: Text("Generate Number"),
                      icon: Icon(Icons.shuffle),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      color: Colors.grey[850],
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      onPressed: () {
                        if (_checkNum()) {
                          roundStr = rdc.getRoundString();
                          setState(() {
                            _randomNum = int.tryParse(roundStr);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              flex: 3,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _resetApp();
        },
        tooltip: 'Random',
        child: Icon(Icons.autorenew),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

void debugDumpRenderTree() {
  debugPrint(RendererBinding.instance?.renderView?.toStringDeep() ??
      'Render tree unavailable.');
}
