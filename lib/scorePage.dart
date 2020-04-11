import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScorePage extends StatefulWidget {
  ScorePage({Key key, this.title, this.score,this.goodScore,this.language}) : super(key: key);
  final String title;
  var score;
  var goodScore;
  final String language;
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {

  var _backgroundColor = Colors.deepPurpleAccent;

  Map<String, String> _congratulation = {
    'en_US': 'Congratulation !!!',
    'es_ES': 'Felicitationes  !!!',
    'zh': '恭喜 '
  };

  Map<String, String> _keep = {
    'en_US': 'Keep practicing ',
    'es_ES': 'Sigue practicando ',
    'zh': '保持练习 '
  };

  Map<String, String> _got = {
    'en_US': 'You got ',
    'es_ES': 'Pronunciaste ',
    'zh': '你说了 '
  };

  Map<String, String> _correct = {
    'en_US': ' correct words ',
    'es_ES': ' palabras correctas ',
    'zh_Hant': ' 總 话 '
  };

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    String message() {
      if (widget.score > widget.goodScore) return _congratulation[widget.language];
      return _keep[widget.language];
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
                Text(
                  message(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),

              ),
             Text(
                  _got[widget.language]+ '${widget.score}' + _correct[widget.language],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
