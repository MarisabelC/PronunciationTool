import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'category.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key, this.title,this.category}) : super(key: key);
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
  final _entries = ['Languages', 'Game Time'];
  final _icons = [Icons.language, Icons.timer];
  Map<int, String> _languages = {0: 'en_US', 1: 'es_ES',2:'zh'};

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
    final _height =
        MediaQuery.of(context).size.height / (_entries.length * 2);
    final _width = MediaQuery.of(context).size.width;

    BoxDecoration boxDecoration() {
      return BoxDecoration(
        color: Colors.blue[200],
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      );
    }

    setSelectedLanguage(int val) {
      setState(() {
        widget._languageIndex = val;
        widget.language = _languages[widget._languageIndex];
      });
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
              top: MediaQuery.of(context).size.height * .10),
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
                          child: ListTile(
                            leading: Icon(_icons[0]),
                            title: Text(
                              _entries[0],
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.5,
                                fontSize: 30,
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
                                      child:
                                          radioButtonLanguage(_languageOptions, 0)),
                                  Expanded(
                                      child:
                                          radioButtonLanguage(_languageOptions, 1)),
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
                    child: ListTile(
                      leading: Icon(_icons[1]),
                      title: Text(
                        _entries[1],
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.5,
                          fontSize: 30,
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
                            fontSize: 30,
                          ),
                        ),
                        leading: FloatingActionButton(
                            onPressed: _incrementTimer, child: Icon(Icons.add),backgroundColor: Colors.blueGrey[200],),
                      ),
                    ),
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
