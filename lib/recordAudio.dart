//import 'dart:io';
//import 'dart:typed_data' show Uint8List;
//import 'package:flutter/material.dart';
//
//import 'dart:async';
//import 'package:flutter_sound/flutter_sound.dart';
//import 'package:flutter_sound/android_encoder.dart';
//import 'package:flutter/services.dart' show rootBundle;
//
//enum t_MEDIA
//{
//  FILE,
//  BUFFER,
//  ASSET,
//  STREAM,
//}
//
//class RecordAudio {
//  bool _isRecording = false;
//  List <String> _path = [null, null, null, null, null, null, null];
//  StreamSubscription _recorderSubscription;
//  StreamSubscription _dbPeakSubscription;
//  StreamSubscription _playerSubscription;
//  FlutterSound flutterSound;
//
//  String _recorderTxt = '00:00:00';
//  String _playerTxt = '00:00:00';
//  double _dbLevel;
//
//  double sliderCurrentPosition = 0.0;
//  double maxDuration = 1.0;
//  t_MEDIA _media = t_MEDIA.FILE;
//  t_CODEC _codec = t_CODEC.CODEC_AAC;
//
//
//  static const List<String> paths =
//  [
//    'sound.aac', // DEFAULT
//    'sound.aac', // CODEC_AAC
//    'sound.opus', // CODEC_OPUS
//    'sound.caf', // CODEC_CAF_OPUS
//    'sound.mp3', // CODEC_MP3
//    'sound.ogg', // CODEC_VORBIS
//    'sound.wav', // CODEC_PCM
//  ];
//
//  void startRecorder() async {
//    try {
//      String path = await flutterSound.startRecorder
//        (
//        paths[_codec.index],
//        codec: _codec,
//        sampleRate: 16000,
//        bitRate: 16000,
//        numChannels: 1,
//        androidAudioSource: AndroidAudioSource.MIC,
//      );
//      print('startRecorder: $path');
//
//      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
//        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//            e.currentPosition.toInt(),
//            isUtc: true);
//        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
//
//        setState(() {
//          this._recorderTxt = txt.substring(0, 8);
//        });
//      });
//      _dbPeakSubscription =
//          flutterSound.onRecorderDbPeakChanged.listen((value) {
//            print("got update -> $value");
//            setState(() {
//              this._dbLevel = value;
//            });
//          });
//
//      this.setState(() {
//        this._isRecording = true;
//        this._path[_codec.index] = path;
//      });
//    } catch (err) {
//      print('startRecorder error: $err');
//      setState(() {
//        this._isRecording = false;
//      });
//    }
//  }
//
//  void stopRecorder() async {
//    try {
//      String result = await flutterSound.stopRecorder();
//      print('stopRecorder: $result');
//
//      if (_recorderSubscription != null) {
//        _recorderSubscription.cancel();
//        _recorderSubscription = null;
//      }
//      if (_dbPeakSubscription != null) {
//        _dbPeakSubscription.cancel();
//        _dbPeakSubscription = null;
//      }
//    } catch (err) {
//      print('stopRecorder error: $err');
//    }
//    this.setState(() {
//      this._isRecording = false;
//    });
//  }
//
//  Future<bool> fileExists(String path) async {
//    return await File(path).exists();
//  }
//
//  Future <Uint8List> makeBuffer(String path) async {
//    try {
//      if (!await fileExists(path))
//        return null;
//      File file = File(path);
//      file.openRead();
//      var contents = await file.readAsBytes();
//      print('The file is ${contents.length} bytes long.');
//      return contents;
//    } catch (e) {
//      print(e);
//      return null;
//    }
//  }
//
//  List<String>assetSample =
//  [
//    'assets/samples/sample.aac',
//    'assets/samples/sample.aac',
//    'assets/samples/sample.opus',
//    'assets/samples/sample.caf',
//    'assets/samples/sample.mp3',
//    'assets/samples/sample.ogg',
//    'assets/samples/sample.wav',
//  ];
//
//  void startPlayer() async {
//    try {
//      String path = null;
//      if (_media == t_MEDIA.ASSET) {
//        Uint8List buffer = (await rootBundle.load(assetSample[_codec.index]))
//            .buffer.asUint8List();
//        path = await flutterSound.startPlayerFromBuffer(buffer);
//      } else if (_media ==
//          t_MEDIA.FILE) { // Do we want to play from buffer or from file ?
//        if (await fileExists(_path[_codec.index]))
//          path =
//          await flutterSound.startPlayer(this._path[_codec.index]); // From file
//      } else if (_media ==
//          t_MEDIA.BUFFER) { // Do we want to play from buffer or from file ?
//        if (await fileExists(_path[_codec.index])) {
//          Uint8List buffer = await makeBuffer(this._path[_codec.index]);
//          if (buffer != null)
//            path =
//            await flutterSound.startPlayerFromBuffer(buffer); // From buffer
//        }
//      }
//      if (path == null) {
//        print('Error starting player');
//        return;
//      }
//      print('startPlayer: $path');
//      await flutterSound.setVolume(1.0);
//
//      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
//        if (e != null) {
//          sliderCurrentPosition = e.currentPosition;
//          maxDuration = e.duration;
//
//
//          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//              e.currentPosition.toInt(),
//              isUtc: true);
//          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
//          this.setState(() {
//            //this._isPlaying = true;
//            this._playerTxt = txt.substring(0, 8);
//          });
//        }
//      });
//    } catch (err) {
//      print('error: $err');
//    }
//    setState(() {});
//  }
//
//  void stopPlayer() async {
//    try {
//      String result = await flutterSound.stopPlayer();
//      print('stopPlayer: $result');
//      if (_playerSubscription != null) {
//        _playerSubscription.cancel();
//        _playerSubscription = null;
//      }
//      sliderCurrentPosition = 0.0;
//    } catch (err) {
//      print('error: $err');
//    }
//    this.setState(() {
//      //this._isPlaying = false;
//    });
//  }
//
//  void pausePlayer() async {
//    String result;
//    try {
//      if (flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED) {
//        result = await flutterSound.resumePlayer();
//        print('resumePlayer: $result');
//      } else {
//        result = await flutterSound.pausePlayer();
//        print('pausePlayer: $result');
//      }
//    } catch (err) {
//      print('error: $err');
//    }
//    setState(() {});
//  }
//
//  void seekToPlayer(int milliSecs) async {
//    String result = await flutterSound.seekToPlayer(milliSecs);
//    print('seekToPlayer: $result');
//  }
//
//
//  onPausePlayerPressed() {
//    return flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING ||
//        flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED ? pausePlayer : null;
//  }
//
//  onStopPlayerPressed() {
//    return flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING ||
//        flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED ? stopPlayer : null;
//  }
//
//  onStartPlayerPressed() {
//    if (_media == t_MEDIA.FILE || _media == t_MEDIA.BUFFER) {
//      if (_path[_codec.index] == null)
//        return null;
//    }
//    return flutterSound.audioState == t_AUDIO_STATE.IS_STOPPED
//        ? startPlayer
//        : null;
//  }
//
//  onStartRecorderPressed() {
//    if (_media == t_MEDIA.ASSET || _media == t_MEDIA.BUFFER)
//      return null;
//    if (flutterSound.audioState == t_AUDIO_STATE.IS_RECORDING)
//      return stopRecorder;
//    return flutterSound.audioState == t_AUDIO_STATE.IS_STOPPED
//        ? startRecorder
//        : null;
//  }
//
//  AssetImage recorderAssetImage() {
//    if (onStartRecorderPressed() == null)
//      return AssetImage('res/icons/ic_mic_disabled.png');
//    return flutterSound.audioState == t_AUDIO_STATE.IS_STOPPED ? AssetImage(
//        'res/icons/ic_mic.png') : AssetImage('res/icons/ic_stop.png');
//  }
//}