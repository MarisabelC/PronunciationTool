import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key, this.title, this.language}) : super(key: key);
  final String title;
  final String language;
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  var _backgroundColor = Colors.deepPurpleAccent;

  var _rules = {
    'en_US': [
      'Play Mode',
      'A player pronounces the word. If he/she pronounces the word correctly another word ',
      'If a player does not know how to pronounce the word, she/he can click the right arrow to get another word',
      'A player has a limited time to pronounce words correctly',
      'Points: 1 point for each word that is pronouced correctly, -1 point for each word that is passed',
      ' ',
      'Practice Mode',
      'use to listen a word',
      'use to change the rate of the speaker voice',
      'use to change the pitch of the speaker voice',
      'use to get the next word',
      'use to get previous word',
      'use to pronounce a word',
      'If an user pronounces the word correctly another word appears on the scream',
    ],
    'es_ES': [
      'Modo play',
      'Si el jugador pronuncia la palabra correctamente, otra palabra aparecerá en la patalla',
      'Si el jugador no sabe como pronunciar la palabra, el/ella puede presionar la flecha  y otra palabra aparecera en la pantalla',
      'El jugador tiene un limite de tiempo para pronunciar las palabras',
      'Puntos: 1 punto por cada palabra pronunciada correctamente, -1 punto por cada palabra que el jugador pase',
      ' ',
      'Modo Practice',
      'usar para escuchar la palabra',
      'usar para cambiar la velocidad de la voz',
      'usar para cambiar el tono de la voz',
      'usar para pasar la palabra',
      'usar para ver la palabra anterior',
      'si el usuario pronuncia correctamente la palabra, la próxima palabra aparecera en la pantalla'
    ],
    'zh_Hans_CN': [
      'Play Mode',
      'A player pronounces the word. If he/she pronounces the word correctly another word ',
      'If a player does not know how to pronounce the word, she/he can click the right arrow to get another word',
      'A player has a limited time to pronounce words correctly',
      'Points: 1 point for each word that is pronouced correctly, -1 point for each word that is passed',
      ' ',
      'Practice Mode',
      'use to listen a word',
      'use to change the rate of the speaker voice',
      'use to change the pitch of the speaker voice',
      'use to get the next word',
      'use to get previous word',
      'use to pronounce a word',
      'If an user pronounces the word correctly another word appears on the scream',
    ],
  };

  Map<int, Icon> icons = {
    7: Icon(Icons.volume_up),
    8: Icon(Icons.offline_bolt),
    9: Icon(Icons.equalizer),
    10: Icon(Icons.arrow_right),
    11: Icon(Icons.arrow_left),
    12: Icon(Icons.mic)
  };

  FontWeight font(String sentence) {
    if (sentence.contains("Mode") || sentence.contains("Modo")) {
      return FontWeight.bold;
    }
    return FontWeight.normal;
  }

  bool _isUse(String sentence) {
    print(sentence);
    return sentence.contains('use to') || sentence.contains('usar');
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height / 10;
    final List<double> _height = [
      screenHeight,
      2.5 * screenHeight,
      screenHeight,
      screenHeight,
      1.5 * screenHeight,
      2 * screenHeight
    ];

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
          child: ListView.builder(
              itemCount: _rules[widget.language].length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: Row(children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: _isUse(_rules[widget.language][index])
                          ? IconButton(
                              icon: icons[index],
                            )
                          : Text("")),
                  Expanded(
                      flex: 9,
//                    height: _height[index],

//                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Text('${_rules[widget.language][index]}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: font(_rules[widget.language][index]),
                          )))
                ]));
              })),
    );
  }
}
