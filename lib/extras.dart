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
