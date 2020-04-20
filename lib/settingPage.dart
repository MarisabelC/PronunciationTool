import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SettingPage extends StatefulWidget {
  SettingPage({Key key, this.title, this.category}) : super(key: key);
  final String title;
  var language = 'en_US';
  var teams = 2;
  int timer = 60;
  var _languageIndex = 0;
  Category category;

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _entries = {
    0: ['Languages', 'Game Time', 'Reset - Need Improvement List'],
    1: ['Idiomas', 'Tiempo', 'Reanudar - Lista que Necesitas Practicar '],
    2: ['语言', '时间', '重新开始 - 所有']
  };
  final _all = {
    'English': ['all'],
    'Español': ['todos'],
    '中文': ['所有']
  };
  final _icons = [Icons.language, Icons.timer, Icons.storage];
  Map<int, String> _languageMap = {0: 'en_US', 1: 'es_ES', 2: 'zh'};
  List<String> _languageList = [' ', 'English', 'Español', '中文'];
  var _dropDownLanguage = ' ';
  var _dropDownCategory = 'all';
  var _previewdropDownLanguage = ' ';

  final _languageOptions = [
    TeamValue(0, "English"),
    TeamValue(1, "Español "),
    TeamValue(2, "中文"),
  ];
  var _backgroundColor = Colors.deepPurpleAccent;

  void _incrementTimer() {
    setState(() {
      if (widget.timer < 120)
        widget.timer += 30;
      else
        widget.timer = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height /
        (_entries[widget._languageIndex].length);
    final _width = MediaQuery.of(context).size.width;
    double fontSize = MediaQuery.of(context).size.height / 30;
    List<String> categoryList = ['all'] + widget.category.categories();

    BoxDecoration boxDecoration() {
      return BoxDecoration(
        color: Colors.blue[200],
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      );
    }

    DropdownButton _dropdownButtonLanguage() {
      return DropdownButton<String>(
        value: _dropDownLanguage,
        icon: Icon(Icons.expand_more),
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.black54,
        ),
        onChanged: (String newValue) {
          setState(() {
            _dropDownLanguage = newValue;
            print(_all[newValue]);
          });
        },
        items: _languageList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }

    Widget _dropdownButtonCategory() {
      if (_dropDownLanguage != ' ') {
        setState(() {
          categoryList = _all[_dropDownLanguage] + widget.category.categories();
          if (_dropDownLanguage != _previewdropDownLanguage)
            _dropDownCategory = _all[_dropDownLanguage][0];
          _previewdropDownLanguage = _dropDownLanguage;
        });
        return DropdownButton<String>(
          value: _dropDownCategory,
          icon: Icon(Icons.expand_more),
          iconSize: 24,
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.black54,
          ),
          onChanged: (String newValue) {
            setState(() {
              _dropDownCategory = newValue;
            });
          },
          items: categoryList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      } else
        return Container();
    }

    setSelectedLanguage(int val) {
      setState(() {
        widget._languageIndex = val;
        widget.language = _languageMap[widget._languageIndex];
      });
    }

    Future<void> removeFile() async {
      SharedPreferences.getInstance()
          .then((SharedPreferences sharedPreferences) {
        if (_dropDownCategory == _all[_dropDownLanguage][0])
          for (String category in widget.category.categories()) {
            sharedPreferences.remove(_languageMap[_languageList.indexOf(_dropDownLanguage)-1] + '-' + category);
          }
        else
          sharedPreferences.remove(_languageMap[_languageList.indexOf(_dropDownLanguage)-1] + '-' + _dropDownCategory);
      });
    }

    Future<void> restart() async {
      var message = 'Do you really want to reset " ' +
          _dropDownCategory +
          ' " list  in ' +
          _dropDownLanguage +
          ' category to default value? ';
//      switch (widget._languageIndex) {
//        case 0:
//          message = 'Do you really want to restart the " ' +
//              _dropDownCategory +
//              ' " list  in ' +
//              _dropDownLanguage +
//              ' category? ';
//          break;
//        case 1:
//          message = 'Desea agregar todas las palabras a la lista " ' +_dropDownCategory + ' " en la categoria ' + _dropDownLanguage;
//      }
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Restart'),
            backgroundColor: Colors.brown[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.white)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes', style: TextStyle(color: Colors.white)),
                color: Colors.green,
                onPressed: () {
                  removeFile();
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text('No', style: TextStyle(color: Colors.white)),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    }

    RadioListTile radioButtonLanguage(List list, int index) {
      return RadioListTile(
        value: list[index]._key,
        groupValue: widget._languageIndex,
        title: Text(list[index]._value),
        onChanged: (val) {
          setSelectedLanguage(val);
//          widget.category.spanishParser();
        },
        activeColor: Colors.black,
        selected: true,
      );
    }

    String getTime() {
      return (widget.timer).toString();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/gradient.jpg'), fit: BoxFit.cover),
        ),
        child: ListView(
          padding: EdgeInsets.only(
              left: _width * .05,
              right: _width * .05,
              top: MediaQuery.of(context).size.height * .10,
              bottom: MediaQuery.of(context).size.height * .10),
          children: <Widget>[
            Container(
              height: _height,
              decoration: boxDecoration(),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: ListTile(
                              leading: Icon(_icons[0]),
                              title: Text(
                                _entries[widget._languageIndex][0],
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.5,
                                  fontSize: fontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: radioButtonLanguage(
                                          _languageOptions, 0)),
                                  Expanded(
                                      child: radioButtonLanguage(
                                          _languageOptions, 1)),
                                ],
                              ),
                              Expanded(
                                  child:
                                      radioButtonLanguage(_languageOptions, 2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _height,
              decoration: boxDecoration(),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Icon(_icons[1]),
                        title: Text(
                          _entries[widget._languageIndex][1],
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: _width * .2),
                      child: ListTile(
                        title: Text(
                          getTime() + "''",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                            fontSize: fontSize,
                          ),
                        ),
                        leading: Container(
                          height: 30,
                          child: FloatingActionButton(
                            onPressed: _incrementTimer,
                            child: Icon(
                              Icons.add,
                              size: 20,
                            ),
                            backgroundColor: Colors.blueGrey[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _height * 1.5,
              decoration: boxDecoration(),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Icon(_icons[2]),
                        title: Text(
                          _entries[widget._languageIndex][2],
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: _width * .2),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                _dropdownButtonLanguage(),
                                _dropdownButtonCategory()
                              ],
                            ),
                            SizedBox(height: _height / 9),
                            Visibility(
                              visible: _dropDownLanguage != ' ',
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)),
                                  textColor: Colors.red,
                                  disabledColor: Colors.grey,
                                  color: Colors.grey,
                                  disabledTextColor: Colors.black,
                                  onPressed: () => restart(),
                                  child: Text(
                                    'Restart',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamValue {
  final int _key;
  final String _value;
  TeamValue(this._key, this._value);
}
