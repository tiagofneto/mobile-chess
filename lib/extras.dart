import 'package:chess/piece.dart';
import 'package:flutter/material.dart';

//FIXME height when empty
class DeadPieces extends StatelessWidget {
  final List<Widget> pieces;

  DeadPieces(this.pieces);

  @override
  Widget build(BuildContext context) {
    //TODO listview
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

class CheckIndicator extends StatelessWidget {
  final PieceColors player;

  CheckIndicator(this.player);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Check on " + player.toString().split('.').last),
      content: Text("The " + player.toString().split('.').last + " king is on check! Defend it!"),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Close"),
        ),
      ],
    );
  }
}
