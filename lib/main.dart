import 'dart:io';
import 'category.dart';
import 'dart:async';
import 'categoryPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settingPage.dart';
import 'helpPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pronunciation Tool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pronunciation Tool'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CategoryPage _categoryPage;
  SettingPage _settingPage;
  Category _category;
  bool _loading=true;
  double _progressValue=0.0;

  Map<String, String> _play = {
    'en_US': 'Play',
    'es_ES': 'Jugar',
    'zh': '玩'
  };

  Map<String, String> _practice = {
    'en_US': 'Practice',
    'es_ES': 'Practicar',
    'zh': '实践'
  };

  @override
  void initState() {
    super.initState();

    _categoryPage = CategoryPage(
      title: 'Categories',
      isPractice: false,
    );
    _category = Category();
    _category.init();
    _updateProgress();

    _settingPage = SettingPage(
      title: 'Setting',category: _category,
    );
  }


  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => _settingPage));
        break;
      case 1:
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => HelpPage(
                title: 'How to use',language: _settingPage.language,
              )),
        );
        break;
    }
  }

  void navigateToCategoryPage(){
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => _categoryPage),
    );
  }

  void _updateProgress() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 0.2;
        // we "finish" downloading here
        if (_progressValue.toStringAsFixed(1) == '1.0') {
          t.cancel();
          _loading=false;
          return;
        }
      });
    });
  }


  void setCategory(bool isPractice){
    _category.language=_settingPage.language;
    _categoryPage.isPractice = isPractice;
    _categoryPage.timer=_settingPage.timer;
    _categoryPage.language=_settingPage.language;
    _categoryPage.category=_category;
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Setting',
      style: optionStyle,
    ),
    Text(
      'Index 1: Help',
      style: optionStyle,
    ),
  ];

  Future<void> _exitApp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quit'),
          backgroundColor: Colors.blueGrey[400],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you really want to quit?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes', style: TextStyle(color: Colors.white)),
              color: Colors.green,
              onPressed: () {
                exit(0);
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

  @override
  Widget build(BuildContext context) {
    double fontSize= MediaQuery.of(context).size.height/30 ;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                _exitApp();
              },
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/gradient.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Pronunciation Tool',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.indigo[500],
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                    fontSize: 50,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Visibility(
                visible: !_loading,
                child: Row(
                  children: <Widget>[
                    Expanded(flex: 1, child: Text('')),
                    Expanded(
                      flex: 3,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.deepPurpleAccent,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          setCategory(false);
                          navigateToCategoryPage();
                        },
                        child: Text(
                          'Play',
                          style: TextStyle(fontSize:fontSize),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Text('')),
                    Expanded(
                      flex: 3,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.deepPurpleAccent,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          setCategory(true);
                          navigateToCategoryPage();
                        },
                        child: Text(
                          'Practice',
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Text('')),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Visibility(
              visible: _loading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('loading...'),
                  Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.1,right: MediaQuery.of(context).size.width*.1),
                      child: LinearProgressIndicator(value: _progressValue,)
                  ),
                  Text('${(_progressValue * 100).round()}%'),
                ],
              ),
            )
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !_loading,
        child: BottomNavigationBar(
          backgroundColor: Colors.deepPurpleAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.settings,color:Colors.white,),
              title: Text('Setting',style: TextStyle(color: Colors.white,)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help,color: Colors.white,),
              title: Text('How to use',style: TextStyle(color: Colors.white,),),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
