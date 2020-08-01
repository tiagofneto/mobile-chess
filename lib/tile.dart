import 'package:flutter/material.dart';
import 'package:chess/piece.dart';

class Tile extends StatefulWidget {
  Piece piece;
  final Color color;

  Tile(this.color, this.piece);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    //TODO por o callback
    return Container(
      child: widget.piece,
      color: widget.color,
    );
  }
}

class Position {
  int x;
  int y;

  Position(this.x, this.y);
}
