import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class TextToVoice {
  FlutterTts _flutterTts;
  final String language;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.50;
  TextToVoice({this.language});

  String newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  initTts() {
    print('init');
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage(language);
    _flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });

    _flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });

    _flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      ttsState = TtsState.stopped;
    });
  }

  Future speak() async {
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.setPitch(pitch);

    if (newVoiceText != null) {
      if (newVoiceText.isNotEmpty) {
        var result = await _flutterTts.speak(newVoiceText);
        if (result == 1) ttsState = TtsState.playing;
      }
    }
  }

  Future stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }
}
