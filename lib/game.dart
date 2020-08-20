import 'dart:async';

import 'package:chess/extras.dart';
import 'package:chess/board.dart';
import 'package:chess/piece.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  final Color color1;
  final Color color2;
  final String name1;
  final String name2;

  Game({this.color1, this.color2, this.name1, this.name2});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Piece> whiteKilled;
  List<Piece> blackKilled;
  bool firstPlayer;
  Stopwatch timer1;
  Stopwatch timer2;

  @override
  void initState() {
    super.initState();
    whiteKilled = List<Piece>();
    blackKilled = List<Piece>();
    firstPlayer = true;
    timer1 = Stopwatch();
    timer1.start();
    timer2 = Stopwatch();
    //FIXME optimize
    //TODO when navigator pops, stop timer
    //TODO stop using stopwatch
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  //TODO stop timer
  @override
  void dispose() {
    super.dispose();
  }

  void _onPieceKilled(Piece piece) {
    setState(() {
      if (piece.color == PieceColors.white) {
        whiteKilled.add(piece);
      } else {
        blackKilled.add(piece);
      }
    });
  }

  void _onPlayerChanged() {
    setState(() {
      firstPlayer = !firstPlayer;
      if (timer1.isRunning) {
        timer1.stop();
        timer2.start();
      } else {
        timer2.stop();
        timer1.start();
      }
    });
  }

  //TODO find automatic alternative
  String _timeFormat(Stopwatch timer) {
    int mins = timer.elapsed.inMinutes;
    int secs = timer.elapsed.inSeconds % Duration.secondsPerMinute;
    String min = mins < 10 ? "0" + mins.toString() : mins.toString();
    String sec = secs < 10 ? "0" + secs.toString() : secs.toString();

    return min + ":" + sec;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chess"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          PlayerHeader(
            name: widget.name1,
            time: _timeFormat(timer1),
            currentPlayer: firstPlayer,
          ),
          DeadPieces(whiteKilled),
          Board(
            color1: widget.color1,
            color2: widget.color2,
            onPieceKilled: _onPieceKilled,
            onPlayerChanged: _onPlayerChanged,
            onCheck: (PieceColors currentPlayer) {
              showDialog(
                context: context,
                builder: (_) => CheckIndicator(currentPlayer),
              );
            },
          ),
          DeadPieces(blackKilled),
          PlayerHeader(
            name: widget.name2,
            time: _timeFormat(timer2),
            currentPlayer: !firstPlayer,
          ),
        ],
      ),
    );
  }
}
