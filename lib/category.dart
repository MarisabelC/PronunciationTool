import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
//import 'package:firebase_database/firebase_database.dart';

class Category {
//  DatabaseReference _ref = FirebaseDatabase.instance.reference();
  int index = -1;
  String language = 'en_US';
  String letter = 'a';
  final _categories = {};
  Set _set = Set();
  Map<String,String> _phonetic = {};

  Future<String> loadAsset(String file) async {
    return await rootBundle.loadString(file);
  }

  init() {
    _englishParser();
    _spanishParser();
    _chineseParser();
  }

  int _generateRandomNumber(int max) {
    Random rnd =  Random(DateTime.now().millisecondsSinceEpoch);
    return rnd.nextInt(max);
  }

  void _englishParser() {
    List<String> words;
    loadAsset('assets/wordlist.txt').then((value) {
      words = value.toLowerCase().split(RegExp(r"\s"));
//      print(words.length);
      words.sort();
      var validCharacters = RegExp(r'^[a-z]+$');
      _getWordMap(words, 2, validCharacters, 'en_US');
    });
  }

  void _spanishParser() {
    List<String> words;
    loadAsset('assets/spanishWords.txt').then((value) {
      words = value.split(RegExp(r"\s"));
      var validCharacters = RegExp(r'[a-z]+|$');
      _getChineseMap(words, 1, validCharacters, 'es_ES');
//      print(_categories['es_419']);
    });
  }

  void _chineseParser() {
    List<String> words;
    loadAsset('assets/chineseWords.txt').then((value) {
      words = value.split(RegExp(r"\s"));
      var validCharacters = RegExp(r'$');
      _getChineseMap(words, 1, validCharacters, 'zh');
//      print(_categories['zh_Hans_CN']);
    });
  }

  void _getChineseMap(
      List<String> words, int length, var validCharacters, String language) {
    Map<String, List<String>> map = {};
    var key;
    List<String> list = [];
    RegExp exp = new RegExp(r'^[a-z]$');

    for (String word in words) {
      if (!validCharacters.hasMatch(word) || word.length < length) {
//        print(word);
        continue;
      }
      if (exp.hasMatch(word)){
        if (list.isNotEmpty) {
          if (map.containsKey(key)) {
            list.addAll(map[key]);
          }
          map[key] = list;
          list = [];
        }
        key = word[0];
      } else if (word.isNotEmpty){
          if (language == 'zh') {
            int index = word.indexOf(')');
            String str = word.substring(0, index + 1);
            _phonetic[word.substring(index + 1, word.length)] = str;
//          print(word.substring(index+1,word.length)+' '+_phonetic[word.substring(index+1,word.length)]);
            list.add(word.substring(index + 1, word.length));
          }else
            list.add(word);
      }
    }
    map[key] = list;
    _categories[language] = map;
  }

  String getPhonetic(String word){
    return _phonetic[word];
  }
  void _getWordMap(
      List<String> words, int length, var validCharacters, String language) {
    Map<String, List<String>> map = {};
    var key;
    List<String> list = [];

    for (String word in words) {
      if (!validCharacters.hasMatch(word) || word.length < length) {
//        print(word);
        continue;
      }
      if (word.isNotEmpty && key == null) {
//        print('word'+word);
        key = word[0];
      }

      if (word[0] == key) {
        list.add(word.trim());
      } else {
        map[key] = list;
        key = word[0];
        list = [];
        list.add(word);
      }
    }
    map[key] = list;
    _categories[language] = map;
  }

  List<String> categories() {
    List<String> categoryList = [];
//    print(_categories);
    for (String key in _categories[language].keys) {
      categoryList.add(key);
    }
//    print(categoryList);
    return categoryList;
  }

  List<String> words() {
//    print(_categories[language][letter][0]);
    return _categories[language][letter];
  }

  String getNextRandomWord() {
    String index= letter;
    if ( letter == 'random a-z' || letter == 'aleatorio a-z' || letter =='随意 a-z') {
      const chars = "abcdefghijklmnopqrstuvwxyz";
      index = chars[_generateRandomNumber(chars.length)];

    }

    int size = _categories[language][index].length;
    String word = _categories[language][index][_generateRandomNumber(size)];
    if (!_set.contains(word)) {
      _set.add(word);
      return word;
    }
    if (size > _set.length) return getNextRandomWord();

    return null;
  }

  String getNextWord(bool isPractice) {
    print(isPractice);
    if (!isPractice) {
      return getNextRandomWord();
    }
    if (index < _categories[language][letter].length-1) index++;
    String word = _categories[language][letter][index];
    return word;
  }

  String getPreviousWord() {
    if (index > 0) index--;
    String word = _categories[language][letter][index];
    return word;
  }
}
