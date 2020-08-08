import 'package:chess/board.dart';
import 'package:chess/piece.dart';
import 'package:flutter/material.dart';

//FIXME height when empty
class DeadPieces extends StatelessWidget {
  final List<Widget> pieces;

  DeadPieces(this.pieces);

  @override
  Widget build(BuildContext context) {
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

//TODO profile pic, timer
class PlayerHeader extends StatelessWidget {
  final String name;
  final String time;

  PlayerHeader({this.name, this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              // CircleAvatar(
              //   backgroundImage: AssetImage('images/blackPawn.png'),
              // ),
              Text(name),
            ],
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

  @override
  void initState() {
    super.initState();
    whiteKilled = List<Piece>();
    blackKilled = List<Piece>();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PlayerHeader(
          name: "Player 1",
          time: "MN:SC",
        ),
        DeadPieces(whiteKilled),
        Board(onPieceKilled: _onPieceKilled),
        DeadPieces(blackKilled),
        PlayerHeader(
          name: "Player 2",
          time: "MN:SC",
        ),
      ],
    );
  }
}
