import 'package:flutter/material.dart';
import 'package:chess/tile.dart';

//TODO create facotry (image to name)
abstract class Piece extends StatelessWidget {
  final String image;
  final String color;
  Position pos;

  Piece(this.image, this.color, this.pos);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/$color$image.png');
  }

  // Iterator<List<Position>> listMoves();

  // void _removeSelf(List<List<Position>> moves) {
  //   for (List<Position> move in moves) {
  //     move.remove(pos);
  //   }
  // }
}

class Pawn extends Piece {
  Pawn(String color, Position pos) : super("Pawn", color, pos);

  // @override
  // List<List<Position>> listMoves() {}
}

class Rook extends Piece {
  Rook(String color, Position pos) : super("Rook", color, pos);

  // @override
  // Iterator<List<Position>> listMoves() {
  //   List<List<Position>> moves;
  //   for (int i = 0; i < 8; i++) {
  //     moves[0].add(Position(i, pos.x));
  //     moves[1].add(Position(i, pos.y));
  //   }
  //   _removeSelf(moves);
  //   return moves.iterator;
  // }
}

class Knight extends Piece {
  Knight(String color, Position pos) : super("Knight", color, pos);
}

class Bishop extends Piece {
  Bishop(String color, Position pos) : super("Bishop", color, pos);
}

class Queen extends Piece {
  Queen(String color, Position pos) : super("Queen", color, pos);
}

class King extends Piece {
  King(String color, Position pos) : super("King", color, pos);
}
