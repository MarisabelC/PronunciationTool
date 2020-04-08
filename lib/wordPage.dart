import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'displayPage.dart';
import 'category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordPage extends StatefulWidget {
  WordPage({Key key, this.timer, this.language, this.isPractice, this.category})
      : super(key: key);
  bool isPractice;
  String language;
  Category category;
  int timer;
  final DisplayPage _displayPage = DisplayPage(
    title: 'Display',
  );

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  var _filteredWords = [];
  var _backgroundColor = Colors.deepPurpleAccent;
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('Search');
  var _wordList = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> _needList=[];
  DisplayPage _displayPage;
  List<String> _allList= [];
  Color _allColor = Colors.grey;
  Color _needColor = Colors.white70;
  bool _isAll = true;
  bool _isBar=true;
  String _previousText = '';
  Map<String, String> _all = {
    'en_US': 'All',
    'es_ES': 'Lista completa',
    'zh': '所有'
  };

  Map<String, String> _need = {
    'en_US': 'Need Improvement',
    'es_ES': 'Necesita Practicar',
    'zh': '需要改善'
  };

  _WordPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty)
        setState(() => _searchText = '');
      else
        setState(() => _searchText = _filter.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _wordList = widget.category.words();
    _allList=_wordList;
    _filteredWords = _wordList;
    _getList();
    _displayPage= DisplayPage(
      category: widget.category,
      title: '',
      language: widget.language,
      startTime: widget.timer,
      isPractice: widget.isPractice,
      needList: _needList,
    );

//    print(_needList.storage);
  }

  Future<void> _getList() async {
    final SharedPreferences prefs = await _prefs;
//    prefs.clear();
    setState(() {
      _needList = prefs.getStringList(widget.language+'-'+widget.category.letter) ?? List.from(_allList);
      print(_needList);
    });
  }

  Future<void> _setList() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList(widget.language+'-'+widget.category.letter, _needList);
  }

  void _searchPressed() {
    setState(() {
      _isBar=false;
      if (_searchIcon.icon == Icons.search) {
        print('search');
        _searchIcon = Icon(Icons.close);
        _appBarTitle = TextField(
          controller: _filter,
          autofocus: true,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        resetIcon();
      }
    });
  }

  void resetIcon() {
    _isBar=true;
    _searchIcon = Icon(Icons.search);
    _appBarTitle = Text('Search');
    if (!_isAll){
      swapColor(true);
    }
    _filteredWords = _wordList;
    _filter.clear();
    _previousText='';

  }

  void swapColor(bool flag) {
    if (_isAll != flag) {
      _isAll=flag;
      Color temp = _allColor;
      setState(() {
        _allColor = _needColor;
        _needColor = temp;
        if (_isAll) {
          _wordList = _allList;
          print(_wordList);
        }
        else
          _wordList= _needList;
      });
    }
  }

  Widget updateListView() {
    if (_previousText.length>_searchText.length) {
      _filteredWords = _wordList;
      print('update');
    }
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < _filteredWords.length; i++) {
        if (_filteredWords[i]
            .contains(_searchText.toLowerCase())) {
          tempList.add(_filteredWords[i]);
        }
      }
      _filteredWords = tempList;
    } else
      _filteredWords = _wordList;
    setState(() {
      _previousText=_searchText;
    });

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredWords.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: FlatButton(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Container(
                    child: Text(
                      '${_filteredWords[index]}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              widget.category.index =
                  _allList.indexOf(_filteredWords[index]) - 1;
              navigateToDisplay(context);
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  void navigateToDisplay(BuildContext context) {
    resetIcon();
    _displayPage.needList=_needList;
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => (_displayPage)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: _appBarTitle,
        leading: IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ),
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/gradient.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: _isBar?Row(
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: Container(
                          child: FlatButton(
                              child: Text('All'),
                              onPressed: () {
                                swapColor(true);
                              }),
                          color: _allColor,
                        )),
                    Expanded(
                        flex: 5,
                        child: Container(
                          child: FlatButton(
                              child: Text('Need Improvement'),
                              onPressed: () {
                                if (_displayPage.needList.isNotEmpty) {
                                  _needList = _displayPage.needList;
                                  _setList();
                                }
                                swapColor(false);
                              }),
                          color: _needColor,
                        )),
                  ],
                ):Text(''),
              ),
            ),
            Expanded(flex: 8, child: updateListView()),
          ],
        ),
      ),
    );
  }
}

