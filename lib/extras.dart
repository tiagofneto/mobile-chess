import 'dart:async';

import 'package:chess/board.dart';
import 'package:chess/piece.dart';
import 'package:flutter/material.dart';

//FIXME height when empty
class DeadPieces extends StatelessWidget {
  final List<Widget> pieces;

  DeadPieces(this.pieces);

  @override
  Widget build(BuildContext context) {
    //TODO listview
    // return ListView.builder(
    //   shrinkWrap: true,
    //   itemCount: 10,
    //   itemBuilder: (_, index) => Text("TOP"),
    // );
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: Row(
            children: pieces,
          ),
        ),
      ),
    );
  }
}

//TODO Update to ListTile
class PlayerHeader extends StatelessWidget {
  final String name;
  final String time;
  final bool currentPlayer;

  PlayerHeader({this.name, this.time, this.currentPlayer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //TODO don't grow with name
            //TODO fading animation color
            decoration: BoxDecoration(
              color: currentPlayer ? Colors.green : Colors.yellow,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/guest.png'),
                  ),
                ),
                Text(name),
              ],
            ),
          ),
          Text(time)
        ],
      ),
    );
  }
}

class Game extends StatefulWidget {
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
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void _onPieceKilled(Piece piece) {
    setState(() {
      if (piece.color == "white") {
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

  //TODO find more automatic alternative
  String _timeFormat(Stopwatch timer) {
    int mins = timer.elapsed.inMinutes;
    int secs = timer.elapsed.inSeconds % Duration.secondsPerMinute;
    String min = mins < 10 ? "0" + mins.toString() : mins.toString();
    String sec = secs < 10 ? "0" + secs.toString() : secs.toString();

    return min + ":" + sec;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PlayerHeader(
          name: "Player 1",
          time: _timeFormat(timer1),
          currentPlayer: firstPlayer,
        ),
        DeadPieces(whiteKilled),
        Board(
          onPieceKilled: _onPieceKilled,
          onPlayerChanged: _onPlayerChanged,
        ),
        DeadPieces(blackKilled),
        PlayerHeader(
          name: "Player 2",
          time: _timeFormat(timer2),
          currentPlayer: !firstPlayer,
        ),
      ],
    );
  }
}
