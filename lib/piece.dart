import 'package:flutter/material.dart';
import 'package:chess/tile.dart';

//TODO create facotry (image to name)
abstract class Piece extends StatelessWidget {
  final String image;
  final String color;
  final Position pos;

  Piece(this.image, this.color, this.pos);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/$color$image.png');
  }

  List<List<Position>> listMoves();
}

class Pawn extends Piece {
  Pawn(String color, Position pos) : super("Pawn", color, pos);

  @override
  List<List<Position>> listMoves() {
    // TODO: implement listMoves
    return pos.getStraight();
  }
}

class Rook extends Piece {
  Rook(String color, Position pos) : super("Rook", color, pos);

  @override
  List<List<Position>> listMoves() {
    // TODO: implement listMoves
    return pos.getStraight();
  }
}

class Knight extends Piece {
  Knight(String color, Position pos) : super("Knight", color, pos);

  @override
  List<List<Position>> listMoves() {
    // TODO: implement listMoves
    return pos.getStraight();
  }
}

class Bishop extends Piece {
  Bishop(String color, Position pos) : super("Bishop", color, pos);

  @override
  List<List<Position>> listMoves() {
    // TODO: implement listMoves
    return pos.getStraight();
  }
}

class Queen extends Piece {
  Queen(String color, Position pos) : super("Queen", color, pos);

  @override
  List<List<Position>> listMoves() {
    // TODO: implement listMoves
    return pos.getStraight();
  }
}

class King extends Piece {
  King(String color, Position pos) : super("King", color, pos);

  @override
  List<List<Position>> listMoves() {
    // TODO: implement listMoves
    return pos.getStraight();
  }
}
