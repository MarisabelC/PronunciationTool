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
      'After pressing the start button, player will hear a beep sound that means that the device is listening. ',' ',
      "After a player stops to talk, he/she  will hear another beep sound that means that the device recieves the player's voice."
      "Then the player will hear again the first beep sound follows by the second beep sound, if the device recieves the player's voice",''
      'A player pronounces the word. If he/she pronounces the word correctly another word appears','',
      'If a player does not know how to pronounce the word, she/he can click the right arrow to get another word','',
      'A player has a limited time to pronounce words correctly','',
      'Points: 1 point for each word that is pronouced correctly, -1 point for each word that is passed',
      ' ',
      'Practice Mode',
      'There are 2 difference lists of word:',
      '- "All" list is the list contains all words which begin with the chosen letter.',
      '- "Need improvement" list contains the words, which begin with the chosen letter, the user needs to practice.','',
      'use to listen a word',
      'use to change the rate of the speaker voice',
      'use to change the pitch of the speaker voice',
      'use to get the next word',
      'use to get previous word',
      'use to check if an user is pronounced a word correctly',

    ],
    'es_ES': [
      'Modo play',
      'Despues de apretar el "empezar" boton, el jugador escuchara un beep que significa que el dispositivo esta escuchando','',
      'Despues de que el jugador termine de hablar, el jugador escuchara otro beep que significa que el dispositivo recibio la pronunciacion'
      'seguido de otro beep que significa que el dispositivo esta escuchando. Si el dispositivo no entiende la pronunciacion el segundo beep no se escuchara','',
      'Si el jugador pronuncia la palabra correctamente, otra palabra aparecerá en la patalla','',
      'Si el jugador no sabe como pronunciar la palabra, el/ella puede presionar la flecha  y otra palabra aparecera en la pantalla','',
      'El jugador tiene un limite de tiempo para pronunciar las palabras','',
      'Puntos: 1 punto por cada palabra pronunciada correctamente, -1 punto por cada palabra que el jugador pase',
      ' ',
      'Modo Practice',
      'Aparecera 2 diferentes lista de palabras:',
      '- La "Lista completa" contiene todas las palabras que comienzan con la letra escogida ',
      '- La lista de "Necesita Practicar" contiene las palabras que comienzan con la letra escogida que la persona necesita practicar',
      'usar para escuchar la palabra',
      'usar para cambiar la velocidad de la voz',
      'usar para cambiar el tono de la voz',
      'usar para pasar la palabra',
      'usar para ver la palabra anterior',
      'usar para pronunciar la palabra y chequear si la persona esta pronunciando bien la palabra.'

    ],
    'zh': [
      'Play Mode',
      'After pressing the start button, player will hear a beep sound that means that the device is listening. ',' ',
      "After a player stops to talk, he/she  will hear another beep sound that means that the device recieves the player's voice."
          "Then the player will hear again the first beep sound follows by the second beep sound, if the device recieves the player's voice",''
          'A player pronounces the word. If he/she pronounces the word correctly another word appears','',
      'If a player does not know how to pronounce the word, she/he can click the right arrow to get another word','',
      'A player has a limited time to pronounce words correctly','',
      'Points: 1 point for each word that is pronouced correctly, -1 point for each word that is passed',
      ' ',
      'Practice Mode',
      'There are 2 difference lists of word:',
      '- "All" list is the list contains all words which begin with the chosen letter.',
      '- "Need improvement" list contains the words, which begin with the chosen letter, the user needs to practice.','',
      'use to listen a word',
      'use to change the rate of the speaker voice',
      'use to change the pitch of the speaker voice',
      'use to get the next word',
      'use to get previous word',
      'use to check if an user is pronounced a word correctly',
    ],
  };

  Map<int, Icon> icons = {
    17: Icon(Icons.volume_up),
    18: Icon(Icons.offline_bolt),
    19: Icon(Icons.equalizer),
    20: Icon(Icons.arrow_right),
    21: Icon(Icons.arrow_left),
    22: Icon(Icons.mic)
  };

  FontWeight font(String sentence) {
    if (sentence.contains("Mode") || sentence.contains("Modo")) {
      return FontWeight.bold;
    }
    return FontWeight.normal;
  }

  bool _isUse(String sentence) {
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
              padding: EdgeInsets.only(bottom: 10.0),
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
