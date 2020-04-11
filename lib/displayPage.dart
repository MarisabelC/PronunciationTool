import 'package:flutter/material.dart';
import 'dart:async';
import 'category.dart';
import 'package:flutter/cupertino.dart';
import 'scorePage.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:screen/screen.dart';
import 'textToVoice.dart';
import 'wordPage.dart';

class DisplayPage extends StatefulWidget {
  DisplayPage(
      {Key key,
      this.title,
      this.category,
      this.language,
      this.startTime,
      this.isPractice,
      this.needList})
      : super(key: key);
  final String title;
  final bool isPractice;
  final Category category;
  final String language;
  final startTime;
  List<String> needList;

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  TextToVoice _texToVoice;
  String _word;
  var _letterColor = Colors.black54;
  var _backgroundColor = Colors.deepPurpleAccent;
  Timer _timer;
  int _time;
  bool _visible = false;
  int _score = 0;
  final SpeechToText speech = SpeechToText();
  ScorePage _scorePage;
  bool _isTry = false;
  double level = 0.0;
  Map<String, String> _correct = {
    'en_US': 'correct',
    'es_ES': 'correcto',
    'zh': '正确'
  };
  Map<String, String> _repeat = {
    'en_US': 'repeat after me. ',
    'es_ES': 'repite despues de mi.  ',
    'zh': '重复, '
  };
  Map<String, String> _try = {
    'en_US': 'try again',
    'es_ES': 'intenta otra vez',
    'zh': '再试一次'
  };

  Map<String, String> _start = {
    'en_US': 'Start',
    'es_ES': 'Empezar',
    'zh': '开始'
  };

  @override
  void initState() {
    super.initState();
    _texToVoice = TextToVoice(language: widget.language.replaceAll('_', '-'));
    _getWord();
    _texToVoice.initTts();
    initSpeechState();
    Screen.keepOn(true);
    _time = widget.startTime;
    _scorePage = ScorePage(
      title: 'Score',
      goodScore: widget.startTime / 5,
      language: widget.language,
    );
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
    speech.stop();
    Screen.keepOn(false);
    _texToVoice.stop();
  }

  void _startTimer() {
//    _start=10;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_time < 1) {
            timer.cancel();
            stopListening();
            Screen.keepOn(false);
            if (!widget.isPractice) {
              _scorePage.score = _score;
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => _scorePage),
              );
            }
          } else {
            _time = _time - 1;
            if (!speech.isListening) {
              startListening();
              print('start');
            }
          }
        },
      ),
    );
  }

  void _incrementScore() {
    setState(() => _score += 1);
  }

  void _decrementScore() {
    setState(() => _score -= 1);
  }

  void _getWord() {
    setState(() {
      _word = widget.category.getNextWord(widget.isPractice);
    });
    if (_word == null) {
      _scorePage.score = _score;
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => _scorePage),
      );
    }
  }

  void _getPreviousWord() {
    setState(() {
      _word = widget.category.getPreviousWord();
    });
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize();

    if (!mounted) return;
  }

  void startListening() {
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: widget.startTime),
        localeId: widget.language,
        cancelOnError: true,
        onSoundLevelChange: soundLevelListener,
        partialResults: false);
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    String text =
        "${result.recognizedWords} - ${result.finalResult}".toLowerCase();
    checkResult(text);
  }

  void checkResult(String text) {
    List<String> wordList = _word.split(RegExp(r"\s|/"));
    print(wordList);
    List<String> textList = text.substring(0, text.indexOf('-')).split(" ");
    setState(() {
      for (String data in wordList) {
        for (int j = 0; j < textList.length; j++) {
          print(textList[j] + ' - ' + data);
          if (data == textList[j]) {
            if (_time>1) {
              _texToVoice.newVoiceText = _correct[widget.language];
              _texToVoice.speak();
            }
            if (!widget.isPractice) {
              _getWord();
              _incrementScore();
            } else {
              widget.needList.remove(_word);
              print(widget.needList);
              print(widget.needList.indexOf(_word));
            }
            print('************return');
            return;
          }
        }
      }
      if (widget.isPractice && !_isTry) {
        _texToVoice.newVoiceText = _try[widget.language];
        _texToVoice.speak();
        _isTry = true;
      }
    });
  }

  Widget _rate() {
    return Slider(
      value: _texToVoice.rate,
      onChanged: (newRate) {
        setState(() => _texToVoice.rate = newRate);
      },
      min: 0.1,
      max: 1.0,
      divisions: 10,
      label: "Rate: ${_texToVoice.rate.toStringAsFixed(2)}",
      activeColor: Colors.black54,
    );
  }

  Widget _pitch() {
    return Slider(
      value: _texToVoice.pitch,
      onChanged: (newPitch) {
        setState(() => _texToVoice.pitch = newPitch);
      },
      min: 0.5,
      max: 2.0,
      divisions: 15,
      label: "Pitch: ${_texToVoice.pitch.toStringAsFixed(1)}",
      activeColor: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Text(widget.title),
      ),
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/gradient.jpg'), fit: BoxFit.cover),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: _visible,
                child: Expanded(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Time',
                                style: TextStyle(
                                  color: _letterColor,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                "$_time",
                                style: TextStyle(
                                  color: _letterColor,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width / 10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Score:',
                                style: TextStyle(
                                  color: _letterColor,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                '$_score',
                                style: TextStyle(
                                  color: _letterColor,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Visibility(
                  visible: _visible || widget.isPractice,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Container(
                          alignment: widget.isPractice
                              ? Alignment.bottomCenter
                              : Alignment.center,
                          child: Text(
                            '$_word',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _letterColor,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                            alignment: Alignment.topCenter,
                            child: widget.language == 'zh' && widget.isPractice
                                ? Text(
                                    '${widget.category.getPhonetic("$_word")}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _letterColor,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      fontSize: 30,
                                    ),
                                  )
                                : Text('')),
                      ),
                      Visibility(
                        visible: widget.isPractice,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      alignment: Alignment.centerRight,
                                      icon: Icon(Icons.offline_bolt),
                                      tooltip: 'speed',
                                    ),
                                  ),
//
                                ),
                                Expanded(flex: 8, child: _rate()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.equalizer,
                                            size: 30,
                                          ),
                                          tooltip: 'pitch',
                                          alignment: Alignment.centerRight)),
                                ),
                                Expanded(flex: 8, child: _pitch()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: widget.isPractice
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                  ),
                                  tooltip: 'back',
                                  onPressed: () {
                                    cancelListening();
                                    setState(() {
                                      _getPreviousWord();
                                    });
                                  },
                                ),
                              )
//
                              ),
                          Expanded(
                              flex: 4,
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.volume_up,
                                    size: 30,
                                  ),
                                  tooltip: 'listen',
                                  onPressed: () {
                                    cancelListening();
                                    String str = _word;
                                    int index = _word.indexOf('/');
                                    if (index != -1) {
                                      str = str.substring(0, index);
                                    }
                                    _texToVoice.newVoiceText =
                                        _repeat[widget.language] + str;
                                    _texToVoice.speak();
                                    _isTry = false;
                                  },
                                ),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: .26,
                                      spreadRadius: level * 1.5,
                                      color: Colors.black.withOpacity(.5))
                                ],
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.mic),
                                onPressed: () {
                                  startListening();
                                  _isTry = false;
                                },
                                tooltip: 'repeat',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  size: 30,
                                ),
                                onPressed: () {
                                  cancelListening();
                                  setState(() {
                                    _getWord();
                                  });
                                },
                                tooltip: 'next',
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                      children: <Widget>[
                        Expanded(
                          flex:8,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: Visibility(
                                    visible: !_visible,
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: ButtonTheme(
                                        minWidth:
                                            MediaQuery.of(context).size.width / 2,
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(color: Colors.white)),
                                          color: Colors.black54,
                                          textColor: Colors.white,
                                          disabledColor: Colors.grey,
                                          disabledTextColor: Colors.black,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.blueAccent,
                                          onPressed: () {
                                            _visible = !_visible;
                                            _texToVoice.newVoiceText = '3. 2. 1. go';
                                            _texToVoice.speak();
                                            Future.delayed(
                                                const Duration(milliseconds: 1500),
                                                () {
                                              startListening();
                                              _startTimer();
                                            });
                                          },
                                          child: Text(
                                            _start[widget.language],
                                            style: TextStyle(fontSize: 25.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Visibility(
                                    visible: _visible,
                                    child: IconButton(
                                      alignment: Alignment.topCenter,
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        startListening();
                                        _decrementScore();
                                        setState(() {
                                          _getWord();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ),
                        Visibility(
                          visible: _visible,
                          child: Expanded(
                            flex: 4,
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: .26,
                                      spreadRadius: level * 1.5,
                                      color: Colors.black.withOpacity(.5))
                                ],
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.mic),
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 2, child: Text(''),)
                      ],
                    ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
