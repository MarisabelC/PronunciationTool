import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'wordPage.dart';
import 'category.dart';
import 'displayPage.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage(
      {Key key,
      this.timer,
      this.language,
      this.title,
      this.isPractice,
      this.category})
      : super(key: key);
  final String title;
  bool isPractice;
  String language;
  Category category;
  int timer;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Map<String, String> _random = {
    'en_US': 'random a-z',
    'es_ES': 'aleatorio a-z',
    'zh': '随意 a-z'
  };

  var entries=[];
  var _backgroundColor = Colors.deepPurpleAccent;
  int _selectedIndex = 0;
  var str;

  @override
  void initState() {
    super.initState();
    if (!widget.isPractice)
      entries.add(_random[widget.language]);
    entries.addAll( widget.category.categories());
  }

  void navigateToDisplay(BuildContext context) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => DisplayPage(
                  category: widget.category,
                  title: '',
                  language: widget.language,
                  startTime: widget.timer,
                  isPractice: widget.isPractice,
                )));
  }

  void navigateToWord(BuildContext context) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => WordPage(
                  category: widget.category,
                  language: widget.language,
                  timer: widget.timer,
                  isPractice: widget.isPractice,
                )));
  }

  @override
  Widget build(BuildContext context) {
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
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius:
                BorderRadius.all(Radius.circular(50)),
              ),
              height: MediaQuery.of(context).size.height / 15,

              child: FlatButton(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${entries[index]}',
                          style: TextStyle(fontSize: 25.0),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  widget.category.letter = entries[index];
                  widget.isPractice
                      ? navigateToWord(context)
                      : navigateToDisplay(context);
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}
