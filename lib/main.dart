import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'HateResponse.dart';
import 'NameResponse.dart';

void main() => runApp(HelloFlutterApp());

class HelloFlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(title: "Laurynas tries Flutter"),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _cf;
  TextEditingController _cs;
  TextEditingController _cp;
  int _matchDifference = 20;
  String _firstName;
  String _secondName;
  int _actual = 0;
  String _percentageGuessInput = "0";
  String _percentageGuess;
  int _score = 0;
  bool _hideProgress = true;
  bool _allowRefresh = false;

  @override
  void initState() {
    _cf = new TextEditingController();
    _cs = new TextEditingController();
    _cp = new TextEditingController();
    setState(() {
      _getNames();
    });
    super.initState();
  }

  @override
  void dispose() {
    _cf?.dispose();
    _cs?.dispose();
    _cp?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Friendship Calculator Game"),
        ),
        body: new Center(
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                    /*1*/
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*2*/
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "$_firstName",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "$_secondName",
                          style: TextStyle(
                            color: Colors.green[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*3*/
                  Icon(
                    Icons.star,
                    color: Colors.red[500],
                  ),
                  Text("$_score"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: TextField(
                decoration:
                    InputDecoration(hintText: 'Guess match % percentage'),
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() {
                  _percentageGuessInput = v;
                }),
                controller: _cp,
              ),
            ),
            Builder(
              builder: (context) => Center(
                child: _hideProgress
                    ? new RaisedButton(
                        child: new Text("Guess"),
                        onPressed: (_allowRefresh) ? null : () => _guessButtonFunction(context),
                      )
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ),
            new RaisedButton(
              child: new Text("Refresh"),
              onPressed: (_allowRefresh) ? () => _getNames() : null,
            ),
            Container(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                    /*1*/
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text("Guessed: $_percentageGuess"),
                      ],
                    ),
                  ),
                  Expanded(
                    /*1*/
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        new Text("Actual: $_actual"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 32, right: 32),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  setState(() {
                    _score = 0;
                    _percentageGuess = "0";
                    _actual = 0;
                    _hideProgress = true;
                    _allowRefresh = false;
                  });
                  _cp.text = "";
                  _getNames();
                },
                color: Colors.red[300],
                child: Text(
                  "New Game",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Raleway',
                    fontSize: 20.0,
                  ),
                ),
              ),
            )
          ],
        )));
  }

  Future<HateResponse> _getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://love-calculator.p.rapidapi.com/getPercentage?fname=$_firstName&sname=$_secondName"),
        headers: {
          "Accept": "application/json",
          "X-RapidAPI-Host": "love-calculator.p.rapidapi.com",
          "X-RapidAPI-Key": "2575df1819mshbd06206b6d09188p1523ecjsnb9f2b1a1f47b"
        });

    final data = json.decode(response.body);
    HateResponse hateResponse = HateResponse.fromJson(data);
    return hateResponse;
  }

  _outputResult(BuildContext context, HateResponse hateResponse) {
    _actual = int.parse(hateResponse.percentage);
    int _result;
    if ((_actual - int.parse(_percentageGuess)).abs() < _matchDifference) {
      _result = _score + 1;
      _showToast(context,
          "You guessed close enough: ${(_actual - int.parse(_percentageGuess)).abs()}");
    } else {
      _result = 0;
      _showToast(context,
          "DISSAPOINTED! Max difference $_matchDifference, yours: ${(_actual - int.parse(_percentageGuess)).abs()}");
    }
    _getNames();
    setState(() {
      _score = _result;
      _cp.text = "";
    });
  }

  _getNames() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://www.behindthename.com/api/random.json?usage=ita&gender=f&key=la567623908"),
        headers: {
          "Accept": "application/json",
          "usage": "ita",
          "gender": "f",
          "key": "la567623908"
        });

    final data = json.decode(response.body);
    NameResponse nameResponse = NameResponse.fromJson(data);
    setState(() {
      _firstName = nameResponse.names[0];
      _secondName = nameResponse.names[1];
      _allowRefresh = false;
    });
  }

  _showToast(BuildContext context, String text) {
    final scaffold = Scaffold.of(context);
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
            label: 'HIDE', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  _runGuessMethod(BuildContext context) {
    setState(() {
      _hideProgress = false;
    });
    _percentageGuess = _percentageGuessInput;
    _getData().then((hateResponse) {
      setState(() {
        _hideProgress = true;
      });
      if (hateResponse.percentage == null) {
        _showToast(context, "Names incorrect. Refresh!");
        setState(() {
          _allowRefresh = true;
        });
      } else {
        _outputResult(context, hateResponse);
        setState(() {
          _allowRefresh = false;
        });
      }
    });
  }

  _guessButtonFunction(BuildContext context) {
    (_cp.text.isNotEmpty)
        ? _runGuessMethod(context)
        : _showToast(context, "Enter your guess!");
  }
}


